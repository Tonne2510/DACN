
import 'package:ecommerce_sem4/models/user/account/response/account_model.dart';
import 'package:ecommerce_sem4/models/user/cart/request/add_cart_request.dart';
import 'package:ecommerce_sem4/models/user/order/request/create_request.dart';
import 'package:ecommerce_sem4/models/user/product/response/product_model.dart';
import 'package:ecommerce_sem4/screens/user/account/views/account_order_screen.dart';
import 'package:ecommerce_sem4/screens/user/product/views/components/bottom_button.dart';
import 'package:ecommerce_sem4/services/user/account/account_service.dart';
import 'package:ecommerce_sem4/services/user/auth/auth_service.dart';
import 'package:ecommerce_sem4/services/user/order/order_service.dart';
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutScreen extends StatefulWidget{
  final double totalPrice;

  const CheckoutScreen({super.key, required this.totalPrice});

  @override
  State<StatefulWidget> createState() => _CheckoutScreen();
}

class _CheckoutScreen extends State<CheckoutScreen>{
  final TextEditingController _addressController = TextEditingController();
  String? accessToken;
  String? userId;

  @override
  void initState() {
    super.initState();
    AuthService().checkLoginStatus(context);
    _loadUserAddress();
  }

  Future<void> _loadUserAddress() async {
    final pref = await SharedPreferences.getInstance();
    userId = pref.getString("id");
    accessToken = pref.getString("accessToken");

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };

    final account = await AccountService().detail("$getByIdAccountUri/$userId", headers);
    if (account != null && account.address != null) {
      setState(() {
        _addressController.text = account.address!;
      });
    }
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _createOrder() async {
    final pref = await SharedPreferences.getInstance();
    String? userId = pref.getString("id");
    String? accessToken = pref.getString("accessToken");
    String? apiUrlOrder = orderUri;

    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };

    String address = _addressController.text.trim();

    if(address.isEmpty || widget.totalPrice==0.0){
      _showAlertDialog("Ổi", "Vui lòng nhập địa chỉ và thêm sản phẩm vào giỏ hàng.");
      return;
    }
    Map<String, Object?> request = CreateOrderRequest(
      userId: userId!,
      status: "Ordered",
      shippingAddress: address,
      totalAmount: widget.totalPrice,
    ).toMap();

    final data = await OrderService().createOrder(apiUrlOrder, headers, request);

    if (data != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Đặt hàng thành công!"),
          duration: Duration(seconds: 2),
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const AccountOrderScreen())
        );
      });
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF4A7C2C),
            automaticallyImplyLeading: true,
            foregroundColor: whiteColor,
            title:  const Text("Thanh Toán"),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Địa Chỉ Giao Hàng",
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      controller: _addressController,
                                      decoration: const InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: borderInput, width: 1.0),

                                        ),

                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: borderInput, width: 1.0),

                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 15.0, horizontal: 20.0), // Add padding
                                        hintStyle: TextStyle(color: greyColor, fontSize: 13),
                                      ),
                                    ),

                                  const SizedBox(
                                      height: 10,
                                    ),

                                   const Text(
                                      "Phương Thức Thanh Toán",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                   const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Tiền mặt",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: greenBgColor,
                                      ),
                                    )

                                  ],
                                )
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BottomButton(buttonName: "Đặt Hàng",price:widget.totalPrice,quantity: 0,event: _createOrder,)
            ],
          )
      ),
    );
  }
}

