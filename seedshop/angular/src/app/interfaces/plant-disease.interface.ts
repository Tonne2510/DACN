
export interface DiseaseDetail {
  characteristics: string;
  causes: string;
  prevention: string;
  treatment: string;
}

export interface PlantDiseaseResponse {
  label: string;
  label_vi?: string;
  confidence: number;
  disease_detail?: DiseaseDetail;
}

export interface PlantDiseaseResult {
  imagePath: string;
  label: string;
  label_vi?: string;
  confidence: number;
  disease_detail?: DiseaseDetail;
  timestamp: Date;
}
