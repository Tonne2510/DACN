

import 'dart:convert';

import 'package:ecommerce_sem4/models/user/product/response/product_response.dart';
import 'package:ecommerce_sem4/utils/http_utils.dart';

class ProductService {

  Future<ProductResponse?> search(String uri, Map<String, String> headers, Object request) async {
    try {
      final response =  await HttpUtils().post(uri, headers, request);

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          return ProductResponse.fromJson(data);
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