
import 'dart:convert';
import 'package:ecommerce_sem4/services/user/auth/auth_service.dart';
import 'package:intl/intl.dart';
import 'package:ecommerce_sem4/models/user/category/request/search_request.dart';
import 'package:ecommerce_sem4/models/user/category/response/category_model.dart';
import 'package:ecommerce_sem4/models/user/category/response/category_response.dart';
import 'package:ecommerce_sem4/models/user/product/request/search_request.dart';
import 'package:ecommerce_sem4/models/user/product/response/product_model.dart';
import 'package:ecommerce_sem4/route/user/router_constants.dart';
import 'package:ecommerce_sem4/screens/user/home/views/components/card_product_component.dart';
import 'package:ecommerce_sem4/screens/user/home/views/components/category_component.dart';
import 'package:ecommerce_sem4/services/user/category/category_service.dart';
import 'package:ecommerce_sem4/services/user/product/product_service.dart';
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeComponent extends StatefulWidget{
  const HomeComponent({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<HomeComponent>{
  final searchApiCategory= categorySearchUri;
  final detailApiCategory = categoryDetailUri;
  final searchApiProduct = productSearchUri;
  final imageUrl = "http://10.0.2.2:5069/images/";
  final detailApiProduct = productDetailUri;
   String? accessToken = "";
   List<Category> categories = [];
   List<Product> products = [];
  Map<String, String> headers = <String, String>{};

 @override
 void initState() {
    super.initState();
    AuthService().checkLoginStatus(context);
    _loadCategories();
    _loadTopProducts();
  }

  Future<void> _loadCategories() async {
    final pref = await SharedPreferences.getInstance();
    accessToken = pref.getString("accessToken");

    headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };

    Map<String, Object?> request = CategorySearchRequest(
        pageNumber: 1,
        pageSize: 5,
        sortBy: "Id",
        sortDir: "asc")
        .toMap();

    final data = await CategoryService().search(searchApiCategory, headers, request);

    setState(() {
      categories = data!.data;
    });
  }

  Future<void> _loadTopProducts() async{
    final pref = await SharedPreferences.getInstance();
    accessToken = pref.getString("accessToken");

    headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };

    Map<String, Object?> request = ProductSearchRequest(
        pageNumber: 1,
        pageSize: 6,
        sortBy: "Id",
        sortDir: "asc",
    )
        .toMap();

    final data = await ProductService().search(searchApiProduct, headers, request);

    setState(() {
      products = data!.data;
    });
  }


  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(symbol: "₫", decimalDigits: 0);
    return SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              // Hero Section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFF0F8EA), Color(0xFFE8F5E0)],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hạt Giống Chất Lượng Cao",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF2D5016),
                              height: 1.2,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Mang thiên nhiên vào khu vườn nhà bạn",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4A7C2C),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Chuyên cung cấp hạt giống rau, hoa, cây ăn trái với chất lượng tốt nhất.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF666666),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.7),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.eco,
                        size: 60,
                        color: Color(0xFF4A7C2C),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Danh Mục",
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2D5016)),
                            ),
                            InkWell(
                              onTap: () {
                                // Navigate to the new screen
                                Navigator.pushNamed(
                                    context,
                                    categoryScreenRoute
                                );
                              },
                              child: Text(
                                "Xem thêm",
                                style: TextStyle(
                                    color: Color(0xFF4A7C2C),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            )
                          ],
                        )
                    ),
                    Wrap(
                      spacing: 16.0,
                      runSpacing: 12.0,
                      children: categories.asMap().entries.map((entry) {
                        Category item = entry.value;
                        return SizedBox(
                          width: 70,
                          child: CategoryComponent(
                              name: item.categoryName.toString()),
                        );
                      }).toList(),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sản Phẩm Nổi Bật",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D5016),
                            ),
                          ),
                          Wrap(
                            spacing: 11.0,
                            runSpacing: 16.0,
                            children: products.map((product){
                              return  Container(
                                width: 180,
                                child: CardProduct(
                                    image: '$imageUrl${product.image}',
                                    name: product.productName,
                                    price: formatCurrency.format(product.price),
                                    product: product
                                    )
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
}