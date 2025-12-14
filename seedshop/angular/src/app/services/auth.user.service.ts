import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { jwtDecode } from "jwt-decode";
import { RegisterUser } from '../interfaces/register-user';

@Injectable({
  providedIn: 'root'
})export class AuthUserService {

  private apiUrl = 'http://localhost:5069/api/auth/';
  private currentUserSubject = new BehaviorSubject<any | null>(null);
  currentUser$ = this.currentUserSubject.asObservable();


  constructor(private http: HttpClient) { }

  setCurrentUser(user: any): void {
    this.currentUserSubject.next(user);
  }

  login(email: string, password: string): Observable<any> {
    const headers = new HttpHeaders({ 'Content-Type': 'application/json' });
    const body = JSON.stringify({ email, password });
    return this.http.post(this.apiUrl + "login", body, { headers });
  }

  register(data: RegisterUser): Observable<any>{
    const headers = new HttpHeaders({'Content-Type': 'application/json'})
    return this.http.post<RegisterUser>(this.apiUrl+'register', data, {headers});
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

  getUsernameFromToken():string | null {
    const token = this.getToken();
    if(token){
      if (this.isTokenExpired(token)) {
        this.logout(); 
        return null;
      }
      const decodedToken: any = jwtDecode(token);
      return decodedToken.name;
    }
    return null;
  }

  getEmailFromToken():string | null {
    const token = this.getToken();
    if(token){
      if (this.isTokenExpired(token)) {
        this.logout(); 
        return null;
      }
      const decodedToken: any = jwtDecode(token);
      return decodedToken.email;
    }
    return null;
  }

  getUserIdFromToken():string | null {
    const token = this.getToken();
    if(token){
      if (this.isTokenExpired(token)) {
        this.logout(); 
        return null;
      }
      const decodedToken: any = jwtDecode(token);
      return decodedToken.Id;
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
      return decodedToken.role;
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

  // Alias for isLoggedIn - used by client components
  isAuthenticated(): boolean {
    return this.isLoggedIn();
  }

  // Get user info from token
  getUserInfo(): any {
    const token = this.getToken();
    if (!token || this.isTokenExpired(token)) {
      return null;
    }
    try {
      const decodedToken: any = jwtDecode(token);
      console.log('Decoded token:', decodedToken);
      return {
        id: decodedToken.Id || decodedToken.id || decodedToken.nameid,
        username: decodedToken.name || decodedToken.unique_name,
        email: decodedToken.email,
        role: decodedToken.role || decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role']
      };
    } catch (error) {
      console.error('Error decoding token:', error);
      return null;
    }
  }

  logout(): void {
    if (typeof window !== 'undefined') {
      localStorage.removeItem('authToken');
    }
  }
}