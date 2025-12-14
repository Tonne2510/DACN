

class Cart {
  final int id;
  final String userId;
  final String? account;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Cart({
    required this.id,
    required this.userId,
    this.account,
    required this.createdAt,
    this.updatedAt,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['id'],
      userId: json['userId'],
      account: json['account'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}