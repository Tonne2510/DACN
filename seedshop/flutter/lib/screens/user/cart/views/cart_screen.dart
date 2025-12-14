

import 'package:ecommerce_sem4/models/user/cart/response/cart_list_response.dart';
import 'package:ecommerce_sem4/screens/user/cart/views/components/bottom_button_cart.dart';
import 'package:ecommerce_sem4/screens/user/cart/views/components/item_cart.dart';
import 'package:ecommerce_sem4/screens/user/onboarding/views/components/onboarding_dashed_line.dart';
import 'package:ecommerce_sem4/screens/user/product/views/components/bottom_button.dart';
import 'package:ecommerce_sem4/services/user/auth/auth_service.dart';
import 'package:ecommerce_sem4/services/user/cart/cart_service.dart';
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget{
  const CartScreen({super.key});

  @override
  State<StatefulWidget> createState() => _CartScreen();
}
class _CartScreen extends State<CartScreen>{
  String? accessToken  = "";
  Map<String, String> headers = <String, String>{};
  List<CartListResponse> carts = [];
  String price ="0.0";
  final double shippingFee = 30000;
  final formatCurrency = NumberFormat.currency(symbol: "₫", decimalDigits: 0);

  @override
  void initState(){
    super.initState();
    AuthService().checkLoginStatus(context);
    _loadProducts();

  }

  Future<void> _loadProducts() async {
    final pref = await SharedPreferences.getInstance();
    accessToken = pref.getString("accessToken");
    String? userId = pref.getString("id");

    headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };

    Map<String, Object?> request = {
      "userId": userId
    };

    final data = await CartService().getCart(getCartUri, headers, request);
    setState(() {
      carts = data!;
    });
    _caculateTotal();
  }

  Future<void> _removeItem(CartListResponse product, int index) async {
    final pref = await SharedPreferences.getInstance();
    accessToken = pref.getString("accessToken");
    String? userId = pref.getString("id");

    headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };

    Map<String, Object?> request = {
      "userId": userId,
    };

    final data = await CartService().getCartIdByUserId(getCartByUserIdUri, headers, request);

    Map<String, Object?> requestRemoveItem = {
      "cartId": data["cartId"].toString(),
      "productId": product.productId.toString(),
    };

    final res =  await CartService().removeItem(removeCartUri, headers, requestRemoveItem);

    if (res != null) {
      setState(() {
        carts.remove(product);
      });
      _caculateTotal();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Đã xóa sản phẩm khỏi giỏ hàng thành công!"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _updateQuantity(CartListResponse product, int quantity) async {
    final pref = await SharedPreferences.getInstance();
    accessToken = pref.getString("accessToken");
    String? userId = pref.getString("id");

    headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };

    Map<String, Object?> request = {
      "userId": userId,
    };

    final data = await CartService().getCartIdByUserId(getCartByUserIdUri, headers, request);

    Map<String, Object?> requestUpdateQuantity = {
      "cartId": data["cartId"].toString(),
      "productId": product.productId.toString(),
      "quantity": quantity.toString()
    };

   final res= await CartService().updateQuantity(updateQuantityUri, headers, requestUpdateQuantity);
    if(res!=null){
      setState(() {
        product.quantity = quantity;
      });
      _caculateTotal();
    }
  }


  void _caculateTotal() {
    double total = 0.0;
    for (var element in carts) {
      total+=(element.quantity * element.price);
    }
    setState(() {
      price = total.toString();
    });
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: greenBgColor,
            title: const Text(
              "Giỏ Hàng",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            centerTitle: true,
          ),
          body: Container(
            color: Color(0xFFF4F4F4), // Full-screen background color
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                      child: Column(
                        children: [
                          // Items
                          ...carts.asMap().entries.map((entry) {
                            final index = entry.key;
                            final cartItem = entry.value;

                            return ItemCart(
                              key: ValueKey(index),
                              cartResponse: cartItem,
                              onDelete: () => _removeItem(cartItem, index),
                              onUpdateQuantity: (quantity) => _updateQuantity(cartItem, quantity),
                            );
                          }).toList(),

                          SizedBox(height: 10),

                          // Promo code and totals container
                          Container(
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                // Promo code field
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: TextFormField(
                                    textAlign: TextAlign.left,
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: borderInput, width: 1.0),
                                        borderRadius: BorderRadius.circular(50.0),
                                      ),
                                      hintText: "Nhập mã khuyến mãi",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                      suffixIcon: Container(
                                        height: double.infinity,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(50.0),
                                            bottomRight: Radius.circular(50.0),
                                          ),
                                          color: greenBgColor,
                                        ),
                                        width: 130,
                                        child: Text(
                                          "Áp Dụng",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      // Your code for handling changes
                                    },
                                  ),
                                ),
                                SizedBox(height: 20),
                                // Summary rows
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Tạm tính", style: TextStyle(color: Colors.grey)),
                                    Text(formatCurrency.format(double.parse(price)), style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Phí giao hàng", style: TextStyle(color: Colors.grey)),
                                    Text(formatCurrency.format(shippingFee), style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                               const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Giảm giá", style: TextStyle(color: Colors.grey)),
                                    Text("0", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 17),
                             const  OnBoardingDashedLine(width: 1000, color: Colors.blue, dashGap: 10, dashLength: 100),
                              const  SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                   const Text("Ổng cộng", style: TextStyle(color: Colors.grey)),
                                    Text(formatCurrency.format(double.parse(price) + shippingFee), style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                BottomButtonCart(buttonName: "Thanh Toán",totalPrice: double.parse(price) + shippingFee,event: () => {},)
              ],
            ),
          )
      ),
    );
  }
}