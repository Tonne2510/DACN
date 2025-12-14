import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { ProductService } from '../../../../services/product.service';
import { CartService } from '../../../../services/cart.service';
import { AuthUserService } from '../../../../services/auth.user.service';
import { ToastService } from '../../../../services/toast.service';

@Component({
  selector: 'app-product-detail',
  templateUrl: './product-detail.component.html',
  styleUrl: './product-detail.component.css'
})
export class ProductDetailComponent implements OnInit {
  product: any = null;
  loading = true;
  addingToCart = false;
  quantity = 1;
  selectedImage = '';
  relatedProducts: any[] = [];
  Math = Math;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private productService: ProductService,
    private cartService: CartService,
    private authService: AuthUserService,
    private toastService: ToastService
  ) { }

  ngOnInit() {
    this.route.params.subscribe(params => {
      const slug = params['slug'];
      if (slug) {
        this.loadProduct(slug);
      }
    });
  }

  loadProduct(slug: string) {
    this.loading = true;

    this.productService.searchProducts({
      pageNumber: 1,
      pageSize: 100,
      keyword: '',
      status: '1',
      sortBy: '',
      sortDir: '',
      fromPrice: 0,
      toPrice: 0,
      categoryId: '',
      optionIds: []
    }).subscribe({
      next: (response: any) => {
        const products = response.data || [];
        this.product = products.find((p: any) => p.slug === slug);
        
        if (this.product) {
          this.selectedImage = this.getImageUrl(this.product.image);
          this.loadRelatedProducts();
        } else {
          this.toastService.error('Không tìm thấy sản phẩm');
          this.router.navigate(['/products']);
        }
        this.loading = false;
      },
      error: (error) => {
        console.error('Error loading product:', error);
        this.toastService.error('Có lỗi khi tải sản phẩm');
        this.loading = false;
        this.router.navigate(['/products']);
      }
    });
  }

  loadRelatedProducts() {
    if (!this.product) return;

    this.productService.searchProducts({
      pageNumber: 1,
      pageSize: 4,
      keyword: '',
      status: '1',
      sortBy: '',
      sortDir: '',
      fromPrice: 0,
      toPrice: 0,
      categoryId: this.product.categoryId?.toString() || '',
      optionIds: []
    }).subscribe({
      next: (response: any) => {
        this.relatedProducts = (response.data || [])
          .filter((p: any) => p.id !== this.product.id)
          .slice(0, 4);
      },
      error: (error) => {
        console.error('Error loading related products:', error);
      }
    });
  }

  getImageUrl(imageName: string): string {
    if (!imageName) return '/assets/images/placeholder-product.jpg';
    if (imageName.startsWith('http')) return imageName;
    return `http://localhost:5069/api/Account/getimage/${imageName}`;
  }

  selectImage(imageUrl: string) {
    this.selectedImage = imageUrl;
  }

  getCurrentPrice(): number {
    if (this.product?.salePrice && this.product.salePrice < this.product.price) {
      return this.product.salePrice;
    }
    return this.product?.price || 0;
  }

  getDiscountPercent(): number {
    if (this.product?.salePrice && this.product.salePrice < this.product.price) {
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

  increaseQuantity() {
    this.quantity++;
  }

  decreaseQuantity() {
    if (this.quantity > 1) {
      this.quantity--;
    }
  }

  updateQuantity(event: any) {
    const value = parseInt(event.target.value);
    if (value && value > 0) {
      this.quantity = value;
    } else {
      this.quantity = 1;
    }
  }

  addToCart() {
    if (!this.authService.isAuthenticated()) {
      this.toastService.info('Vui lòng đăng nhập để thêm vào giỏ hàng');
      this.router.navigate(['/login'], {
        queryParams: { returnUrl: this.router.url }
      });
      return;
    }

    const user = this.authService.getUserInfo();
    if (!user || !user.id) {
      this.toastService.error('Vui lòng đăng nhập lại');
      return;
    }

    this.addingToCart = true;

    const request = {
      UserId: user.id,
      ProductId: this.product.id.toString(),
      Quantity: this.quantity.toString(),
      Price: this.getCurrentPrice().toString()
    };

    this.cartService.addToCart(request).subscribe({
      next: () => {
        this.addingToCart = false;
        this.toastService.success(`Đã thêm ${this.quantity} sản phẩm vào giỏ hàng`);
        this.quantity = 1;
      },
      error: (error) => {
        this.addingToCart = false;
        console.error('Error adding to cart:', error);
        this.toastService.error('Có lỗi khi thêm vào giỏ hàng');
      }
    });
  }

  buyNow() {
    this.addToCart();
    setTimeout(() => {
      if (!this.addingToCart) {
        this.router.navigate(['/cart']);
      }
    }, 500);
  }

  goToProduct(slug: string) {
    this.router.navigate(['/products', slug]).then(() => {
      window.scrollTo(0, 0);
    });
  }

  stripHtml(html: string): string {
    if (!html) return '';
    return html.replace(/<[^>]*>/g, '')
      .replace(/&nbsp;/g, ' ')
      .replace(/&[a-z]+;/g, '')
      .replace(/\s+/g, ' ')
      .trim();
  }
}
