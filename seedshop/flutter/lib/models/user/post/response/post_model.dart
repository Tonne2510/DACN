
import 'dart:convert';

import 'package:ecommerce_sem4/models/user/post-category/response/post_category_model.dart';

class Post {
  int id;
  String title;
  String? description;
  String? image;
  String? slug;
  String? content;
  String? status;
  int? postCategoryId;
  PostCategory? postCategory;
  DateTime createdAt;
  DateTime? updatedAt;


  Post({
    required this.id,
    required this.title,
     this.description,
    this.image,
     this.slug,
    this.content,
    this.status,
    this.postCategoryId,
    required this.createdAt,
    this.updatedAt
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      slug: json['slug'],
      content: json['content'],
      status: json['status'],
      postCategoryId: json['postCategoryId'],
      // category: Category.fromJson(json['category']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null
    );
  }
}
