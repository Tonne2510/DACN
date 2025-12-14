import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { Product } from '../interfaces/product';
import { AuthService } from './auth.service';
import { SearchParams } from './search-params';
import { AuthUserService } from './auth.user.service';

@Injectable({
  providedIn: 'root'
})
export class CartService {
  private apiUrl = 'http://localhost:5069/api/cart';
  private cartItems = new BehaviorSubject<any[]>([]);
  cartItems$ = this.cartItems.asObservable();

  constructor(private http: HttpClient, private authService: AuthUserService) {
    this.loadCartItems();
  }

  // Method to load cart items from the API
  private loadCartItems(): void {
    const userId = this.authService.getUserIdFromToken();
    this.getCartByUserId(userId).subscribe((items:any) => {
      this.cartItems.next(items); 
    });
  }

  private getAuthHeaders(): HttpHeaders {
    const token = this.authService.getToken();
    return new HttpHeaders().set('Authorization', `Bearer ${token}`);
  }

  addToCart(request: any): Observable<any> {
    const currentItems = this.cartItems.value;
    const existingItem = currentItems.find(item => item.productId === request.productId);
    if (existingItem==null) {
      const currentItems = this.cartItems.getValue();
      this.cartItems.next([...currentItems, request]);
    }
    // else {
    //   this.cartItems.next(currentItems);
    // }
    // this.saveCartToLocalStorage(currentItems);
    return this.http.post<any>(`${this.apiUrl}/add`, request, {
      headers: this.getAuthHeaders()
    });
  }
  getCartByUserId(userId:any): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/search`, {"userId": userId}, {
      headers: this.getAuthHeaders()
    });
  }

  getCartIdByUserId(id: any): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/getCart`, {"userId": id} ,{
      headers: this.getAuthHeaders()
    });
  }

  deleteProductFromCart(request: any): Observable<any> {
    const currentItems = this.cartItems.getValue().filter(item => item.productId != request.productId);
    this.cartItems.next(currentItems);
    const url = `${this.apiUrl}`; 
    return this.http.request('DELETE', url, {
      body: request, 
      headers: this.getAuthHeaders()
    });
  }

  updateQuantityFromCart(request:any): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/update`, request, {
        headers: this.getAuthHeaders()
    });
  }

  clearCart(request: any): Observable<any> {
    if (typeof window !== 'undefined') {
        this.cartItems.next([])
    } 
    const url = `${this.apiUrl}/remove-all`; 
    return this.http.request('DELETE', url, {
      body: request, 
      headers: this.getAuthHeaders()
    });
  }

  getTotalItems(): number {
    return this.cartItems.value.length;
  }

}