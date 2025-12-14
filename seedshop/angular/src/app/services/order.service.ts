import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { Product } from '../interfaces/product';
import { AuthService } from './auth.service';
import { SearchParams } from './search-params';

@Injectable({
  providedIn: 'root'
})
export class OrderService {
  private apiUrl = 'http://localhost:5069/api/order';

  constructor(private http: HttpClient, private authService: AuthService) {}

  private getAuthHeaders(): HttpHeaders {
    const token = this.authService.getToken();
    return new HttpHeaders().set('Authorization', `Bearer ${token}`);
  }
// OrderService
changeOrderStatus(id: number, orderChange: { NewStatus: string }): Observable<any> {
  const headers = this.getAuthHeaders();
  return this.http.put<any>(`${this.apiUrl}/change-status/${id}`, orderChange, { headers });
}



  searchOrders(searchParams: any): Observable<any> {
    const headers = this.getAuthHeaders();
    return this.http.post<any>(`${this.apiUrl}/search`, searchParams, { headers });
  }
  createOrder(request: any): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/create`, request, {
      headers: this.getAuthHeaders()
    });
  }
  getOrderByUserId(userId:any): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/user-orders/${userId}`, {
      headers: this.getAuthHeaders()
    });
  }

  // Alias for getOrderByUserId - used by client components
  getUserOrders(userId: any): Observable<any> {
    return this.getOrderByUserId(userId);
  }

  getOrderDetail(orderId: number): Observable<any> {
    const headers = this.getAuthHeaders();
    return this.http.get<any>(`${this.apiUrl}/detail/${orderId}`, { headers });
  }

}