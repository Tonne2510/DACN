
import 'dart:convert';

import 'package:ecommerce_sem4/models/user/post-category/response/post_category_model.dart';

class Account {
  String? id;
  String? avatar;
  String? email;
  String? userName;
  String? address;
  String? gender;
  String? phoneNumber;

  String? password;
  String? roleName;

  Account({
     this.id,
     this.avatar,
     this.email,
     this.userName,
    this.address,
    this.gender,
    this.phoneNumber,

    this.password,
    this.roleName
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      avatar: json['avatar'],
      email: json['email'],
      userName: json['userName'],
      address:json['address'],
      gender:json['gender']==true?'Male':'Female',
      phoneNumber: json['phoneNumber'],
      password: json['passwordHash'],
        roleName: json['roleName']
    );
  }
}
