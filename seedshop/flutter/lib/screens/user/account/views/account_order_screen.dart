
import 'package:ecommerce_sem4/models/user/order/response/order_item_response.dart';
import 'package:ecommerce_sem4/models/user/post/request/search_request.dart';
import 'package:ecommerce_sem4/models/user/post/response/post_model.dart';
import 'package:ecommerce_sem4/screens/user/account/views/account_screen.dart';
import 'package:ecommerce_sem4/screens/user/account/views/components/user_order_item_component.dart';
import 'package:ecommerce_sem4/screens/user/category/views/category_screen.dart';
import 'package:ecommerce_sem4/screens/user/explore/views/shop_screen.dart';
import 'package:ecommerce_sem4/screens/user/home/views/components/card_product_component.dart';
import 'package:ecommerce_sem4/screens/user/post-category/views/post_category_screen.dart';
import 'package:ecommerce_sem4/screens/user/post/views/components/post_item_component.dart';
import 'package:ecommerce_sem4/screens/user/post/views/filter_post_screen.dart';
import 'package:ecommerce_sem4/services/user/auth/auth_service.dart';
import 'package:ecommerce_sem4/services/user/post/post_service.dart';
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../services/user/order/order_service.dart';

class AccountOrderScreen extends StatefulWidget{

  const AccountOrderScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AccountOrderScreen();
}

class _AccountOrderScreen extends State<AccountOrderScreen>{
  final userOrderApi = userOrderUri;
  List<OrderItemResponse> userOrders = [];
  String? accessToken = "";
  String? userId = "";
  Map<String, String> headers = <String, String>{};
  final formatCurrency = NumberFormat.currency(symbol: "₫", decimalDigits: 0);
  final imageUrl = "http://10.0.2.2:5069/images/";

  @override
  void initState(){
    super.initState();
    AuthService().checkLoginStatus(context);
    _loadOrderUser();
  }

  Future<void> _loadOrderUser() async{
    final pref = await SharedPreferences.getInstance();
    accessToken = pref.getString("accessToken");
    userId = pref.getString("id");

    headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };


    final data = await OrderService().detail(userOrderApi+"/"+userId!, headers);
     final res = data?.map((item) => OrderItemResponse.fromJson(item)).toList();
  print(data);
    setState(() {
      userOrders = res!;
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
                            Navigator.pop(context);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //        const AccountScreen()));
                          },
                          color: whiteColor,
                        ),
                      ],
                    ),
                   const Text(
                      "Danh Sách Đơn Hàng",
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 23,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),

                  ],
                )
            ),
            backgroundColor: greenBgColor,
            automaticallyImplyLeading: false,
          ),
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(12, 15, 12, 15),
          child: Column(
            children: [
              Expanded(
                child:
                ListView.builder(
                  itemCount: userOrders.length,
                  itemBuilder: (context, index) {
                    final userOrder = userOrders[index];
                    // Calculate total with shipping fee
                    final totalWithShipping = (userOrder.totalPrice ?? 0) + 30000;

                    return UserOrderItem(
                      orderId: userOrder.orderId, 
                      orderDate: userOrder.orderDate!,
                      totalPrice: totalWithShipping, 
                      orderUser: userOrder,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}