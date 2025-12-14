import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { Product } from '../interfaces/product';
import { AuthUserService } from './auth.user.service';
import { SearchParams } from './search-params';
import { Post } from '../interfaces/post';
import { SearchPostParams } from './search-post-params';

@Injectable({
  providedIn: 'root'
})
export class AccountService {
  private apiUrl = 'http://localhost:5069/api/account';
  private apiUrlC = 'http://localhost:5069/api';

  constructor(private http: HttpClient, private authService: AuthUserService) {}

  private getAuthHeaders(): HttpHeaders {
    const token = this.authService.getToken();
    return new HttpHeaders().set('Authorization', `Bearer ${token}`);
  }

  searchPosts(searchParams: SearchPostParams): Observable<any> {
    return this.http.post<any>(`${this.apiUrl}/search`, searchParams, {
      headers: this.getAuthHeaders()
    });
  }
  getAccountById(id: any): Observable<any> {
    return this.http.get<any>(`${this.apiUrl}/${id}`);
  }

  saveAccount(request:any, id: any):Observable<any>{
    return this.http.put<any>(`${this.apiUrl}/user/`+id, request, {
        headers: this.getAuthHeaders()
      });
  }

  
}