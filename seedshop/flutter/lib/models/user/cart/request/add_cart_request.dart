
class CartRequest{
  final String userId;
  final String productId;
  final String quantity;
  final String price;

  const CartRequest({required this.userId, required this.productId, required this.quantity, required this.price});

  Map<String, Object?> toMap() {
    return {
      "userId": userId,
      "productId":productId,
      "quantity": quantity,
      "price": price,
    };
  }
}
