import { CommonService } from './../../services/common.service';
import { Component } from '@angular/core';
import { CategoryService } from '../../services/category.service';

@Component({
  selector: 'app-category',
  templateUrl: './category.component.html',
  styleUrl: './category.component.css'
})
export class CategoryComponent {
  categories: any[] = [];
  totalRecords = 0;
  pageSize = 10;
  currentPage = 1;
  searchKeyword = '';
  statusFilter = '';

  Math = Math;

  constructor(private categoryService: CategoryService, private CommonService:CommonService) {}

  ngOnInit() {
    this.loadCategories();
  }
  loadCategories() {
    const searchParams = {
      PageNumber: this.currentPage,
      PageSize: this.pageSize,
      Keyword: this.searchKeyword,
      Status: this.statusFilter,
      SortBy: '',
      SortDir: ''
    };
  
    this.categoryService.searchCategories(searchParams).subscribe(response => {
      this.categories = response.data;
      this.totalRecords = response.totalRecords;
    }, error => {
      console.error('Error loading categories', error);
    });
  }
  
  onPageChange(page: number): void {
    if (page >= 1 && page <= Math.ceil(this.totalRecords  / this.pageSize)) {
      this.currentPage = page;
      this.loadCategories();
    }
  }
  onSearch() {
    this.currentPage = 1;
    this.loadCategories();
  }
  deleteCategory(id: number): void {
    this.categoryService.checkCategoryHasProducts(id).subscribe(
      async hasProducts => {
        if (hasProducts) {
          this.CommonService.showAutoCloseAlert("warning","Warning","Cannot delete because it contains products");
        } else {
          if (
            await this.CommonService.showConfirmation("Warning", "Bạn có muốn xóa danh mục", "Oke", "Cancel")
          ) {
            this.categoryService.deleteCategory(id).subscribe(
              response => {
                this.CommonService.showAutoCloseAlert("success","Success","Delete category successfully");
                this.loadCategories();
              },
              error => {
                console.error('Error deleting category:', error);
              }
            );
          }
        }
      },
      error => {
        console.error('Error checking category for products:', error);
      }
    );
  }
}