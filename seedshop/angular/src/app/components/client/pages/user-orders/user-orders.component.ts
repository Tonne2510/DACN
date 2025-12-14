import { Component, OnInit, Inject, PLATFORM_ID } from '@angular/core';
import { isPlatformBrowser } from '@angular/common';
import { Router } from '@angular/router';
import { OrderService } from '../../../../services/order.service';
import { AuthUserService } from '../../../../services/auth.user.service';

@Component({
  selector: 'app-user-orders',
  templateUrl: './user-orders.component.html',
  styleUrl: './user-orders.component.css'
})
export class UserOrdersComponent implements OnInit {
  orders: any[] = [];
  loading = false;

  constructor(
    private orderService: OrderService,
    private authService: AuthUserService,
    private router: Router,
    @Inject(PLATFORM_ID) private platformId: Object
  ) { }

  ngOnInit() {
    // Only check auth in browser, not during SSR
    if (!isPlatformBrowser(this.platformId)) {
      return;
    }

    if (!this.authService.isAuthenticated()) {
      this.router.navigate(['/login'], {
        queryParams: { returnUrl: '/orders' }
      });
      return;
    }

    this.loadOrders();
  }

  loadOrders() {
    const user = this.authService.getUserInfo();
    if (!user) return;

    this.loading = true;

    this.orderService.getUserOrders(user.id).subscribe({
      next: (response: any) => {
        this.orders = response || [];
        this.loading = false;
      },
      error: (error: any) => {
        console.error('Error loading orders:', error);
        this.loading = false;
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

  getStatusText(status: string): string {
    const statusMap: any = {
      'Ordered': 'Đã đặt hàng',
      'Shipping': 'Đang giao',
      'Delivered': 'Đã giao',
      'Cancelled': 'Đã hủy'
    };
    return statusMap[status] || status;
  }

  getOrderTotal(order: any): number {
    const shippingFee = 30000;
    return (order.totalPrice || 0) + shippingFee;
  }
}