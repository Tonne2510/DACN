import { HttpClient, HttpHeaders  } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { AuthService } from './auth.service';
import { Category } from '../interfaces/category';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class CategoryService {
  checkCategoryNameExists(value: any) {
      throw new Error('Method not implemented.');
  }
  private apiUrl = 'http://localhost:5069/api/category';
  constructor(private http: HttpClient, private authService:AuthService) {}

  private getAuthHeaders() {
    const token = this.authService.getToken(); 
    return new HttpHeaders().set('Authorization', `Bearer ${token}`);
  }
  searchCategories(searchParams: any): Observable<any> {
    const headers = this.getAuthHeaders();
    return this.http.post<any>(`${this.apiUrl}/search`, searchParams, { headers });
  }
  getAllCategories(): Observable<any> {
    return this.http.get<any>(this.apiUrl+'/all');
  }
  addCategory(category: Category): Observable<Category> {
    const headers = this.getAuthHeaders();
    return this.http.post<Category>(this.apiUrl, category, { headers });
  }
  updateCategory(category: Category, id:any): Observable<Category> {
    const headers = this.getAuthHeaders();
    return this.http.put<Category>(`${this.apiUrl}/${id}`, category, { headers });
  }
  
  deleteCategory(id: number): Observable<void> {
    const headers = this.getAuthHeaders();
    return this.http.delete<void>(`${this.apiUrl}/${id}`, { headers });
  }

  getCategoryById(id: string): Observable<Category> {
    const headers = this.getAuthHeaders();
    return this.http.get<Category>(`${this.apiUrl}/${id}`, { headers });
  }
  

  checkNameExists(name: string): Observable<boolean> {
    const headers = this.getAuthHeaders();
    return this.http.get<boolean>(`${this.apiUrl}/checkNameExists?name=${name}`, { headers });
  }
  checkCategoryHasProducts(id: number): Observable<boolean> {
    const headers = this.getAuthHeaders();
    return this.http.get<boolean>(`${this.apiUrl}/hasProducts/${id}`, { headers });
  }
}
