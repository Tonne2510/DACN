import { Component, OnInit, Inject, PLATFORM_ID } from '@angular/core';
import { isPlatformBrowser } from '@angular/common';
import { Router } from '@angular/router';
import { CartService } from '../../../../services/cart.service';
import { AuthUserService } from '../../../../services/auth.user.service';
import { ToastService } from '../../../../services/toast.service';

@Component({
  selector: 'app-cart-page',
  templateUrl: './cart-page.component.html',
  styleUrl: './cart-page.component.css'
})
export class CartPageComponent implements OnInit {
  cartItems: any[] = [];
  loading = false;
  shippingFee = 30000;
  cartId: number = 0;

  constructor(
    private cartService: CartService,
    private authService: AuthUserService,
    private router: Router,
    private toastService: ToastService,
    @Inject(PLATFORM_ID) private platformId: Object
  ) { }

  ngOnInit() {
    // Only check auth in browser, not during SSR
    if (!isPlatformBrowser(this.platformId)) {
      return;
    }

    if (!this.authService.isAuthenticated()) {
      this.router.navigate(['/login'], {
        queryParams: { returnUrl: '/cart' }
      });
      return;
    }
    this.loadCart();
  }

  loadCart() {
    const user = this.authService.getUserInfo();
    if (!user) return;

    this.loading = true;

    // Get cart ID first
    this.cartService.getCartIdByUserId(user.id).subscribe({
      next: (response: any) => {
        this.cartId = response.cartId;

        // Then get cart items
        this.cartService.getCartByUserId(user.id).subscribe({
          next: (items: any) => {
            this.cartItems = items || [];
            this.loading = false;
          },
          error: (error) => {
            console.error('Error loading cart items:', error);
            this.loading = false;
          }
        });
      },
      error: (error) => {
        console.error('Error getting cart ID:', error);
        this.loading = false;
      }
    });
  }

  updateQuantity(item: any, newQuantity: number) {
    if (newQuantity < 1) return;

    const request = {
      CartId: this.cartId.toString(),
      ProductId: item.productId.toString(),
      Quantity: newQuantity.toString()
    };

    this.cartService.updateQuantityFromCart(request).subscribe({
      next: () => {
        item.quantity = newQuantity;
        this.toastService.success('Cập nhật số lượng thành công');
      },
      error: (error) => {
        console.error('Error updating quantity:', error);
        this.toastService.error('Có lỗi xảy ra khi cập nhật số lượng');
      }
    });
  }

  onQuantityChange(item: any) {
    if (item.quantity < 1) {
      item.quantity = 1;
    }
    item.quantity = Math.floor(item.quantity);
    this.updateQuantity(item, item.quantity);
  }

  removeItem(item: any) {
    if (!confirm('Bạn có chắc muốn xóa sản phẩm này?')) return;

    const request = {
      CartId: this.cartId.toString(),
      ProductId: item.productId.toString()
    };

    this.cartService.deleteProductFromCart(request).subscribe({
      next: () => {
        this.loadCart();
        this.toastService.success('Xóa sản phẩm thành công');
      },
      error: (error) => {
        console.error('Error removing item:', error);
        this.toastService.error('Có lỗi xảy ra khi xóa sản phẩm');
      }
    });
  }

  getImageUrl(imageName: string): string {
    if (!imageName) return '/assets/images/placeholder-product.jpg';
    return `http://localhost:5069/api/Account/getimage/${imageName}`;
  }

  formatPrice(price: number): string {
    return new Intl.NumberFormat('vi-VN', {
      style: 'currency',
      currency: 'VND'
    }).format(price);
  }

  getSubtotal(): number {
    return this.cartItems.reduce((sum, item) => sum + (item.price * item.quantity), 0);
  }

  getTotal(): number {
    return this.getSubtotal() + this.shippingFee;
  }
}
