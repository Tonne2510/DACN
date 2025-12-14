
import 'package:ecommerce_sem4/models/user/product/request/search_request.dart';
import 'package:ecommerce_sem4/models/user/product/response/product_model.dart';
import 'package:ecommerce_sem4/route/user/router_constants.dart';
import 'package:ecommerce_sem4/screens/user/category/views/category_screen.dart';
import 'package:ecommerce_sem4/screens/user/explore/views/search_screen.dart';
import 'package:ecommerce_sem4/screens/user/explore/views/shop_screen.dart';
import 'package:ecommerce_sem4/screens/user/home/views/components/card_product_component.dart';
import 'package:ecommerce_sem4/screens/user/product/views/filter_product_screen.dart';
import 'package:ecommerce_sem4/services/user/auth/auth_service.dart';
import 'package:ecommerce_sem4/services/user/product/product_service.dart';
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryProductScreen extends StatefulWidget{
  final String categoryId;
  final String categoryName;
  bool? isCheckScreen;
   CategoryProductScreen({super.key, required this.categoryId, required this.categoryName, this.isCheckScreen});

  @override
  State<StatefulWidget> createState() => _CategoryProduct();
}

class _CategoryProduct extends State<CategoryProductScreen>{
  final searchApiProduct = productSearchUri;
  List<Product> products = [];
  String? accessToken = "";
  Map<String, String> headers = <String, String>{};
  final formatCurrency = NumberFormat.currency(symbol: "₫", decimalDigits: 0);
  final imageUrl = "http://10.0.2.2:5069/images/";

  @override
  void initState(){
    super.initState();
    AuthService().checkLoginStatus(context);
    _loadProducts();
  }

  Future<void> _loadProducts() async{
    final pref = await SharedPreferences.getInstance();
    accessToken = pref.getString("accessToken");

    headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };

    Map<String, Object?> request = ProductSearchRequest(
      pageNumber: 1,
      pageSize: 10000,
      sortBy: "Id",
      sortDir: "asc",
      categoryId: widget.categoryId
    ).toMap();

    final data = await ProductService().search(searchApiProduct, headers, request);

    setState(() {
      products = data!.data;
    });
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:  Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child:AppBar(
            flexibleSpace: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(12, 15, 12, 15),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 24,
                          ),
                          onPressed: () {
                            // Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    (widget.isCheckScreen!)?const ExploreScreen(): const CategoryScreen()));
                          },
                          color: whiteColor,
                        ),
                      ],
                    ),
                     Text(
                      widget.categoryName,
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 23,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.filter_list,
                            size: 35,
                          ),
                          onPressed: () {
                            // Navigator.pushNamed(context, filterProductRoute);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FilterProductScreen(isCheck: widget.isCheckScreen!,isScreen: false,)));
                          },
                          color: whiteColor,
                        ),
                      ],
                    )
                  ],
                )
            ),
            backgroundColor: Color(0xFF4A7C2C),
            automaticallyImplyLeading: false,
          ),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(12, 15, 12, 15),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Wrap(
                      spacing: 17.0,
                      runSpacing: 17.0,
                      children: products.map((product){
                        return Container(
                          width: 185,
                          child: CardProduct(image: '$imageUrl${product.image}',name: product.productName,price: formatCurrency.format(product.price), product: product,),
                        );
                      }).toList(),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}