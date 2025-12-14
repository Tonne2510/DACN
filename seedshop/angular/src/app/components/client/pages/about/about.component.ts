import { Component } from '@angular/core';

@Component({
  selector: 'app-about',
  templateUrl: './about.component.html',
  styleUrl: './about.component.css'
})
export class AboutComponent {
  features = [
    {
      icon: 'fa-seedling',
      title: 'Hạt Giống Chất Lượng',
      description: 'Nhập khẩu từ các nhà cung cấp uy tín hàng đầu thế giới'
    },
    {
      icon: 'fa-certificate',
      title: 'Chứng Nhận An Toàn',
      description: 'Sản phẩm được kiểm định và chứng nhận bởi cơ quan chức năng'
    },
    {
      icon: 'fa-truck',
      title: 'Giao Hàng Nhanh',
      description: 'Vận chuyển toàn quốc, giao hàng trong 2-3 ngày'
    },
    {
      icon: 'fa-headset',
      title: 'Hỗ Trợ 24/7',
      description: 'Đội ngũ chuyên viên tư vấn nhiệt tình, chuyên nghiệp'
    }
  ];

  stats = [
    { number: '10,000+', label: 'Khách hàng' },
    { number: '500+', label: 'Sản phẩm' },
    { number: '5 năm', label: 'Kinh nghiệm' },
    { number: '99%', label: 'Hài lòng' }
  ];
}
