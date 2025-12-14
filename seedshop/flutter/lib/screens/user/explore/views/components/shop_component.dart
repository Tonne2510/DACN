
import 'dart:math';

import 'package:ecommerce_sem4/models/user/category/request/search_request.dart';
import 'package:ecommerce_sem4/models/user/category/response/category_model.dart';
import 'package:ecommerce_sem4/route/user/router_constants.dart';
import 'package:ecommerce_sem4/screens/user/explore/views/components/category_item_shop_component.dart';
import 'package:ecommerce_sem4/screens/user/explore/views/search_screen.dart';
import 'package:ecommerce_sem4/screens/user/product/views/category_product_screen.dart';
import 'package:ecommerce_sem4/services/user/auth/auth_service.dart';
import 'package:ecommerce_sem4/services/user/category/category_service.dart';
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopComponent extends StatefulWidget{
  const ShopComponent({super.key});

  @override
  State<StatefulWidget> createState() => _ShopComponent();
}

class _ShopComponent extends State<ShopComponent>{
  final TextEditingController _searchController = TextEditingController();
  String? accessToken = "";
  final searchApiCategory= categorySearchUri;
  List<Category> categories = [];
  Map<String, String> headers = <String, String>{};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AuthService().checkLoginStatus(context);
    _loadCategories();

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
        pageSize: 10000000,
        sortBy: "Id",
        sortDir: "asc")
        .toMap();

    final data = await CategoryService().search(searchApiCategory, headers, request);
    setState(() {
      categories = data!.data;
    });
  }

  void _onSearchTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) =>  SearchScreen(keyword: _searchController.text,)),
    );
  }

  int getRandomItem(int length) {
    if (length == 0) {
      return 0;
    }
    Random random = Random();
    int randomIndex = random.nextInt(length);
    return randomIndex;
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 15, 12, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _searchController,
              decoration:  InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: borderInput, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: borderInput, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: "Tìm kiếm sản phẩm...",
                contentPadding: EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
                hintStyle: TextStyle(color: greyColor, fontSize: 13),
                suffixIcon: IconButton(
                    onPressed: (){
                      _onSearchTap(context);
                    },
                    icon: Icon(Icons.search, color: Color(0xFF4A7C2C)
                    )
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Wrap(
              runSpacing: 12,
              spacing: 16,
              children: categories.asMap().entries.map((entry) {
                Category item = entry.value;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CategoryProductScreen(categoryId: item.id.toString(),categoryName: item.categoryName,isCheckScreen: true,)));
                  },
                  child:  ItemShopCategory(
                      colorBg: Color(0xFFF0F8EA),
                      colorSideBorder: Color(0xFF4A7C2C),
                      text: item.categoryName
                  ),
                ) ;
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}