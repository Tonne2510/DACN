import { Component, OnInit } from '@angular/core';
import { Product } from '../../../interfaces/product';
import { ProductService } from '../../../services/product.service';
import { SearchParams } from '../../../services/search-params';
import { CommonService } from '../../../services/common.service';

@Component({
  selector: 'app-list-product',
  templateUrl: './list-product.component.html',
  styleUrl: './list-product.component.css'
})
export class ListProductComponent implements OnInit{
  products: Product[] = [];
  totalRecords = 0;
  pageSize = 10;
  currentPage = 1;
  searchKeyword = '';
  statusFilter = '';

  Math = Math;

  constructor(private productService: ProductService, private commonService:CommonService) {}

  ngOnInit() {
    this.loadProducts();
  }

  loadProducts() {
    const searchParams: SearchParams = {
      pageNumber: this.currentPage,
      pageSize: this.pageSize,
      keyword: this.searchKeyword,
      status: this.statusFilter,
      sortBy: '',
      sortDir: '',
      toPrice: 0,
      fromPrice: 0,
      categoryId: '',
      optionIds: []
    };
  
    this.productService.searchProducts(searchParams).subscribe(response => {
      this.products = response.data.map((product: Product) => {
        return {
          ...product,
          imageUrl: `http://localhost:5069/images/${product.image}`
        };
      });
      this.totalRecords = response.totalRecords;
    }, error => {
      console.error('Error loading products', error);
    });
  }
  
  onPageChange(page: number): void {
    if (page >= 1 && page <= Math.ceil(this.totalRecords / this.pageSize)) {
      this.currentPage = page;
      this.loadProducts();
    }
  }

  onSearch() {
    this.currentPage = 1;
    this.loadProducts();
  }

  async deleteProduct(id: number): Promise<void> {
    if (
      await this.commonService.showConfirmation("Cofirm", "Are you sure you want to delete this product?","Ok", "Cancel")
    ) {
      this.productService.deleteProduct(id).subscribe(
        response => {
          this.commonService.showAutoCloseAlert("success","Success","Delete product successfully");
          this.loadProducts();
        },
        error => {
          console.error('Error deleting product:', error);
        }
      );
    }
  }
}