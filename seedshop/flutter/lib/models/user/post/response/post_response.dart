
import 'package:ecommerce_sem4/models/user/page_response.dart';
import 'package:ecommerce_sem4/models/user/post/response/post_model.dart';

class PostResponse extends PageResponse<Post>{
  PostResponse({
    required int pageNumber,
    required int pageSize,
    required int totalRecords,
    required List<Post> data,
  }) : super(
    pageNumber: pageNumber,
    pageSize: pageSize,
    totalRecords: totalRecords,
    data: data,
  );

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      totalRecords: json['totalRecords'],
      data: (json['data'] as List)
          .map((item) => Post.fromJson(item))
          .toList(),
    );
  }
}