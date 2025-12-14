import { Component, OnInit } from '@angular/core';
import { Post } from '../../../interfaces/post';
import { PostService } from '../../../services/post.service';
import { SearchParams } from '../../../services/search-params';
import { SearchPostParams } from '../../../services/search-post-params';
import { PostCategory } from '../../../interfaces/post-category';
import { PostCategoryService } from '../../../services/post-category.service';

@Component({
  selector: 'app-list-post',
  templateUrl: './list-post.component.html',
  styleUrl: './list-post.component.css'
})
export class ListPostComponent implements OnInit {
  posts: Post[] = [];
  postCategories: PostCategory[] = [];
  postCategoryId: any;
  totalRecords = 0;
  pageSize = 10;
  currentPage = 1;
  isPublish:any;
  searchKeyword = '';
  statusFilter = '';
  Math = Math;
  constructor(
    private postService: PostService,
    private postCategoryService:PostCategoryService
  ) { }
  ngOnInit() {
    this.loadPosts();
    this.loadPostCategories();
  }
  loadPosts() {
    const searchParams: SearchPostParams = {
      PageNumber: this.currentPage,
      PageSize: this.pageSize,
      Keyword: this.searchKeyword,
      Status: this.statusFilter,
      SortBy: 'CreatedAt',
      SortDir: 'desc',
      PostCategoryId: this.postCategoryId,
      IsPublish: this.isPublish
    };
    this.postService.searchPosts(searchParams).subscribe(response => {
      this.posts = response.data.map((post: Post) => {
        return {
          ...post,
          imageUrl: `http://localhost:5069/images/${post.image}`
        };
      });
      this.totalRecords = response.totalRecords;
    }, error => {
      console.error('Error loading posts', error);
    });
  }

  loadPostCategories() {
    const searchParams = {
      pageNumber: this.currentPage,
      pageSize: 100000,
      keyword: this.searchKeyword,
      status: this.statusFilter,
      sortBy: '',
      sortDir: '',
    
    };
    this.postCategoryService.searchPostCategories(searchParams).subscribe(response => {
      this.postCategories = response.data;
      this.totalRecords = response.totalRecords;
    }, error => {
      console.error('Error loading post categories', error);
    });
  }
  onPageChange(page: number): void {
    if (page >= 1 && page <= Math.ceil(this.totalRecords / this.pageSize)) {
      this.currentPage = page;
      this.loadPosts();
    }
  }
  onSearch() {
    this.currentPage = 1;
    this.loadPosts();
  }
  deletePost(id: number): void {
    if (confirm('Are you sure you want to delete this post?')) {
      this.postService.deletePost(id).subscribe(
        response => {
          console.log('Post deleted:', response);
          this.loadPosts();
        },
        error => {
          console.error('Error deleting post:', error);
        }
      );
    }
  }
}
