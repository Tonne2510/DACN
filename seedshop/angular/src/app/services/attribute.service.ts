import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import {Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { AuthService } from './auth.service';
import { Attribute } from '../interfaces/attribute';


@Injectable({
  providedIn: 'root'
})
export class AttributeService {

  private apiUrl = 'http://localhost:5069/api/attribute';

  constructor(private http: HttpClient, private authService: AuthService) {}

  private getAuthHeaders() {
    const token = this.authService.getToken(); 
    return new HttpHeaders().set('Authorization', `Bearer ${token}`);
  }

  addAttribute(attribute: Attribute): Observable<Attribute> {
    const headers = this.getAuthHeaders();
    return this.http.post<Attribute>(this.apiUrl, attribute, { headers });
  }

  updateAttribute(attribute: Attribute, id: any): Observable<Attribute> {
    const headers = this.getAuthHeaders();
    return this.http.put<Attribute>(`${this.apiUrl}/${id}`, attribute, { headers });
  }

  deleteAttribute(id: number): Observable<void> {
    const headers = this.getAuthHeaders();
    return this.http.delete<void>(`${this.apiUrl}/${id}`, { headers });
  }

  getAttributeById(id: string): Observable<Attribute> {
    const headers = this.getAuthHeaders();
    return this.http.get<Attribute>(`${this.apiUrl}/${id}`, { headers });
  }

  searchAttributes(searchParams: any): Observable<any> {
    const headers = this.getAuthHeaders();
    return this.http.post<any>(`${this.apiUrl}/search`, searchParams, { headers });
  }  
}