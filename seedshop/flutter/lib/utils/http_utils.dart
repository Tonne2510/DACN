import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpUtils {

  Future<http.Response> post(String uri, Map<String, String> headers, Object request) async{
   try{
     final response = await http.post(
       Uri.parse(uri),
       headers: headers,
       body: jsonEncode(request),
     );
     return response;
   }catch(error){
     throw Exception('Error making request: $error');
   }
  }
  Future<http.Response> delete(String uri, Map<String, String> headers, Object request) async{
    try{
      final response = await http.delete(
        Uri.parse(uri),
        headers: headers,
        body: jsonEncode(request),
      );
      return response;
    }catch(error){
      throw Exception('Error making request: $error');
    }
  }
  Future<http.Response> get(String uri, Map<String, String> headers) async {
    try {
      final response = await http.get(
        Uri.parse(uri),
        headers: headers,
      );

      print("Action GET");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception('Failed request: ${response.statusCode}, ${response.body}');
      }
    } catch (error) {
      throw Exception('Error making request: $error');
    }
  }

  Future<http.Response> put(String uri, Map<String, String> headers, Object request) async{
    try{
      final response = await http.put(
        Uri.parse(uri),
        headers: headers,
        body: jsonEncode(request),
      );
      return response;
    }catch(error){
      throw Exception('Error making request: $error');
    }
  }
}