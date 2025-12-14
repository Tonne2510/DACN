import { Injectable } from '@angular/core';
import Swal from 'sweetalert2';

@Injectable({
  providedIn: 'root'
})
export class CommonService {

  constructor() { }

  showAlert(type: 'success' | 'error' | 'warning' | 'info', title: string, text: string) {
    Swal.fire({
      title: title,
      text: text,
      icon: type,
      confirmButtonText: 'OK'
    });
  }
  showConfirmation(title: string, text: string, confirmButtonText: string = 'Xác nhận', cancelButtonText: string = 'Hủy bỏ') {
    return Swal.fire({
      title: title,
      text: text,
      icon: 'warning',
      showCancelButton: true,
      confirmButtonText: confirmButtonText,
      cancelButtonText: cancelButtonText
    }).then((result) => {
      return result.isConfirmed;
    });
  }
  showAutoCloseAlert(type: 'success' | 'error' | 'warning' | 'info', title: string, text: string, timer: number = 3000) {
    Swal.fire({
      title: title,
      text: text,
      icon: type,
      showConfirmButton: false,
      timer: timer,
      timerProgressBar: true
    });
  }
}
