import { Injectable } from '@angular/core';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError, timeout, catchError } from 'rxjs';
import { PlantDiseaseResponse } from '../interfaces/plant-disease.interface';

@Injectable({
  providedIn: 'root'
})
export class PlantDiseaseService {
  private apiUrl = 'http://localhost:5000';
  private requestTimeout = 30000; // 30 seconds

  constructor(private http: HttpClient) { }

  /**
   * Dự đoán bệnh cây từ hình ảnh
   * @param imageFile - File hình ảnh cần phân tích
   * @returns Observable<PlantDiseaseResponse>
   */
  predictDisease(imageFile: File): Observable<PlantDiseaseResponse> {
    const formData = new FormData();
    formData.append('image', imageFile);
    
    return this.http.post<PlantDiseaseResponse>(`${this.apiUrl}/predict`, formData).pipe(
      timeout(this.requestTimeout),
      catchError(this.handleError)
    );
  }

  private handleError(error: HttpErrorResponse | any): Observable<never> {
    let errorMessage = '';
    
    if (error.name === 'TimeoutError') {
      // Timeout error from RxJS
      errorMessage = 'Request timeout. Server mất quá nhiều thời gian để phản hồi.';
    } else if (error.error instanceof ErrorEvent) {
      // Client-side error
      errorMessage = `Lỗi: ${error.error.message}`;
    } else if (error.status === 0) {
      // Network error or CORS issue
      errorMessage = 'Không thể kết nối đến server Python. Vui lòng kiểm tra:\n' +
                    '1. API Python đã chạy chưa (python server.py)\n' +
                    '2. Server đang chạy ở cổng 5000\n' +
                    '3. Firewall không chặn kết nối';
    } else {
      // Server-side error
      errorMessage = `Server trả về lỗi ${error.status}: ${error.message}`;
    }
    
    console.error('API Error:', error);
    return throwError(() => new Error(errorMessage));
  }
}
