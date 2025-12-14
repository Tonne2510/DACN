
import 'package:ecommerce_sem4/models/user/page_response.dart';
import 'package:ecommerce_sem4/models/user/product/response/product_model.dart';

class ProductResponse extends PageResponse<Product>{
  ProductResponse({
    required int pageNumber,
    required int pageSize,
    required int totalRecords,
    required List<Product> data,
  }) : super(
    pageNumber: pageNumber,
    pageSize: pageSize,
    totalRecords: totalRecords,
    data: data,
  );

  factory ProductResponse.fromJson(Map<String, dynamic> json) {
    return ProductResponse(
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      totalRecords: json['totalRecords'],
      data: (json['data'] as List)
          .map((item) => Product.fromJson(item))
          .toList(),
    );
  }

}