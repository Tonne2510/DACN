import { Component, OnInit } from '@angular/core';
import { Router, NavigationEnd } from '@angular/router';
import { AuthUserService } from '../../../../services/auth.user.service';
import { CartService } from '../../../../services/cart.service';
import { CategoryService } from '../../../../services/category.service';
import { filter } from 'rxjs/operators';

@Component({
  selector: 'app-client-header',
  templateUrl: './client-header.component.html',
  styleUrl: './client-header.component.css'
})
export class ClientHeaderComponent implements OnInit {
  isLoggedIn = false;
  currentUser: any = null;
  isAdmin = false;
  showUserMenu = false;
  showMobileMenu = false;
  searchKeyword = '';
  cartItemCount = 0;
  categories: any[] = [];

  constructor(
    private authService: AuthUserService,
    private cartService: CartService,
    private categoryService: CategoryService,
    private router: Router
  ) { }

  ngOnInit() {
    this.checkAuthStatus();
    this.loadCategories();
    this.loadCartCount();

    // Subscribe to cart changes
    this.cartService.cartItems$.subscribe(() => {
      this.loadCartCount();
    });

    // Subscribe to router events to check auth status on navigation
    this.router.events.pipe(
      filter(event => event instanceof NavigationEnd)
    ).subscribe(() => {
      this.checkAuthStatus();
      this.loadCartCount();
    });
  }

  checkAuthStatus() {
    this.isLoggedIn = this.authService.isAuthenticated();
    if (this.isLoggedIn) {
      this.currentUser = this.authService.getUserInfo();
      this.isAdmin = this.currentUser?.role === 'Admin';
    } else {
      this.currentUser = null;
      this.isAdmin = false;
    }
  }

  loadCategories() {
    this.categoryService.searchCategories({ pageNumber: 1, pageSize: 100, status: '1' }).subscribe({
      next: (response: any) => {
        this.categories = response.data || [];
      },
      error: (error) => {
        console.error('Error loading categories:', error);
      }
    });
  }

  loadCartCount() {
    if (this.isLoggedIn && this.currentUser) {
      this.cartService.getCartByUserId(this.currentUser.id).subscribe({
        next: (response: any) => {
          this.cartItemCount = response?.length || 0;
        },
        error: (error) => {
          console.error('Error loading cart count:', error);
          this.cartItemCount = 0;
        }
      });
    }
  }

  toggleUserMenu() {
    this.showUserMenu = !this.showUserMenu;
  }

  toggleMobileMenu() {
    this.showMobileMenu = !this.showMobileMenu;
  }

  onSearch() {
    if (this.searchKeyword.trim()) {
      this.router.navigate(['/products'], {
        queryParams: { search: this.searchKeyword }
      });
    }
  }

  logout() {
    this.authService.logout();
    this.isLoggedIn = false;
    this.currentUser = null;
    this.showUserMenu = false;
    this.router.navigate(['/']);
  }
}
