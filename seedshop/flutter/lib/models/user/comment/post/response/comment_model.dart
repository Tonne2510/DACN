
import 'dart:convert';

import 'package:ecommerce_sem4/models/user/account/response/account_model.dart';
import 'package:ecommerce_sem4/models/user/post-category/response/post_category_model.dart';

class Comment {
  int id;
  String? content;
  DateTime createdAt;
  int postId;
  String? accountId;
  Account account;

  Comment({
    required this.id,
    required this.content,
   required this.createdAt,
    required this.postId,
    this.accountId,
    required this.account
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        id: json['id'],
        content: json['content'],
      postId: json['postId'],
      accountId: json['accountId'],
        account: Account.fromJson(json['account']),
        createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
