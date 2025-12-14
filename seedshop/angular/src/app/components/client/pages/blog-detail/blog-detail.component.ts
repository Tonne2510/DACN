import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { PostService } from '../../../../services/post.service';

@Component({
  selector: 'app-blog-detail',
  templateUrl: './blog-detail.component.html',
  styleUrl: './blog-detail.component.css'
})
export class BlogDetailComponent implements OnInit {
  post: any = null;
  loading = true;
  relatedPosts: any[] = [];

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private postService: PostService
  ) { }

  ngOnInit() {
    this.route.params.subscribe(params => {
      const slug = params['slug'];
      if (slug) {
        this.loadPost(slug);
      }
    });
  }

  loadPost(slug: string) {
    this.loading = true;
    console.log('Loading post with slug:', slug);

    // Search all published posts and filter by slug
    this.postService.searchPosts({
      PageNumber: 1,
      PageSize: 100,
      Keyword: '',
      Status: '',
      SortBy: 'CreatedAt',
      SortDir: 'desc',
      IsPublish: ''  // Empty to get all posts
    }).subscribe({
      next: (response: any) => {
        console.log('Search response:', response);
        if (response.data && response.data.length > 0) {
          // Find post by exact slug match
          this.post = response.data.find((p: any) => p.slug === slug);
          
          if (this.post) {
            console.log('Found post:', this.post);
            this.loadRelatedPosts();
          } else {
            console.log('Post not found with slug:', slug);
            console.log('Available posts:', response.data.map((p: any) => ({ slug: p.slug, status: p.status })));
            // Post not found, redirect to blog list
            this.router.navigate(['/blog']);
          }
        } else {
          console.log('No posts in response');
          this.router.navigate(['/blog']);
        }
        this.loading = false;
      },
      error: (error: any) => {
        console.error('Error loading post:', error);
        this.loading = false;
        this.router.navigate(['/blog']);
      }
    });
  }

  loadRelatedPosts() {
    if (!this.post) return;

    const params: any = {
      PageNumber: 1,
      PageSize: 3,
      Keyword: '',
      Status: '',
      SortBy: 'CreatedAt',
      SortDir: 'desc',
      IsPublish: ''
    };

    // Filter by same category if available
    if (this.post.postCategoryId) {
      params.PostCategoryId = this.post.postCategoryId.toString();
    }

    console.log('Loading related posts with params:', params);

    this.postService.searchPosts(params).subscribe({
      next: (response: any) => {
        console.log('Related posts response:', response);
        // Filter out current post
        this.relatedPosts = response.data.filter((p: any) => p.id !== this.post.id).slice(0, 3);
        console.log('Related posts:', this.relatedPosts);
      },
      error: (error: any) => {
        console.error('Error loading related posts:', error);
      }
    });
  }

  getImageUrl(imageName: string): string {
    if (!imageName) {
      return 'assets/img/default-blog.jpg';
    }
    if (imageName.startsWith('http')) {
      return imageName;
    }
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

  goToRelatedPost(slug: string) {
    this.router.navigate(['/blog', slug]).then(() => {
      window.scrollTo(0, 0);
    });
  }
}

