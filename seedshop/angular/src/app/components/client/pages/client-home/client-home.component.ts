import { Component, OnInit } from '@angular/core';
import { ProductService } from '../../../../services/product.service';
import { CategoryService } from '../../../../services/category.service';
import { PostService } from '../../../../services/post.service';

@Component({
  selector: 'app-client-home',
  templateUrl: './client-home.component.html',
  styleUrl: './client-home.component.css'
})
export class ClientHomeComponent implements OnInit {
  categories: any[] = [];
  featuredProducts: any[] = [];
  latestPosts: any[] = [];

  constructor(
    private productService: ProductService,
    private categoryService: CategoryService,
    private postService: PostService
  ) { }

  ngOnInit() {
    this.loadCategories();
    this.loadFeaturedProducts();
    this.loadLatestPosts();
  }

  loadCategories() {
    this.categoryService.searchCategories({
      pageNumber: 1,
      pageSize: 8,
      status: '1'
    }).subscribe({
      next: (response: any) => {
        this.categories = response.data || [];
      },
      error: (error) => {
        console.error('Error loading categories:', error);
      }
    });
  }

  loadFeaturedProducts() {
    this.productService.searchProducts({
      pageNumber: 1,
      pageSize: 8,
      keyword: '',
      status: '1',
      sortBy: '',
      sortDir: '',
      fromPrice: 0,
      toPrice: 0,
      categoryId: '',
      optionIds: []
    }).subscribe({
      next: (response: any) => {
        this.featuredProducts = response.data || [];
      },
      error: (error) => {
        console.error('Error loading products:', error);
      }
    });
  }

  loadLatestPosts() {
    this.postService.searchPosts({
      PageNumber: 1,
      PageSize: 3,
      Keyword: '',
      Status: '',
      SortBy: 'CreatedAt',
      SortDir: 'desc',
      PostCategoryId: '',
      IsPublish: '' // Lấy tất cả posts
    }).subscribe({
      next: (response: any) => {
        this.latestPosts = response.data || [];
      },
      error: (error) => {
        console.error('Error loading posts:', error);
      }
    });
  }

  getImageUrl(imageName: string): string {
    if (!imageName) return '/assets/images/placeholder.jpg';
    return `http://localhost:5069/api/Account/getimage/${imageName}`;
  }

  stripHtml(html: string): string {
    if (!html) return '';
    
    // Create a temporary DOM element to decode HTML entities
    const txt = document.createElement('textarea');
    txt.innerHTML = html;
    let decoded = txt.value;
    
    // Remove HTML tags
    decoded = decoded.replace(/<[^>]*>/g, '');
    
    // Clean up whitespace
    decoded = decoded
      .replace(/\r\n/g, ' ')
      .replace(/\n/g, ' ')
      .replace(/\t/g, ' ')
      .replace(/\s+/g, ' ')
      .trim();
    
    return decoded;
  }
}
