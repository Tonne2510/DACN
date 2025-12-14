import 'dart:io';
import 'package:ecommerce_sem4/models/plant_disease_model.dart';
import 'package:ecommerce_sem4/services/plant_disease_service.dart';
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PlantDiseaseScreen extends StatefulWidget {
  const PlantDiseaseScreen({super.key});

  @override
  State<PlantDiseaseScreen> createState() => _PlantDiseaseScreenState();
}

class _PlantDiseaseScreenState extends State<PlantDiseaseScreen> {
  File? _selectedImage;
  PlantDiseaseResult? _result;
  bool _isLoading = false;
  String? _errorMessage;
  final ImagePicker _picker = ImagePicker();
  final PlantDiseaseService _service = PlantDiseaseService();

  final List<String> supportedPlants = [
    'Táo',
    'Việt quất',
    'Ngô',
    'Nho',
    'Cam',
    'Đào',
    'Ớt chuông',
    'Khoai tây',
    'Đậu nành',
    'Dâu tây',
    'Cà chua',
    'Anh đào',
    'Mâm xôi',
    'Bí ngòi',
  ];

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _result = null;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Lỗi khi chọn ảnh: $e';
      });
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) {
      setState(() {
        _errorMessage = 'Vui lòng chọn ảnh trước';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _service.predictDisease(_selectedImage!);

      if (response != null) {
        setState(() {
          _result = PlantDiseaseResult(
            imagePath: _selectedImage!.path,
            label: response.label,
            labelVi: response.labelVi,
            confidence: response.confidence,
            diseaseDetail: response.diseaseDetail,
            timestamp: DateTime.now(),
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _reset() {
    setState(() {
      _selectedImage = null;
      _result = null;
      _errorMessage = null;
    });
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.5) return Colors.orange;
    return Colors.red;
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: greenBgColor),
                  title: const Text('Chụp ảnh'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: greenBgColor),
                  title: const Text('Chọn từ thư viện'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: greenBgColor,
        title: const Text(
          'Chẩn Đoán Bệnh Cây',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Card(
                elevation: 0,
                color: const Color(0xFFF0F8EA),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Icon(
                        Icons.eco,
                        size: 48,
                        color: greenBgColor,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Tải lên hình ảnh lá cây để phát hiện bệnh',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Hỗ trợ 38 loại bệnh khác nhau',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Upload Button
              if (_selectedImage == null)
                InkWell(
                  onTap: _showImageSourceDialog,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: greenBgColor, width: 2),
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFFF0F8EA),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_photo_alternate,
                          size: 64,
                          color: greenBgColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Chọn hoặc chụp ảnh',
                          style: TextStyle(
                            fontSize: 16,
                            color: greenBgColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Image Preview
              if (_selectedImage != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _selectedImage!,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _analyzeImage,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.search),
                        label: Text(
                            _isLoading ? 'Đang phân tích...' : 'Phân Tích'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenBgColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _reset,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Icon(Icons.refresh),
                    ),
                  ],
                ),
              ],

              // Error Message
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[300]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[700]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red[700]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Result
              if (_result != null) ...[
                const SizedBox(height: 24),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: _getConfidenceColor(_result!.confidence),
                      width: 3,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Kết Quả Chẩn Đoán',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getConfidenceColor(_result!.confidence),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${(_result!.confidence * 100).toStringAsFixed(1)}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _result!.labelVi ?? _result!.label,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: _result!.confidence,
                            minHeight: 20,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getConfidenceColor(_result!.confidence),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Độ tin cậy: ${(_result!.confidence * 100).toStringAsFixed(2)}%',
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (_result!.diseaseDetail != null) ...[
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FDF6),
                              border: Border(
                                left: BorderSide(
                                  color: greenBgColor,
                                  width: 4,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Thông Tin Chi Tiết',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _buildDiseaseDetailItem(
                                  '🔍 Đặc Điểm Nhận Dạng:',
                                  _result!.diseaseDetail!.characteristics,
                                ),
                                const SizedBox(height: 12),
                                _buildDiseaseDetailItem(
                                  '🦠 Nguyên Nhân:',
                                  _result!.diseaseDetail!.causes,
                                ),
                                const SizedBox(height: 12),
                                _buildDiseaseDetailItem(
                                  '🛡️ Cách Phòng Tránh:',
                                  _result!.diseaseDetail!.prevention,
                                ),
                                const SizedBox(height: 12),
                                _buildDiseaseDetailItem(
                                  '💊 Cách Điều Trị:',
                                  _result!.diseaseDetail!.treatment,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],

              // Info Card
              const SizedBox(height: 24),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: greenBgColor),
                          const SizedBox(width: 8),
                          const Text(
                            'Hướng Dẫn',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildInfoItem('Chọn hình ảnh lá cây rõ ràng'),
                      _buildInfoItem('Độ phân giải tốt'),
                      _buildInfoItem('Ánh sáng đầy đủ, không mờ'),
                      _buildInfoItem('Hỗ trợ: JPG, PNG'),
                      const SizedBox(height: 12),
                      const Text(
                        'Loại cây được hỗ trợ (14 loại):',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: supportedPlants
                            .map((plant) => Chip(
                                  label: Text(
                                    plant,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  backgroundColor: const Color(0xFFF0F8EA),
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiseaseDetailItem(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            content,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 16, color: greenBgColor),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
