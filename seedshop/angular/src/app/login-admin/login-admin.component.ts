import { Component } from '@angular/core';
import { AuthService } from '../services/auth.service';
import { Router } from '@angular/router';
import { Login } from '../Models/Login';
import { log } from 'console';
import { CommonService } from '../services/common.service';
@Component({
  selector: 'app-login-admin',
  templateUrl: './login-admin.component.html',  
  styleUrl: './login-admin.component.css'
})
export class LoginAdminComponent {
  LoginModel:Login = new Login();

  constructor(private authService: AuthService, private router: Router, private commonService:CommonService) {}

  async onLogin() {
    console.log('=== LOGIN START ===');
    await this.authService.logout(); 
    
    this.authService.login(this.LoginModel.email, this.LoginModel.password).subscribe(
      (response) => {
        console.log('Login API response:', response);
        
        if (response.success) {
          console.log('Login successful, token:', response.token ? 'exists' : 'null');
          this.authService.saveTokenUser(response.token);
          console.log('Token saved to localStorage');
          
          // Get role immediately
          const role = this.authService.getRoleFromToken();
          console.log('Role from token:', role);
          
          const isAdmin = this.authService.isAdmin();
          console.log('isAdmin():', isAdmin);
          
          if (isAdmin) {
            console.log('✅ User is admin - navigating to /admin');
            this.router.navigate(['/admin']).then(
              (success) => console.log('Navigation result:', success),
              (error) => console.error('Navigation error:', error)
            );
            this.commonService.showAutoCloseAlert("success", "Login successfully", "Welcome back admin");
          } else {
            console.log('❌ User is NOT admin - logout');
            this.authService.logout();
            this.commonService.showAlert("error", "Login", "Only admin accounts can login here");
          }
        } else {
          console.log('Login failed - success is false');
          this.commonService.showAlert("error", "Login", "Login admin failed");
        }
      },
      (error) => {
        console.error('❌ Login API error:', error);
        this.commonService.showAlert("error", "Login", "Login admin failed");
      }
    );
  }
}
