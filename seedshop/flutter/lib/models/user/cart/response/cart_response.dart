
class CartResponse {
   String? message;
  CartResponse({this.message});

   factory CartResponse.fromJson(Map<String, dynamic> json) {
     return CartResponse(
       message: json['message'],
     );
   }
}