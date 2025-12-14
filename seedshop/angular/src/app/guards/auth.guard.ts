import { Injectable } from '@angular/core';
import { CanActivate, Router } from '@angular/router';
import { AuthService } from '../services/auth.service';
import { CommonService } from '../services/common.service';

@Injectable({
  providedIn: 'root'
})
export class AuthGuard implements CanActivate {

  constructor(private authService: AuthService, private router: Router, private commonService:CommonService) {}

  async canActivate(): Promise<boolean> {
    console.log('\n🔐 === AuthGuard canActivate START ===');
    
    const isLoggedIn = this.authService.isLoggedIn();
    console.log('  isLoggedIn():', isLoggedIn);
    
    if (isLoggedIn) {
      const token = this.authService.getToken();
      console.log('  Token exists:', !!token);
      
      const role = this.authService.getRoleFromToken();
      console.log('  Role from token:', role);
      
      const isAdmin = this.authService.isAdmin();
      console.log('  isAdmin():', isAdmin);
      
      if (isAdmin) {
        console.log('✅ AuthGuard: User is admin, ALLOWING access');
        console.log('🔐 === AuthGuard canActivate END (ALLOW) ===\n');
        return true;
      }
    }
    
    console.log('❌ AuthGuard: DENYING access - not admin');
    this.commonService.showAutoCloseAlert("warning","Notice","You must login to continue");
    this.router.navigate(['/admin-login']);
    console.log('🔐 === AuthGuard canActivate END (DENY) ===\n');
    return false;
  }
}