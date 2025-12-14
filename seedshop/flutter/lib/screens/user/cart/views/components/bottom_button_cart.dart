
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../checkout/views/checkout_screen.dart';

class BottomButtonCart extends StatelessWidget{
  final String buttonName;
  final double totalPrice;
  final void Function() event;


  const BottomButtonCart({super.key, required this.buttonName,required this.totalPrice, required this.event});


  @override
  Widget build(BuildContext context) {

    return  Container(
      padding:const EdgeInsets.fromLTRB(23, 15, 15, 15),
      color: greenBgColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(
                width: 200,
                child:  ElevatedButton(
                  onPressed: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context) => CheckoutScreen(totalPrice:totalPrice,)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: whiteColor,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Center(
                    child:
                    Text(
                      buttonName,
                      style: const TextStyle(
                        fontSize: 18,
                        color: greenBgColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}