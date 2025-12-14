import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { PostService } from '../../../../services/post.service';
import { PostCategoryService } from '../../../../services/post-category.service';

@Component({
  selector: 'app-blog-list',
  templateUrl: './blog-list.component.html',
  styleUrl: './blog-list.component.css'
})
export class BlogListComponent implements OnInit {
  posts: any[] = [];
  categories: any[] = [];
  loading = false;
  currentPage = 1;
  pageSize = 9;
  totalRecords = 0;
  totalPages = 0;
  searchKeyword = '';
  selectedCategoryId = '';

  constructor(
    private router: Router,
    private postService: PostService,
    private postCategoryService: PostCategoryService
  ) { }

  ngOnInit() {
    this.loadCategories();
    this.loadPosts();
  }

  loadCategories() {
    // Use getAllPostCategories instead (no auth required)
    this.postCategoryService.getAllPostCategories().subscribe({
      next: (response: any) => {
        console.log('Post Categories response:', response);
        // API returns array directly or { data: [] }
        this.categories = Array.isArray(response) ? response : (response.data || []);
        console.log('Post Categories loaded:', this.categories);
      },
      error: (error: any) => {
        console.error('Error loading post categories:', error);
        this.categories = []; // Set empty array on error
      }
    });
  }

  loadPosts() {
    this.loading = true;

    this.postService.searchPosts({
      PageNumber: this.currentPage,
      PageSize: this.pageSize,
      Keyword: this.searchKeyword,
      Status: '',
      SortBy: 'CreatedAt',
      SortDir: 'desc',
      PostCategoryId: this.selectedCategoryId,
      IsPublish: ''
    }).subscribe({
      next: (response: any) => {
        console.log('Posts response:', response);
        this.posts = response.data || [];
        console.log('Posts with slugs:', this.posts.map((p: any) => ({ id: p.id, title: p.title, slug: p.slug })));
        this.totalRecords = response.totalRecords || 0;
        this.totalPages = Math.ceil(this.totalRecords / this.pageSize);
        this.loading = false;
      },
      error: (error: any) => {
        console.error('Error loading posts:', error);
        this.loading = false;
      }
    });
  }

  onSearch() {
    this.currentPage = 1;
    this.loadPosts();
  }

  onCategoryFilter(categoryId: string) {
    this.selectedCategoryId = categoryId;
    this.currentPage = 1;
    this.loadPosts();
  }

  clearFilters() {
    this.searchKeyword = '';
    this.selectedCategoryId = '';
    this.currentPage = 1;
    this.loadPosts();
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

  goToPost(slug: string) {
    console.log('Navigating to post with slug:', slug);
    if (slug) {
      this.router.navigate(['/blog', slug]);
    } else {
      console.error('Post slug is empty or undefined');
    }
  }

  getImageUrl(imageName: string): string {
    if (!imageName) return '/assets/images/placeholder-blog.jpg';
    return `http://localhost:5069/api/Account/getimage/${imageName}`;
  }

  goToPage(page: number) {
    if (page >= 1 && page <= this.totalPages) {
      this.currentPage = page;
      this.loadPosts();
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
