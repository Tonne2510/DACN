import { Component, OnInit, Inject, PLATFORM_ID } from '@angular/core';
import { isPlatformBrowser } from '@angular/common';
import { FormBuilder, FormGroup } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthUserService } from '../../../../services/auth.user.service';
import { AccountService } from '../../../../services/account.service';
import { ToastService } from '../../../../services/toast.service';

@Component({
  selector: 'app-user-profile',
  templateUrl: './user-profile.component.html',
  styleUrl: './user-profile.component.css'
})
export class UserProfileComponent implements OnInit {
  profileForm: FormGroup;
  user: any = null;
  activeTab = 'info';
  saving = false;

  constructor(
    private fb: FormBuilder,
    private authService: AuthUserService,
    private accountService: AccountService,
    private toastService: ToastService,
    private router: Router,
    @Inject(PLATFORM_ID) private platformId: Object
  ) {
    this.profileForm = this.fb.group({
      username: [''],
      phone: [''],
      address: [''],
      gender: ['']
    });
  }

  ngOnInit() {
    // Only check auth in browser, not during SSR
    if (!isPlatformBrowser(this.platformId)) {
      return;
    }

    if (!this.authService.isAuthenticated()) {
      this.router.navigate(['/login'], {
        queryParams: { returnUrl: '/profile' }
      });
      return;
    }

    this.loadUserInfo();
  }

  loadUserInfo() {
    this.user = this.authService.getUserInfo();

    if (this.user) {
      // Load full user details from API
      this.accountService.getAccountById(this.user.id).subscribe({
        next: (response: any) => {
          this.user = response;
          this.profileForm.patchValue({
            username: response.userName || '',
            phone: response.phoneNumber || '',
            address: response.address || '',
            gender: response.gender === true ? 'male' : response.gender === false ? 'female' : ''
          });
        },
        error: (error) => {
          console.error('Error loading user info:', error);
        }
      });
    }
  }

  updateProfile() {
    if (this.profileForm.invalid) return;

    this.saving = true;
    const formValue = this.profileForm.value;
    
    // Map form fields to API DTO
    const updateRequest = {
      Username: formValue.username,
      Phone: formValue.phone,
      Address: formValue.address,
      Gender: formValue.gender === 'male' ? '1' : '0'
    };

    this.accountService.saveAccount(updateRequest, this.user.id).subscribe({
      next: (response: any) => {
        this.saving = false;
        this.toastService.success('Cập nhật thông tin thành công!');
        this.loadUserInfo();
      },
      error: (error) => {
        this.saving = false;
        console.error('Error updating profile:', error);
        this.toastService.error('Có lỗi xảy ra khi cập nhật thông tin');
      }
    });
  }

  logout() {
    this.authService.logout();
    this.router.navigate(['/']);
  }
}
