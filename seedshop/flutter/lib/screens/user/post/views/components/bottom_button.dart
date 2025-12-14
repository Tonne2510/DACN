
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BottomButton extends StatelessWidget{
  final String buttonName;
  final int quantity;
  final double price;
  final void Function() event;


  const BottomButton({super.key, required this.buttonName, required this.quantity, required this.price, required this.event});


  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.currency(symbol: "₫", decimalDigits: 0);

   return  Container(
     padding:const EdgeInsets.fromLTRB(23, 15, 15, 15),
     color: greenBgColor,
     child: Column(
       children: [
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                const Text(
                   "Total Price",
                   style: TextStyle(
                       fontWeight: FontWeight.w400,
                       fontSize: 19,
                       color: whiteColor
                   ),
                 ),
                 Text(
                   formatCurrency.format( (quantity*price)),
                   style: const TextStyle(
                     fontWeight: FontWeight.bold,
                     fontSize: 20,
                     color: whiteColor,

                   ),
                 )
               ],
             ),
             SizedBox(
               width: 170,
               child:  ElevatedButton(
                 onPressed: event,
                 style: ElevatedButton.styleFrom(
                   backgroundColor: whiteColor,
                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                   elevation: 5,
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(10),

                   ),
                 ),
                 child: Center(
                   child: Text(
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