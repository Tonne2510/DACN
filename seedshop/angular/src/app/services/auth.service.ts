import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { jwtDecode } from "jwt-decode";

@Injectable({
  providedIn: 'root'
})export class AuthService {

  private apiUrl = 'http://localhost:5069/api/auth/login';

  constructor(private http: HttpClient) { }

  login(email: string, password: string): Observable<any> {
    const headers = new HttpHeaders({ 'Content-Type': 'application/json' });
    const body = JSON.stringify({ email, password });
    return this.http.post(this.apiUrl, body, { headers });
  }

  saveTokenUser(token: string): void {
    if (typeof window !== 'undefined') {
      localStorage.setItem('authToken', token);
    }
  }

  getToken(): string | null {
    if (typeof window !== 'undefined') {
      return localStorage.getItem('authToken');
    }
    return null;
  }

  getRoleFromToken(): string | null {
    const token = this.getToken();
    if (token) {
      if (this.isTokenExpired(token)) {
        this.logout(); 
        return null;
      }

      const decodedToken: any = jwtDecode(token);
      const role = decodedToken.role || 
                   decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'] ||
                   decodedToken.Role;
      return role;
    }
    return null;
  }
  isTokenExpired(token: string): boolean {
    const decodedToken: any = jwtDecode(token);
    const currentTime = Math.floor(Date.now() / 1000);
    return decodedToken.exp < currentTime;
  }

  isAdmin(): boolean {
    const role = this.getRoleFromToken();
    return role === 'Admin';
  }

  isUser(): boolean {
    const role = this.getRoleFromToken();
    return role === 'User';
  }

  isLoggedIn(): boolean {
    return this.getToken() !== null;
  }

  logout(): void {
    if (typeof window !== 'undefined') {
      localStorage.removeItem('authToken');
    }
  }
}