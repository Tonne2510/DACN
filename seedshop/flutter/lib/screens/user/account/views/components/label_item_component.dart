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

class LabelItem extends StatelessWidget {
  final String labelName;
  final String content;


  const LabelItem(
      {super.key,
        required this.labelName,
        required this.content,
        });

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Text(
          labelName,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
           content,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }
}
