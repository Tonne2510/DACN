import 'dart:convert';
import 'dart:ffi';

import 'package:ecommerce_sem4/models/user/account/response/account_model.dart';
import 'package:ecommerce_sem4/models/user/category/response/category_response.dart';
import 'package:ecommerce_sem4/utils/http_utils.dart';
import 'package:http/http.dart' as http;

class AccountService {

  Future<Account?> detail(String uri, Map<String, String> headers) async {
    try {
      final response =  await HttpUtils().get(uri, headers);

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          return Account.fromJson(data);
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

  Future<Account?> update(String uri, Map<String, String> headers, Object request) async {
    try {
      final response =  await HttpUtils().put(uri, headers, request);

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          return Account.fromJson(data);
        } else {
          print('Received empty response body');
        }
      } else {
        print(response.body);
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
    return null;
  }

}