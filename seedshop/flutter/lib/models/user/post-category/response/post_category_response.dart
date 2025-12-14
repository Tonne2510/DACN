
import 'package:ecommerce_sem4/models/user/page_response.dart';
import 'package:ecommerce_sem4/models/user/post-category/response/post_category_model.dart';

class PostCategoryResponse extends PageResponse<PostCategory> {
   PostCategoryResponse({
    required int pageNumber,
    required int pageSize,
    required int totalRecords,
    required List<PostCategory> data,
  }) : super(
    pageNumber: pageNumber,
    pageSize: pageSize,
    totalRecords: totalRecords,
    data: data,
  );

  factory PostCategoryResponse.fromJson(Map<String, dynamic> json) {
    return PostCategoryResponse(
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      totalRecords: json['totalRecords'],
      data: (json['data'] as List)
          .map((item) => PostCategory.fromJson(item))
          .toList(),
    );
  }
}