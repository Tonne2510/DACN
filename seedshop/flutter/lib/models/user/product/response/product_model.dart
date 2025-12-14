
import 'dart:convert';

import 'package:ecommerce_sem4/models/user/category/response/category_model.dart';

class Product {
  int id;
  double price;
  double salePrice;
  bool active;
  String? image;
  String productName;
  String? description;
  String? slug;
  int? categoryId;
  Category? category;
  String? album;
  DateTime createdAt;
  DateTime? updatedAt;
  String? createdBy;
  String? updatedBy;
  DateTime? deletedAt;

  Product({
    required this.id,
    required this.price,
    required this.salePrice,
    required this.active,
    this.image,
    required this.productName,
    required this.description,
    required this.slug,
     this.categoryId,
     this.category,
     this.album,
    required this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.deletedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      price: json['price']?.toDouble() ?? 0.0,
      salePrice: json['salePrice']?.toDouble() ?? 0.0,
      active: json['active'],
      image: json['image'],
      productName: json['productName'],
      description: json['description'],
      slug: json['slug'],
      categoryId: json['categoryId'],
      // category: Category.fromJson(json['category']),
      album: json['album'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }
}
