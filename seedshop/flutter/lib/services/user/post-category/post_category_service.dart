import 'dart:convert';
import 'dart:ffi';

import 'package:ecommerce_sem4/models/user/post-category/response/post_category_response.dart';
import 'package:ecommerce_sem4/utils/http_utils.dart';
import 'package:http/http.dart' as http;

class PostCategoryService {

  Future<PostCategoryResponse?> search(String uri, Map<String, String> headers, Object request) async {
    try {
      final response =  await HttpUtils().post(uri, headers, request);

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          return PostCategoryResponse.fromJson(data);
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