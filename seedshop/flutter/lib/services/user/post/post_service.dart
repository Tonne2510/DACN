import 'dart:convert';
import 'dart:ffi';

import 'package:ecommerce_sem4/models/user/post/response/post_response.dart';
import 'package:ecommerce_sem4/utils/http_utils.dart';
import 'package:http/http.dart' as http;

import '../../../models/user/post/response/post_detail_response.dart';

class PostService {

  Future<PostResponse?> search(String uri, Map<String, String> headers, Object request) async {
    try {
      final response =  await HttpUtils().post(uri, headers, request);

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          return PostResponse.fromJson(data);
        } else {
          print('Received empty response body');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
    return null;
  }
  Future<PostDetailResponse?> detail(String uri, Map<String, String> headers) async {
    try {
      final response =  await HttpUtils().get(uri, headers);

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          return PostDetailResponse.fromJson(data);
        } else {
          print('Received empty response body');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
    return null;
  }
}