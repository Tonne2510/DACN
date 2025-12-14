import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ecommerce_sem4/models/plant_disease_model.dart';

class PlantDiseaseServiceException implements Exception {
  final String message;
  PlantDiseaseServiceException(this.message);
  
  @override
  String toString() => message;
}

class PlantDiseaseService {
  static const String baseUrl = 'http://10.0.2.2:5000'; // Android emulator
  // static const String baseUrl = 'http://localhost:5000'; // iOS simulator
  static const int timeoutSeconds = 30;

  Future<PlantDiseaseResponse?> predictDisease(File imageFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/predict'),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );

      var streamedResponse = await request.send().timeout(
        Duration(seconds: timeoutSeconds),
        onTimeout: () {
          throw PlantDiseaseServiceException(
            'Request timeout. Server mất quá nhiều thời gian để phản hồi.'
          );
        },
      );
      
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PlantDiseaseResponse.fromJson(data);
      } else if (response.statusCode == 400) {
        throw PlantDiseaseServiceException('Dữ liệu không hợp lệ. Vui lòng chọn file ảnh.');
      } else if (response.statusCode == 500) {
        throw PlantDiseaseServiceException('Lỗi server. Vui lòng thử lại sau.');
      } else {
        throw PlantDiseaseServiceException('Request failed with status: ${response.statusCode}');
      }
    } on SocketException catch (_) {
      throw PlantDiseaseServiceException(
        'Không thể kết nối đến server Python.\n'
        'Vui lòng kiểm tra:\n'
        '1. API Python đã chạy chưa (python server.py)\n'
        '2. Server đang chạy ở cổng 5000\n'
        '3. Địa chỉ IP đúng (10.0.2.2 cho emulator)'
      );
    } on TimeoutException catch (_) {
      throw PlantDiseaseServiceException(
        'Request timeout. Server mất quá nhiều thời gian để phản hồi.'
      );
    } on PlantDiseaseServiceException {
      rethrow;
    } catch (error) {
      print('Unexpected error: $error');
      throw PlantDiseaseServiceException('Đã xảy ra lỗi không mong muốn: $error');
    }
  }
}
