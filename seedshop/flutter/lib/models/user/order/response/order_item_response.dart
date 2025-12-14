

class OrderItemResponse {
  int orderId;
  String? userName;
  String? email;
  String? gender;
  String? avatar;
  String? phone;
  String? orderDate;
  String? shippingAddress;
  String? status;
  List<OrderItem>? orderItems;
  double? totalPrice;
  OrderItemResponse({ required this.orderId, this.userName, this.email, this.gender, this.avatar, this.phone, this.orderDate,this.shippingAddress,this.status,this.orderItems,this.totalPrice});

  factory OrderItemResponse.fromJson(Map<String, dynamic> json) {
    return OrderItemResponse(
        orderId: json['orderId'],
        userName: json['userName'],
        email: json['email'],
        gender: json['gender'],
        avatar:json['avatar'],
        phone: json['phone'],
        orderDate: json['orderDate'],
        shippingAddress: json['shippingAddress'],
        status: json['status'],
        orderItems: (json['orderItems'] as List)
            .map((item) => OrderItem.fromJson(item))
            .toList(),
        totalPrice:json['totalPrice'].toDouble()
    );
  }
}

class OrderItem {
  String? productName;
  int? quantity;
  double? price;
  double? subTotal;

  OrderItem({this.productName, this.quantity,this.price, this.subTotal});

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
        productName: json['productName'],
        quantity:json['quantity'],
        price:json['price'].toDouble(),
        subTotal: json['subTotal'].toDouble()
    );
  }
}