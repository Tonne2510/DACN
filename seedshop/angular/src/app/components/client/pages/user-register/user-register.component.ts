import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthUserService } from '../../../../services/auth.user.service';
import { ToastService } from '../../../../services/toast.service';

@Component({
  selector: 'app-user-register',
  templateUrl: './user-register.component.html',
  styleUrl: './user-register.component.css'
})
export class UserRegisterComponent {
  registerForm: FormGroup;
  loading = false;
  errorMessage = '';

  constructor(
    private fb: FormBuilder,
    private authService: AuthUserService,
    private router: Router,
    private toastService: ToastService
  ) {
    this.registerForm = this.fb.group({
      username: ['', Validators.required],
      email: ['', [Validators.required, Validators.email]],
      password: ['', [Validators.required, Validators.minLength(6)]]
    });
  }

  onSubmit() {
    if (this.registerForm.invalid) return;

    this.loading = true;
    this.errorMessage = '';

    const { email, username, password } = this.registerForm.value;

    const registerData = {
      email,
      username,
      password
    };

    this.authService.register(registerData).subscribe({
      next: (response: any) => {
        this.loading = false;
        if (response.success) {
          this.toastService.success('Đăng ký thành công! Vui lòng đăng nhập.');
          setTimeout(() => {
            this.router.navigate(['/login']);
          }, 1500);
        } else {
          const errors = response.errors?.join(', ') || '';
          if (errors.includes('Email already Registered')) {
            this.errorMessage = 'Email đã được đăng ký';
          } else if (errors.includes('Password does not meet requirements')) {
            this.errorMessage = 'Password không hợp lệ';
          } else {
            this.errorMessage = errors || 'Đăng ký thất bại';
          }
          this.toastService.error(this.errorMessage);
        }
      },
      error: (error) => {
        this.loading = false;
        const errorMsg = error.error?.errors?.join(', ') || '';
        if (errorMsg.includes('Email already Registered')) {
          this.errorMessage = 'Email đã được đăng ký';
        } else if (errorMsg.includes('Password does not meet requirements')) {
          this.errorMessage = 'Password không hợp lệ';
        } else {
          this.errorMessage = 'Đăng ký thất bại';
        }
        this.toastService.error(this.errorMessage);
        console.error('Register error:', error);
      }
    });
  }
}
