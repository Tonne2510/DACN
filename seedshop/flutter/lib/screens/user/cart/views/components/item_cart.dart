import 'package:ecommerce_sem4/models/user/cart/response/cart_list_response.dart';
import 'package:ecommerce_sem4/screens/user/cart/views/cart_screen.dart';
import 'package:ecommerce_sem4/services/user/cart/cart_service.dart';
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemCart extends StatefulWidget{
  final CartListResponse? cartResponse;
  final Function? onDelete;
  final Function(int quantity)? onUpdateQuantity;
  const ItemCart({super.key, required this.cartResponse, this.onDelete, this.onUpdateQuantity});

  @override
  State<StatefulWidget> createState() => _ItemCart();
}

class _ItemCart extends State<ItemCart>{
  String? accessToken = "";
  Map<String, String> headers = <String, String>{};
  final TextEditingController _quantityController = TextEditingController();
  final imageUrl = "http://10.0.2.2:5069/images/";


  @override
  void initState(){
    super.initState();
    _quantityController.text = widget.cartResponse!.quantity.toString();
  }

  final formatCurrency = NumberFormat.currency(symbol: "₫", decimalDigits: 0);

  void _decrementQuantity() {
    if(int.parse(_quantityController.text)>1){
      int updatedQuantity = int.parse(_quantityController.text)-1;
      _quantityController.text = updatedQuantity.toString();
      _updateQuantity(updatedQuantity);
    }

  }

  void _incrementQuantity(){
    int updatedQuantity = int.parse(_quantityController.text)+1;
    _quantityController.text = updatedQuantity.toString();
    _updateQuantity(updatedQuantity);
  }

  _updateQuantity(int newQuantity) {
    widget.onUpdateQuantity!(newQuantity);
  }

  Future<void> _removeItem() async {
    widget.onDelete!();
  }

  @override
  void dispose(){
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 7),
      height: 100,
      child: Card(
        margin: EdgeInsets.zero,
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Container(
            //   margin:const EdgeInsets.all(6),
            //   width: 100,
            //   decoration: BoxDecoration(
            //       border: Border.all(
            //         color: Colors.grey,
            //         width: 1,
            //       ),
            //       borderRadius: BorderRadius.circular(10),
            //       shape: BoxShape.rectangle,
            //       image: const DecorationImage(
            //           image: AssetImage("assets/user/images/category_6.png"),
            //           fit: BoxFit.contain
            //       )
            //   ),
            // ),
            Container(
              margin: const EdgeInsets.all(6),
              width: 100,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10), // To match the border radius of the Container
                child: Image.network(
                  '$imageUrl${widget.cartResponse?.product.image}', // Replace with your image URL
                  fit: BoxFit.contain,
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                    // Fallback image in case of an error
                    return Image.asset(
                      "assets/user/images/category_6.png",
                      fit: BoxFit.contain,
                    );
                  },
                  // loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  //   if (loadingProgress == null) return child; // Image loaded successfully
                  //   return Center(
                  //       child: CircularProgressIndicator(
                  //         value: loadingProgress.expectedTotalBytes != null
                  //             ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                  //             : null,
                  //       ); // Loading indicator
                  //   );
                  // },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(
                    width: 100,
                    child: Text(
                      softWrap: true,
                      widget.cartResponse!.product.productName,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 17
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (widget.cartResponse!.product.salePrice > 0)
                    Text(
                      formatCurrency.format(widget.cartResponse!.product.price),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  if (widget.cartResponse!.product.salePrice > 0)
                    const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        formatCurrency.format(
                          widget.cartResponse!.product.salePrice > 0 
                            ? widget.cartResponse!.product.salePrice 
                            : widget.cartResponse!.product.price
                        ),
                        style: const TextStyle(
                            color: greenBgColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        ),
                      ),
                      if (widget.cartResponse!.product.salePrice > 0) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            '-${(((widget.cartResponse!.product.price - widget.cartResponse!.product.salePrice) / widget.cartResponse!.product.price) * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                        height: 30,
                        padding:const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: lightGreenBg2,
                              ),
                              child: IconButton(
                                onPressed: _decrementQuantity,
                                icon: const Icon(Icons.remove,color: greenBgColor,),
                                padding: EdgeInsets.zero,
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              height: 50,
                              child: TextFormField(
                                controller: _quantityController,
                                textAlign: TextAlign.center,
                                decoration:const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  // setState(() {
                                  //   _quantity = int.tryParse(value) ?? 1;
                                  // });
                                },
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: lightGreenBg2,
                              ),
                              child: IconButton(
                                onPressed: _incrementQuantity,
                                icon: const Icon(Icons.add,color: greenBgColor,),
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        )
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 22,
                      height: 22,
                      child:  IconButton(
                        onPressed: _removeItem,
                        icon: Icon(Icons.close, size: 15.0,color: Colors.grey,),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              )
              ,
            )
          ],
        ),
      ),
    );
  }
}