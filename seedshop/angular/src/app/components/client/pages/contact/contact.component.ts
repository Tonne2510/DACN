import { Component } from '@angular/core';

@Component({
  selector: 'app-contact',
  templateUrl: './contact.component.html',
  styleUrl: './contact.component.css'
})
export class ContactComponent {
  contactInfo = [
    {
      icon: 'fa-map-marker-alt',
      title: 'Địa chỉ',
      content: '123 Đường ABC, Quận XYZ, TP.HCM'
    },
    {
      icon: 'fa-phone',
      title: 'Hotline',
      content: '1900-xxxx'
    },
    {
      icon: 'fa-envelope',
      title: 'Email',
      content: 'contact@greenseeds.vn'
    },
    {
      icon: 'fa-clock',
      title: 'Giờ làm việc',
      content: 'T2-CN: 8:00 - 20:00'
    }
  ];

  formData = {
    name: '',
    email: '',
    phone: '',
    subject: '',
    message: ''
  };

  submitForm() {
    console.log('Form submitted:', this.formData);
    // Add your form submission logic here
    alert('Cảm ơn bạn đã liên hệ! Chúng tôi sẽ phản hồi sớm nhất.');
    this.resetForm();
  }

  resetForm() {
    this.formData = {
      name: '',
      email: '',
      phone: '',
      subject: '',
      message: ''
    };
  }
}
