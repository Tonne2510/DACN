import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { ProductService } from '../../../../services/product.service';
import { CategoryService } from '../../../../services/category.service';

@Component({
  selector: 'app-products-list',
  templateUrl: './products-list.component.html',
  styleUrl: './products-list.component.css'
})
export class ProductsListComponent implements OnInit {
  products: any[] = [];
  categories: any[] = [];
  loading = false;
  currentPage = 1;
  pageSize = 12;
  totalRecords = 0;
  totalPages = 0;

  // Filters
  priceFrom: number | null = null;
  priceTo: number | null = null;
  sortBy = 'createdAt';
  searchKeyword = '';

  constructor(
    private productService: ProductService,
    private categoryService: CategoryService,
    private route: ActivatedRoute
  ) { }

  ngOnInit() {
    // Check for query params first
    this.route.queryParams.subscribe(params => {
      if (params['search']) {
        this.searchKeyword = params['search'];
      }
      
      // Load categories then handle category filter
      this.loadCategories().then(() => {
        if (params['category']) {
          const categoryId = parseInt(params['category']);
          const category = this.categories.find(c => c.id === categoryId);
          if (category) {
            category.selected = true;
          }
        }
        this.loadProducts();
      });
    });
  }

  loadCategories(): Promise<void> {
    return new Promise((resolve) => {
      this.categoryService.searchCategories({
        pageNumber: 1,
        pageSize: 100,
        keyword: '',
        status: '1',
        sortBy: '',
        sortDir: ''
      }).subscribe({
        next: (response: any) => {
          this.categories = (response.data || []).map((cat: any) => ({
            ...cat,
            selected: false
          }));
          resolve();
        },
        error: (error) => {
          console.error('Error loading categories:', error);
          resolve();
        }
      });
    });
  }

  loadProducts() {
    this.loading = true;

    const selectedCategories = this.categories
      .filter(c => c.selected)
      .map(c => c.id);

    const filters: any = {
      pageNumber: this.currentPage,
      pageSize: this.pageSize,
      keyword: this.searchKeyword,
      status: '1',
      sortBy: '',
      sortDir: '',
      fromPrice: this.priceFrom || 0,
      toPrice: this.priceTo || 0,
      categoryId: selectedCategories.length > 0 ? selectedCategories[0].toString() : '',
      optionIds: []
    };

    console.log('Filters being sent:', filters);
    console.log('Selected categories:', selectedCategories);

    this.productService.searchProducts(filters).subscribe({
      next: (response: any) => {
        console.log('API Response:', response);
        this.products = response.data || [];
        this.totalRecords = response.totalRecords || 0;
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        this.loading = false;
      },
      error: (error) => {
        console.error('Error loading products:', error);
        this.loading = false;
      }
    });
  }

  applyFilters() {
    this.currentPage = 1;
    this.loadProducts();
  }

  resetFilters() {
    this.categories.forEach(c => c.selected = false);
    this.priceFrom = null;
    this.priceTo = null;
    this.sortBy = 'createdAt';
    this.searchKeyword = '';
    this.applyFilters();
  }

  goToPage(page: number) {
    if (page >= 1 && page <= this.totalPages) {
      this.currentPage = page;
      this.loadProducts();
      window.scrollTo({ top: 0, behavior: 'smooth' });
    }
  }

  getPageNumbers(): number[] {
    const pages: number[] = [];
    const maxVisible = 5;
    let start = Math.max(1, this.currentPage - Math.floor(maxVisible / 2));
    let end = Math.min(this.totalPages, start + maxVisible - 1);

    if (end - start < maxVisible - 1) {
      start = Math.max(1, end - maxVisible + 1);
    }

    for (let i = start; i <= end; i++) {
      pages.push(i);
    }
    return pages;
  }
}
