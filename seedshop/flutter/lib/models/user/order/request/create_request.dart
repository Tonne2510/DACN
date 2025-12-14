
class CreateOrderRequest{
  String? userId;
  String? status;
  String? shippingAddress;
  double? totalAmount;


  CreateOrderRequest({
    this.userId,
    this.status,
    this.shippingAddress,
    this.totalAmount,
  });

  Map<String, Object?> toMap() {
    return {
      "userId": userId,
      "status":status,
      "shippingAddress": shippingAddress,
      "totalAmount": totalAmount
    };
  }
}