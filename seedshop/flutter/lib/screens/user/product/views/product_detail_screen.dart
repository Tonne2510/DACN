import 'package:ecommerce_sem4/models/user/cart/request/add_cart_request.dart';
import 'package:ecommerce_sem4/models/user/product/response/product_model.dart';
import 'package:ecommerce_sem4/screens/user/product/views/components/bottom_button.dart';
import 'package:ecommerce_sem4/services/user/auth/auth_service.dart';
import 'package:ecommerce_sem4/services/user/cart/cart_service.dart';
import 'package:ecommerce_sem4/services/user/product/product_service.dart';
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product? product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<StatefulWidget> createState() => _ProductDetail();
}

class _ProductDetail extends State<ProductDetailScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _quantity = 1;
  final formatCurrency = NumberFormat.currency(symbol: "₫", decimalDigits: 0);
  final String cartPost = cartAddUri;
  final imageUrl = "http://10.0.2.2:5069/images/";

  String _removeHtmlTags(String htmlString) {
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    // Remove HTML tags first
    String cleaned = htmlString.replaceAll(exp, '');

    // Decode common HTML entities
    final Map<String, String> htmlEntities = {
      '&nbsp;': ' ',
      '&amp;': '&',
      '&lt;': '<',
      '&gt;': '>',
      '&quot;': '"',
      '&#39;': "'",
      '&aacute;': 'á',
      '&eacute;': 'é',
      '&iacute;': 'í',
      '&oacute;': 'ó',
      '&uacute;': 'ú',
      '&yacute;': 'ý',
      '&Aacute;': 'Á',
      '&Eacute;': 'É',
      '&Iacute;': 'Í',
      '&Oacute;': 'Ó',
      '&Uacute;': 'Ú',
      '&Yacute;': 'Ý',
      '&agrave;': 'à',
      '&egrave;': 'è',
      '&igrave;': 'ì',
      '&ograve;': 'ò',
      '&ugrave;': 'ù',
      '&Agrave;': 'À',
      '&Egrave;': 'È',
      '&Igrave;': 'Ì',
      '&Ograve;': 'Ò',
      '&Ugrave;': 'Ù',
      '&acirc;': 'â',
      '&ecirc;': 'ê',
      '&icirc;': 'î',
      '&ocirc;': 'ô',
      '&ucirc;': 'û',
      '&Acirc;': 'Â',
      '&Ecirc;': 'Ê',
      '&Icirc;': 'Î',
      '&Ocirc;': 'Ô',
      '&Ucirc;': 'Û',
      '&atilde;': 'ã',
      '&ntilde;': 'ñ',
      '&otilde;': 'õ',
      '&Atilde;': 'Ã',
      '&Ntilde;': 'Ñ',
      '&Otilde;': 'Õ',
      '&auml;': 'ä',
      '&euml;': 'ë',
      '&iuml;': 'ï',
      '&ouml;': 'ö',
      '&uuml;': 'ü',
      '&yuml;': 'ÿ',
      '&Auml;': 'Ä',
      '&Euml;': 'Ë',
      '&Iuml;': 'Ï',
      '&Ouml;': 'Ö',
      '&Uuml;': 'Ü',
    };

    htmlEntities.forEach((entity, char) {
      cleaned = cleaned.replaceAll(entity, char);
    });

    return cleaned.trim();
  }

  Future<void> _addToCart() async {
    // Get userId and accessToken from SharedPreferences
    final pref = await SharedPreferences.getInstance();
    String? userId = pref.getString("id");
    String? accessToken = pref.getString("accessToken");

    // Set up headers with authorization
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };

    // Create request payload
    double finalPrice = widget.product!.salePrice > 0
        ? widget.product!.salePrice
        : widget.product!.price;
    Map<String, Object?> request = CartRequest(
      userId: userId!,
      productId: widget.product!.id.toString(),
      quantity: _searchController.text,
      price: finalPrice.toInt().toString(),
    ).toMap();

    final data = await CartService().addToCart(cartPost, headers, request);

    if (data != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Đã thêm sản phẩm vào giỏ hàng thành công!"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    AuthService().checkLoginStatus(context);
    _searchController.text = _quantity.toString();
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
      _searchController.text = _quantity.toString();
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
        _searchController.text = _quantity.toString();
      });
    }
  }

  //to release any resources as input
  @override
  void dispose() {
    _searchController.dispose();
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
            title: const Text("Chi Tiết Sản Phẩm"),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Container(
                      //   // width: double.infinity,
                      //   alignment: Alignment.center,
                      //   height: 300,
                      //   decoration:  BoxDecoration(
                      //       shape: BoxShape.rectangle,
                      //       // image: DecorationImage(
                      //       //     image: AssetImage("assets/user/images/slide1.jpg"),
                      //       //     fit: BoxFit.cover
                      //       // )
                      //       image: DecorationImage(
                      //         image: NetworkImage('$imageUrl${widget.product?.image}'),
                      //         fit: BoxFit.cover,
                      //
                      //       )
                      //   ),
                      // ),
                      Container(
                        alignment: Alignment.topCenter,
                        width: double.infinity,
                        height: 300,
                        child: Image.network(
                          '$imageUrl${widget.product?.image}',
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            // Return a placeholder image if there's an error loading the network image
                            return Image.asset("assets/user/images/slide1.jpg",
                                fit: BoxFit.cover);
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(8, 0, 0, 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.product!.productName,
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25),
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    IconButton(
                                      onPressed: _decrementQuantity,
                                      icon: const Icon(Icons.remove),
                                      padding: EdgeInsets.zero,
                                    ),
                                    SizedBox(
                                      width: 50,
                                      child: TextFormField(
                                        controller: _searchController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                        ),
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          setState(() {
                                            _quantity =
                                                int.tryParse(value) ?? 1;
                                          });
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: _incrementQuantity,
                                      icon: const Icon(Icons.add),
                                      color: greenBgColor,
                                    ),
                                  ],
                                )),
                                if (widget.product!.salePrice > 0)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        formatCurrency
                                            .format(widget.product!.price),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              '-${(((widget.product!.price - widget.product!.salePrice) / widget.product!.price) * 100).toStringAsFixed(0)}%',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            formatCurrency.format(
                                                widget.product!.salePrice),
                                            style: const TextStyle(
                                                color: Colors.black87,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 26),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                if (widget.product!.salePrice <= 0)
                                  Text(
                                    formatCurrency
                                        .format(widget.product!.price),
                                    style: const TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 26),
                                  ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Divider(
                              color: Colors.grey, // Set the color to grey
                              thickness: 1, // Adjust thickness as desired
                              indent:
                                  16, // Optional: add spacing on the left side
                              endIndent:
                                  16, // Optional: add spacing on the right side
                            ),
                            Padding(
                                padding: EdgeInsets.fromLTRB(8, 10, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Mô Tả",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      _removeHtmlTags(
                                          widget.product?.description ??
                                              "Không có mô tả"),
                                      style: TextStyle(
                                        color: Color(0xFF666666),
                                        fontSize: 14,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BottomButton(
                buttonName: "Thêm Vào Giỏ Hàng",
                price: widget.product!.salePrice > 0
                    ? widget.product!.salePrice
                    : widget.product!.price,
                quantity: _quantity,
                event: _addToCart,
              )
            ],
          )),
    );
  }
}
