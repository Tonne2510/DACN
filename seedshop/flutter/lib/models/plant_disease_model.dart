class DiseaseDetail {
  final String characteristics;
  final String causes;
  final String prevention;
  final String treatment;

  DiseaseDetail({
    required this.characteristics,
    required this.causes,
    required this.prevention,
    required this.treatment,
  });

  factory DiseaseDetail.fromJson(Map<String, dynamic> json) {
    return DiseaseDetail(
      characteristics:
          json['characteristics'] as String? ?? 'Không có thông tin',
      causes: json['causes'] as String? ?? 'Không có thông tin',
      prevention: json['prevention'] as String? ?? 'Không có thông tin',
      treatment: json['treatment'] as String? ?? 'Không có thông tin',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'characteristics': characteristics,
      'causes': causes,
      'prevention': prevention,
      'treatment': treatment,
    };
  }
}

class PlantDiseaseResponse {
  final String label;
  final String? labelVi;
  final double confidence;
  final DiseaseDetail? diseaseDetail;

  PlantDiseaseResponse({
    required this.label,
    this.labelVi,
    required this.confidence,
    this.diseaseDetail,
  });

  factory PlantDiseaseResponse.fromJson(Map<String, dynamic> json) {
    return PlantDiseaseResponse(
      label: json['label'] as String,
      labelVi: json['label_vi'] as String?,
      confidence: (json['confidence'] as num).toDouble(),
      diseaseDetail: json['disease_detail'] != null
          ? DiseaseDetail.fromJson(
              json['disease_detail'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'label_vi': labelVi,
      'confidence': confidence,
      'disease_detail': diseaseDetail?.toJson(),
    };
  }
}

class PlantDiseaseResult {
  final String imagePath;
  final String label;
  final String? labelVi;
  final double confidence;
  final DiseaseDetail? diseaseDetail;
  final DateTime timestamp;

  PlantDiseaseResult({
    required this.imagePath,
    required this.label,
    this.labelVi,
    required this.confidence,
    this.diseaseDetail,
    required this.timestamp,
  });

  factory PlantDiseaseResult.fromJson(Map<String, dynamic> json) {
    return PlantDiseaseResult(
      imagePath: json['imagePath'] as String,
      label: json['label'] as String,
      labelVi: json['label_vi'] as String?,
      confidence: (json['confidence'] as num).toDouble(),
      diseaseDetail: json['disease_detail'] != null
          ? DiseaseDetail.fromJson(
              json['disease_detail'] as Map<String, dynamic>)
          : null,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imagePath': imagePath,
      'label': label,
      'label_vi': labelVi,
      'confidence': confidence,
      'disease_detail': diseaseDetail?.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
