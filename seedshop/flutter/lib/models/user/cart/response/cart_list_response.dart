
import 'package:ecommerce_sem4/models/user/cart/response/cart_model.dart';
import 'package:ecommerce_sem4/models/user/product/response/product_model.dart';

class CartListResponse {
  final int id;
  final int cartId;
  final Cart cart;
  final int productId;
  final Product product;
  final double price;
   int quantity;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CartListResponse({
    required this.id,
    required this.cartId,
    required this.cart,
    required this.productId,
    required this.product,
    required this.price,
    required this.quantity,
    required this.createdAt,
    this.updatedAt,

  });

  factory CartListResponse.fromJson(Map<String, dynamic> json) {
    return CartListResponse(
      id: json['id'],
      cartId: json['cartId'],
      cart: Cart.fromJson(json['cart']),
      productId: json['productId'],
      product: Product.fromJson(json['product']),
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

 static List<CartListResponse> parseCartListResponse(List<dynamic> jsonList) {
    return jsonList.map((json) => CartListResponse.fromJson(json as Map<String, dynamic>)).toList();
  }
}