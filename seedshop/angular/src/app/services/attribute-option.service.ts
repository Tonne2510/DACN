import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { AttributeOption } from '../interfaces/attribute-option';
import { AuthService } from './auth.service';

@Injectable({
  providedIn: 'root'
})
export class AttributeOptionService {

  private apiUrl = 'http://localhost:5069/api/attributeoption';

  constructor(private http: HttpClient, private authService: AuthService) {}

  private getAuthHeaders() {
    const token = this.authService.getToken(); 
    return new HttpHeaders().set('Authorization', `Bearer ${token}`);
  }

  addAttributeOption(option: AttributeOption): Observable<AttributeOption> {
    const headers = this.getAuthHeaders();
    return this.http.post<AttributeOption>(this.apiUrl, option, { headers });
  }

  updateAttributeOption(option: AttributeOption, id: any): Observable<AttributeOption> {
    const headers = this.getAuthHeaders();
    return this.http.put<AttributeOption>(`${this.apiUrl}/${id}`, option, { headers });
  }

  deleteAttributeOption(id: number): Observable<void> {
    const headers = this.getAuthHeaders();
    return this.http.delete<void>(`${this.apiUrl}/${id}`, { headers });
  }

  getAttributeOptionById(id: string): Observable<AttributeOption> {
    const headers = this.getAuthHeaders();
    return this.http.get<AttributeOption>(`${this.apiUrl}/${id}`, { headers });
  }
  getAttributeOptionByAttributeId(attributeId: string): Observable<AttributeOption[]> {
    const headers = this.getAuthHeaders();
    return this.http.get<AttributeOption[]>(`${this.apiUrl}/getbyattribute/${attributeId}`, { headers });
  }
  
  
  

  searchAttributeOptions(searchParams: any): Observable<any> {
    const headers = this.getAuthHeaders();
    return this.http.post<any>(`${this.apiUrl}/search`, searchParams, { headers });
  }  
}