import 'package:ecommerce_sem4/models/user/cart/request/add_cart_request.dart';
import 'package:ecommerce_sem4/models/user/order/response/order_item_response.dart';
import 'package:ecommerce_sem4/models/user/post/response/post_model.dart';
import 'package:ecommerce_sem4/models/user/product/response/product_model.dart';
import 'package:ecommerce_sem4/screens/user/account/views/account_order_detail_screen.dart';
import 'package:ecommerce_sem4/screens/user/post/views/post_detail_screen.dart';
import 'package:ecommerce_sem4/screens/user/product/views/product_detail_screen.dart';
import 'package:ecommerce_sem4/services/user/cart/cart_service.dart';
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserOrderItem extends StatelessWidget {
  final int orderId;
  final String orderDate;
  final double? totalPrice;
  final OrderItemResponse? orderUser;
  final imageUrl = "http://10.0.2.2:5069/images/";

  const UserOrderItem(
      {super.key,
      required this.orderId,
      required this.orderDate,
      this.totalPrice,
      this.orderUser});

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(symbol: "₫", decimalDigits: 0);

    return GestureDetector(
      child: Container(
        height: 120,
        margin: const EdgeInsets.all(5),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mã đơn: " + orderId.toString(),
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: blackColor,
                          overflow: TextOverflow.ellipsis),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Ngày đặt: " +
                              DateFormat('dd/MM/yyyy')
                                  .format(DateTime.parse(orderDate)),
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Tổng giá: " + formatCurrency.format(totalPrice),
                          style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserOrderDetailScreen(
                      userOrder: orderUser,
                    )));
      },
    );
  }
}
