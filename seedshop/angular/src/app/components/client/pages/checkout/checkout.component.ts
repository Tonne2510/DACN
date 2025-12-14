import { Component, OnInit, Inject, PLATFORM_ID } from '@angular/core';
import { isPlatformBrowser } from '@angular/common';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { CartService } from '../../../../services/cart.service';
import { OrderService } from '../../../../services/order.service';
import { AuthUserService } from '../../../../services/auth.user.service';
import { AccountService } from '../../../../services/account.service';
import { ToastService } from '../../../../services/toast.service';

@Component({
  selector: 'app-checkout',
  templateUrl: './checkout.component.html',
  styleUrl: './checkout.component.css'
})
export class CheckoutComponent implements OnInit {
  checkoutForm: FormGroup;
  cartItems: any[] = [];
  cartId: number = 0;
  shippingFee = 30000;
  placing = false;
  userInfo: any = null;

  constructor(
    private fb: FormBuilder,
    private cartService: CartService,
    private orderService: OrderService,
    private authService: AuthUserService,
    private accountService: AccountService,
    private toastService: ToastService,
    private router: Router,
    @Inject(PLATFORM_ID) private platformId: Object
  ) {
    this.checkoutForm = this.fb.group({
      note: ['']
    });
  }

  ngOnInit() {
    // Only check auth in browser, not during SSR
    if (!isPlatformBrowser(this.platformId)) {
      return;
    }

    if (!this.authService.isAuthenticated()) {
      this.router.navigate(['/login'], {
        queryParams: { returnUrl: '/checkout' }
      });
      return;
    }

    this.loadCart();
    this.loadUserInfo();
  }

  loadCart() {
    const user = this.authService.getUserInfo();
    if (!user) return;

    this.cartService.getCartIdByUserId(user.id).subscribe({
      next: (response: any) => {
        this.cartId = response.cartId;

        this.cartService.getCartByUserId(user.id).subscribe({
          next: (items: any) => {
            this.cartItems = items || [];
            if (this.cartItems.length === 0) {
              this.toastService.error('Giỏ hàng trống!');
              setTimeout(() => {
                this.router.navigate(['/cart']);
              }, 1500);
            }
          }
        });
      }
    });
  }

  loadUserInfo() {
    const user = this.authService.getUserInfo();
    if (user) {
      this.accountService.getAccountById(user.id).subscribe({
        next: (response: any) => {
          this.userInfo = response;
          // Check if user has required info
          if (!this.userInfo.userName || !this.userInfo.phoneNumber || !this.userInfo.address) {
            this.toastService.error('Vui lòng cập nhật đầy đủ thông tin cá nhân trước khi thanh toán!');
            setTimeout(() => {
              this.router.navigate(['/profile']);
            }, 1500);
          }
        },
        error: (error) => {
          console.error('Error loading user info:', error);
        }
      });
    }
  }

  placeOrder() {
    if (this.cartItems.length === 0) return;
    
    if (!this.userInfo || !this.userInfo.userName || !this.userInfo.phoneNumber || !this.userInfo.address) {
      this.toastService.error('Vui lòng cập nhật đầy đủ thông tin cá nhân!');
      setTimeout(() => {
        this.router.navigate(['/profile']);
      }, 1500);
      return;
    }

    this.placing = true;
    const user = this.authService.getUserInfo();
    const formValue = this.checkoutForm.value;

    const order = {
      userId: user.id,
      shippingAddress: `${this.userInfo.userName}, ${this.userInfo.phoneNumber}, ${this.userInfo.address}`,
      status: 'Ordered',
      totalAmount: this.getTotal(),
      orderDate: new Date().toISOString()
    };

    this.orderService.createOrder(order).subscribe({
      next: (response: any) => {
        this.placing = false;
        this.toastService.success('Đặt hàng thành công! Cảm ơn bạn đã mua hàng.');
        setTimeout(() => {
          this.router.navigate(['/orders']);
        }, 1500);
      },
      error: (error) => {
        this.placing = false;
        console.error('Error placing order:', error);
        this.toastService.error('Có lỗi xảy ra khi đặt hàng. Vui lòng thử lại.');
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
