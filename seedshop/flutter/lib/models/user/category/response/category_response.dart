
import 'package:ecommerce_sem4/models/user/category/response/category_model.dart';
import 'package:ecommerce_sem4/models/user/page_response.dart';

class CategoryResponse extends PageResponse<Category> {
  CategoryResponse({
    required int pageNumber,
    required int pageSize,
    required int totalRecords,
    required List<Category> data,
  }) : super(
    pageNumber: pageNumber,
    pageSize: pageSize,
    totalRecords: totalRecords,
    data: data,
  );

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      totalRecords: json['totalRecords'],
      data: (json['data'] as List)
          .map((item) => Category.fromJson(item))
          .toList(),
    );
  }
}