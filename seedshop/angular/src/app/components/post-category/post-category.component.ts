import { CommonService } from './../../services/common.service';
import { Component } from '@angular/core';
import { PostCategoryService } from '../../services/post-category.service';
import { PostCategory } from '../../interfaces/post-category';
@Component({
  selector: 'app-post-category',
  templateUrl: './post-category.component.html',
  styleUrl: './post-category.component.css'
})
export class PostCategoryComponent {
  postCategories: any;
  totalRecords = 0;
  pageSize = 10;
  currentPage = 1;
  searchKeyword = '';
  statusFilter = '';

  Math = Math;

  constructor(private postCategoryService: PostCategoryService, private CommonService:CommonService) {}

  ngOnInit() {
    this.loadPostCategories();
  }

  loadPostCategories() {
    const searchParams = {
      PageNumber: this.currentPage,
      PageSize: this.pageSize,
      Keyword: this.searchKeyword,
      Status: this.statusFilter,
      SortBy: '',
      SortDir: ''
    };
  
    this.postCategoryService.searchPostCategories(searchParams).subscribe(
      response => {
        this.postCategories = response.data; 
        this.totalRecords = response.totalRecords; // Lấy từ API
      },
      error => {
        console.error('Error loading post categories', error);
      }
    );
  }
  

  onPageChange(page: number): void {
    if (page >= 1 && page <= Math.ceil(this.totalRecords / this.pageSize)) {
      this.currentPage = page;
      this.loadPostCategories();
    }
  }

  onSearch() {
    this.currentPage = 1;
    this.loadPostCategories();
  }

  async deletePostCategory(id: number): Promise<void> {
    
          if (await this.CommonService.showConfirmation("warning", "Bạn có muốn xóa bài viết này", "Oke", "Cancel")) {
            this.postCategoryService.deletePostCategory(id).subscribe(
              response => {
                this.CommonService.showAutoCloseAlert("success","Success","Delete post Successfully");
                this.loadPostCategories();
              },
              error => {
                console.error('Error deleting post category:', error);
              }
            );
          }
        }
      }
