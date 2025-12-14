
import 'package:ecommerce_sem4/models/user/cart/request/add_cart_request.dart';
import 'package:ecommerce_sem4/models/user/product/response/product_model.dart';
import 'package:ecommerce_sem4/screens/user/product/views/product_detail_screen.dart';
import 'package:ecommerce_sem4/services/user/cart/cart_service.dart';
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardProduct extends StatelessWidget{
  final String image;
  final String name;
  final String price;
  final Product? product;

  const CardProduct({super.key, required this.image, required this.name, required this.price, this.product});

  Future<void> _addToCart(BuildContext context) async {
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
    double finalPrice = product!.salePrice > 0 ? product!.salePrice : product!.price;
    Map<String, Object?> request = CartRequest(
      userId: userId!,
      productId: product!.id.toString(),
      quantity: "1",
      price: finalPrice.toInt().toString(),
    ).toMap();

    final data = await CartService().addToCart(cartAddUri, headers, request);

    if (data != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Đã thêm sản phẩm vào giỏ hàng thành công!"),
          duration: Duration(seconds: 2),
          backgroundColor: Color(0xFF4A7C2C),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
   return Card(
     elevation: 2,
     shadowColor: Colors.black.withOpacity(0.06),
     shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(12),
       side: BorderSide(color: Color(0xFFF0F0F0), width: 1),
     ),
     child: InkWell(
       onTap: (){
         Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)));
       },
       borderRadius: BorderRadius.circular(12),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: <Widget>[
           ClipRRect(
             borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
             child: Container(
               color: Color(0xFFF8F9FA),
               child: Image.network(
                 image,
                 height: 150,
                 width: double.infinity,
                 fit: BoxFit.cover,
                 errorBuilder: (context, error, stackTrace) => Image.asset(
                   "assets/user/images/slide1.jpg",
                   height: 150,
                   width: double.infinity,
                   fit: BoxFit.cover,
                 ),
               ),
             ),
           ),
           Padding(
             padding: const EdgeInsets.all(12.0),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children:  [
                Text(
                  name,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A3A0F),
                    overflow: TextOverflow.ellipsis,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                 if (product != null && product!.salePrice > 0)
                   Row(
                     children: [
                       Text(
                         price,
                         style: const TextStyle(
                           color: Colors.grey,
                           fontSize: 14,
                           decoration: TextDecoration.lineThrough,
                         ),
                       ),
                       const SizedBox(width: 8),
                       Container(
                         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                         decoration: BoxDecoration(
                           color: Colors.red,
                           borderRadius: BorderRadius.circular(4),
                         ),
                         child: Text(
                           '-${(((product!.price - product!.salePrice) / product!.price) * 100).toStringAsFixed(0)}%',
                           style: const TextStyle(
                             color: Colors.white,
                             fontSize: 11,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                       ),
                     ],
                   ),
                 if (product != null && product!.salePrice > 0)
                   const SizedBox(height: 4),
                 Text(
                   product != null && product!.salePrice > 0 
                       ? '${product!.salePrice.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}₫'
                       : price,
                   style: const TextStyle(
                       color: Color(0xFF4A7C2C),
                       fontWeight: FontWeight.bold,
                       fontSize: 18,
                   ),
                 ),
                 const SizedBox(height: 8),
                 SizedBox(
                   width: double.infinity,
                   child: Container(
                     decoration: BoxDecoration(
                       gradient: LinearGradient(
                         colors: [
                           Color(0xFF4A7C2C),
                           Color(0xFF6BA83E),
                         ],
                       ),
                       borderRadius: BorderRadius.circular(8),
                     ),
                     child: ElevatedButton.icon(
                       onPressed: ()=>_addToCart(context),
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.transparent,
                         shadowColor: Colors.transparent,
                         padding: const EdgeInsets.symmetric(vertical: 10),
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(8),
                         ),
                       ),
                       icon: const Icon(Icons.shopping_cart, color: Colors.white, size: 18),
                       label: const Text(
                         'Thêm giỏ hàng',
                         style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                       ),
                     ),
                   ),
                 ),
               ],
             ),
           ),
         ],
       ),
     ),
   );
  }
}