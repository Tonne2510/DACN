import { Component, OnInit, Inject, PLATFORM_ID } from '@angular/core';
import { isPlatformBrowser } from '@angular/common';
import { PlantDiseaseService } from '../../services/plant-disease.service';
import { PlantDiseaseResult, PlantDiseaseResponse } from '../../interfaces/plant-disease.interface';

@Component({
  selector: 'app-plant-disease-detector',
  templateUrl: './plant-disease-detector.component.html',
  styleUrls: ['./plant-disease-detector.component.css']
})
export class PlantDiseaseDetectorComponent implements OnInit {
  selectedFile: File | null = null;
  imagePreview: string | null = null;
  result: PlantDiseaseResult | null = null;
  loading: boolean = false;
  error: string | null = null;
  history: PlantDiseaseResult[] = [];
  supportedPlants: string[] = [
    'Táo',
    'Việt quất',
    'Ngô',
    'Nho',
    'Cam',
    'Đào',
    'Ớt chuông',
    'Khoai tây',
    'Đậu nành',
    'Dâu tây ',
    'Cà chua',
    'Anh đào',
    'Mâm xôi',
    'Bí ngòi'
  ];

  constructor(
    private plantDiseaseService: PlantDiseaseService,
    @Inject(PLATFORM_ID) private platformId: Object
  ) { }

  ngOnInit(): void {
    this.loadHistory();
  }

  /**
   * Xử lý khi chọn file
   */
  onFileSelected(event: any): void {
    const file = event.target.files[0];
    if (file && file.type.startsWith('image/')) {
      this.selectedFile = file;
      this.error = null;
      
      // Tạo preview
      const reader = new FileReader();
      reader.onload = (e: any) => {
        this.imagePreview = e.target.result;
      };
      reader.readAsDataURL(file);
    } else {
      this.error = 'Vui lòng chọn file hình ảnh hợp lệ';
      this.selectedFile = null;
      this.imagePreview = null;
    }
  }

  /**
   * Upload và phân tích hình ảnh
   */
  analyzeImage(): void {
    if (!this.selectedFile) {
      this.error = 'Vui lòng chọn hình ảnh trước';
      return;
    }

    this.loading = true;
    this.error = null;
    this.result = null;

    this.plantDiseaseService.predictDisease(this.selectedFile).subscribe({
      next: (response: PlantDiseaseResponse) => {
        this.result = {
          imagePath: this.imagePreview || '',
          label: response.label,
          label_vi: response.label_vi,
          confidence: response.confidence,
          disease_detail: response.disease_detail,
          timestamp: new Date()
        };
        
        // Lưu vào lịch sử
        this.history.unshift(this.result);
        if (this.history.length > 10) {
          this.history.pop();
        }
        this.saveHistory();
        
        this.loading = false;
      },
      error: (err: any) => {
        this.error = 'Không thể kết nối đến server. Vui lòng kiểm tra API Python đã chạy chưa.';
        console.error('Error:', err);
        this.loading = false;
      }
    });
  }

  /**
   * Reset form
   */
  reset(): void {
    this.selectedFile = null;
    this.imagePreview = null;
    this.result = null;
    this.error = null;
  }

  /**
   * Lấy màu theo độ tin cậy
   */
  getConfidenceColor(confidence: number): string {
    if (confidence >= 0.8) return 'success';
    if (confidence >= 0.5) return 'warning';
    return 'danger';
  }

  /**
   * Lưu lịch sử vào localStorage
   */
  private saveHistory(): void {
    if (!isPlatformBrowser(this.platformId)) return;
    
    try {
      const historyData = this.history.map(h => ({
        ...h,
        imagePath: '' // Không lưu base64 image để tiết kiệm dung lượng
      }));
      localStorage.setItem('plantDiseaseHistory', JSON.stringify(historyData));
    } catch (e) {
      console.error('Cannot save history:', e);
    }
  }

  /**
   * Load lịch sử từ localStorage
   */
  private loadHistory(): void {
    if (!isPlatformBrowser(this.platformId)) return;
    
    try {
      const saved = localStorage.getItem('plantDiseaseHistory');
      if (saved) {
        this.history = JSON.parse(saved).map((h: any) => ({
          ...h,
          timestamp: new Date(h.timestamp)
        }));
      }
    } catch (e) {
      console.error('Cannot load history:', e);
      this.history = [];
    }
  }

  /**
   * Xóa lịch sử
   */
  clearHistory(): void {
    this.history = [];
    if (isPlatformBrowser(this.platformId)) {
      localStorage.removeItem('plantDiseaseHistory');
    }
  }
}
