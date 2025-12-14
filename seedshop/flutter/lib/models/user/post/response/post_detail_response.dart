
import 'package:ecommerce_sem4/models/user/comment/post/response/comment_model.dart';
import 'package:ecommerce_sem4/models/user/post/response/post_model.dart';

class PostDetailResponse {
  final Post post;
  final List<Comment>? comments;
  final String postCategoryName;

  PostDetailResponse({required this.post, this.comments, required this.postCategoryName});

  factory PostDetailResponse.fromJson(Map<String, dynamic> json) {
    return PostDetailResponse(
      post: Post.fromJson(json['post']),
      postCategoryName: json['postCategoryName'],
      comments: (json['comments'] as List).map((c) => Comment.fromJson(c)).toList(),
    );
  }
}