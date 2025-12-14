import { Injectable } from '@angular/core';
import { CanActivate, Router } from '@angular/router';
import { AuthUserService } from '../services/auth.user.service';

@Injectable({
  providedIn: 'root'
})
export class ClientGuard implements CanActivate {

  constructor(private authService: AuthUserService, private router: Router) {}

  canActivate(): boolean {
    // Nếu user là admin, logout admin
    if (this.authService.isAdmin()) {
      console.log('🔐 ClientGuard: User is admin - logging out');
      this.authService.logout();
      // Cho phép tiếp tục vào trang chủ sau khi logout
      return true;
    }
    
    return true;
  }
}
