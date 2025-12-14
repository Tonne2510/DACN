import { Component, Input, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { CartService } from '../../../../services/cart.service';
import { AuthUserService } from '../../../../services/auth.user.service';
import { ToastService } from '../../../../services/toast.service';

@Component({
  selector: 'app-product-card',
  templateUrl: './product-card.component.html',
  styleUrl: './product-card.component.css'
})
export class ProductCardComponent implements OnInit {
  @Input() product: any;
  isAddingToCart = false;

  constructor(
    private cartService: CartService,
    private authService: AuthUserService,
    private router: Router,
    private toastService: ToastService
  ) { }

  ngOnInit() {
    // Component initialized
  }

  getImageUrl(imageName: string): string {
    if (!imageName) return '/assets/images/placeholder-product.jpg';
    return `http://localhost:5069/api/Account/getimage/${imageName}`;
  }

  getCurrentPrice(): number {
    if (this.product.salePrice && this.product.salePrice < this.product.price) {
      return this.product.salePrice;
    }
    return this.product.price;
  }

  getDiscountPercent(): number {
    if (this.product.salePrice && this.product.salePrice < this.product.price) {
      return Math.round(((this.product.price - this.product.salePrice) / this.product.price) * 100);
    }
    return 0;
  }

  formatPrice(price: number): string {
    return new Intl.NumberFormat('vi-VN', {
      style: 'currency',
      currency: 'VND'
    }).format(price);
  }

  stripHtml(html: string): string {
    if (!html) return '';
    return html.replace(/<[^>]*>/g, '')
      .replace(/&nbsp;/g, ' ')
      .replace(/&amp;/g, '&')
      .replace(/&lt;/g, '<')
      .replace(/&gt;/g, '>')
      .replace(/&quot;/g, '"')
      .replace(/&#39;/g, "'")
      .replace(/&aacute;/g, 'á')
      .replace(/&eacute;/g, 'é')
      .replace(/&iacute;/g, 'í')
      .replace(/&oacute;/g, 'ó')
      .replace(/&uacute;/g, 'ú')
      .replace(/\r\n/g, ' ')
      .replace(/\n/g, ' ')
      .replace(/\t/g, ' ')
      .replace(/\s+/g, ' ')
      .trim();
  }

  addToCart(event: Event) {
    event.preventDefault();
    event.stopPropagation();

    if (!this.authService.isAuthenticated()) {
      this.router.navigate(['/login'], {
        queryParams: { returnUrl: this.router.url }
      });
      return;
    }

    const user = this.authService.getUserInfo();
    console.log('User info:', user);
    if (!user || !user.id) {
      console.error('User info is missing or invalid');
      this.toastService.error('Vui lòng đăng nhập lại');
      return;
    }

    this.isAddingToCart = true;

    const request = {
      UserId: user.id,
      ProductId: this.product.id.toString(),
      Quantity: '1',
      Price: this.getCurrentPrice().toString()
    };

    console.log('Add to cart request:', request);

    this.cartService.addToCart(request).subscribe({
      next: (response) => {
        this.isAddingToCart = false;
        console.log('Added to cart successfully:', response);
        this.toastService.success('Đã thêm sản phẩm vào giỏ hàng');
      },
      error: (error) => {
        this.isAddingToCart = false;
        console.error('Error adding to cart:', error);
        console.error('Error details:', error.error);
        console.error('Validation errors:', error.error?.errors);
        
        let errorMessage = 'Có lỗi xảy ra khi thêm vào giỏ hàng';
        if (error.error?.errors) {
          const errors = error.error.errors;
          const errorMessages = Object.keys(errors).map(key => `${key}: ${errors[key].join(', ')}`);
          errorMessage = errorMessages.join(', ');
        }
        
        this.toastService.error(errorMessage);
      }
    });
  }
}
