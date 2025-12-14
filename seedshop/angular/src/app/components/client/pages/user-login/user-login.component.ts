import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router, ActivatedRoute } from '@angular/router';
import { AuthUserService } from '../../../../services/auth.user.service';

@Component({
  selector: 'app-user-login',
  templateUrl: './user-login.component.html',
  styleUrl: './user-login.component.css'
})
export class UserLoginComponent implements OnInit {
  loginForm: FormGroup;
  loading = false;
  errorMessage = '';
  returnUrl = '/';

  constructor(
    private fb: FormBuilder,
    private authService: AuthUserService,
    private router: Router,
    private route: ActivatedRoute
  ) {
    this.loginForm = this.fb.group({
      email: ['', [Validators.required, Validators.email]],
      password: ['', Validators.required]
    });
  }

  ngOnInit() {
    // Get return URL from query params
    this.route.queryParams.subscribe(params => {
      this.returnUrl = params['returnUrl'] || '/';
    });

    // Redirect if already logged in
    if (this.authService.isAuthenticated()) {
      this.router.navigate([this.returnUrl]);
    }
  }

  onSubmit(event?: Event) {
    if (event) {
      event.preventDefault();
    }
    if (this.loginForm.invalid) return;

    this.loading = true;
    this.errorMessage = '';

    const { email, password } = this.loginForm.value;

    this.authService.login(email, password).subscribe({
      next: (response: any) => {
        console.log('=== User Login Response ===');
        console.log('Login response:', response); // Debug
        this.loading = false;

        // Handle different response formats
        const token = response.data || response.token || response;

        if (token && typeof token === 'string') {
          // Save token
          this.authService.saveTokenUser(token);
          
          // Check if user is admin
          const role = this.authService.getRoleFromToken();
          const isAdmin = role === 'Admin';
          console.log('User role:', role);
          console.log('Is admin:', isAdmin);
          
          // Determine redirect URL
          let redirectUrl = this.returnUrl;
          if (isAdmin) {
            redirectUrl = '/admin';
            console.log('✅ Admin user detected - redirecting to /admin');
          } else {
            console.log('Regular user - redirecting to', redirectUrl);
          }
          
          console.log('Navigating to:', redirectUrl);
          // Use navigateByUrl for absolute path
          this.router.navigateByUrl(redirectUrl).then(success => {
            console.log('Navigation success:', success);
            if (!success) {
              console.error('Navigation failed, redirecting to home');
              this.router.navigateByUrl('/');
            }
          });
        } else {
          this.errorMessage = 'Email hoặc mật khẩu không đúng';
          console.error('Invalid response format:', response);
        }
      },
      error: (error) => {
        this.loading = false;
        console.error('Login error:', error);

        // Display backend error messages in Vietnamese
        if (error.error && error.error.errors && error.error.errors.length > 0) {
          // Translate common error messages
          const errors = error.error.errors.map((err: string) => {
            if (err.toLowerCase().includes('email')) {
              return 'Email không hợp lệ hoặc không tồn tại';
            } else if (err.toLowerCase().includes('password')) {
              return 'Mật khẩu không đúng';
            } else if (err.toLowerCase().includes('locked')) {
              return 'Tài khoản đã bị khóa';
            } else if (err.toLowerCase().includes('not found')) {
              return 'Tài khoản không tồn tại';
            } else {
              return err; // Return original if no translation
            }
          });
          this.errorMessage = errors.join(', ');
        } else if (error.error && error.error.message) {
          this.errorMessage = error.error.message;
        } else {
          this.errorMessage = 'Đăng nhập thất bại. Vui lòng kiểm tra email và mật khẩu.';
        }
      }
    });
  }
}
