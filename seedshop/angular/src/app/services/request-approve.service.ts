import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { Product } from '../interfaces/product';
import { AuthService } from './auth.service';
import { SearchParams } from './search-params';
import { SearchCommentParams } from './search-post-params';

@Injectable({
  providedIn: 'root'
})
export class RequestApproveService {
  private apiUrl = 'http://localhost:5069/api/requestapproval';

  constructor(private http: HttpClient, private authService: AuthService) {}

  private getAuthHeaders(): HttpHeaders {
    const token = this.authService.getToken();
    return new HttpHeaders().set('Authorization', `Bearer ${token}`);
  }

  searchRequestComment(searchParams: SearchCommentParams): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/search`, searchParams, {
      headers: this.getAuthHeaders()
    });
  }
  
  getRequestById(id: any): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/${id}`, {
      headers: this.getAuthHeaders()
    });
  }

  approveRequest(id: number): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/approve/${id}`, {
      headers: this.getAuthHeaders()
    });
  }

  rejectRequest(id: number): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/reject/${id}`, {
      headers: this.getAuthHeaders()
    });
  }
}