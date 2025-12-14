import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { Product } from '../interfaces/product';
import { AuthService } from './auth.service';
import { SearchParams } from './search-params';

@Injectable({
  providedIn: 'root'
})
export class ProductService {
  private apiUrl = 'http://localhost:5069/api/product';

  constructor(private http: HttpClient, private authService: AuthService) {}

  private getAuthHeaders(): HttpHeaders {
    const token = this.authService.getToken();
    return new HttpHeaders().set('Authorization', `Bearer ${token}`);
  }

  searchProducts(searchParams: SearchParams): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/search`, searchParams, {
      headers: this.getAuthHeaders()
    });
  }
  getListProducts(searchParams: SearchParams): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/list-product`, searchParams, {
      headers: this.getAuthHeaders()
    });
  }
  getProductById(id: any): Observable<Product> {
    return this.http.get<Product>(`${this.apiUrl}/${id}`, {
      headers: this.getAuthHeaders()
    });
  }
  saveProduct(formData: FormData, id?: number): Observable<any> {
    if (id) {
        return this.http.put<any>(`${this.apiUrl}/${id}`, formData, {
            headers: this.getAuthHeaders()
        });
    } else {
        return this.http.post<any>(this.apiUrl, formData, {
            headers: this.getAuthHeaders()
        });
    }
}
  deleteProduct(id: number): Observable<any> {
    return this.http.delete<any>(`${this.apiUrl}/${id}`, {
      headers: this.getAuthHeaders()
    });
  }
}