

import 'dart:convert';

import 'package:ecommerce_sem4/models/user/cart/response/cart_list_response.dart';
import 'package:ecommerce_sem4/models/user/cart/response/cart_response.dart';
import 'package:ecommerce_sem4/models/user/product/response/product_response.dart';
import 'package:ecommerce_sem4/utils/http_utils.dart';

class CartService {

  Future<CartResponse?> addToCart(String uri, Map<String, String> headers, Object request) async {
    try {
      final response =  await HttpUtils().post(uri, headers, request);

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          return CartResponse.fromJson(data);
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

  Future<List<CartListResponse>?> getCart(String uri, Map<String, String> headers, Object request) async {
    try {
      final response =  await HttpUtils().post(uri, headers, request);

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          return CartListResponse.parseCartListResponse(data);
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

  Future<CartResponse?> updateQuantity(String uri, Map<String, String> headers, Object request) async {
    try {
      final response =  await HttpUtils().post(uri, headers, request);

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          return CartResponse.fromJson(data);
        } else {
          print('Received empty response body');
        }
      } else {
        print("update quantity");
        print(response.body);
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
    return null;
  }

  Future<dynamic> getCartIdByUserId(String uri, Map<String, String> headers, Object request) async {
    try {
      final response =  await HttpUtils().post(uri, headers, request);

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          return data;
        } else {
          print('Received empty response body');
        }
      } else {
        print("get cartid");
        print(response.body);
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
    return null;
  }

  Future<CartResponse?> removeItem(String uri, Map<String, String> headers, Object request) async {
    try {
      final response =  await HttpUtils().delete(uri, headers, request);

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          return CartResponse.fromJson(data);
        } else {
          print('Received empty response body');
        }
      } else {
        print("remove item");
        print(response.body);
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
    return null;
  }


}