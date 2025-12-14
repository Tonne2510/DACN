
import 'package:flutter/material.dart';

class CategoryComponent extends StatelessWidget{
  final String name;
  const CategoryComponent({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
   return  Column(
     children: [
       Container(
         width: 70.0,
         height: 70.0,
         decoration: BoxDecoration(
           shape: BoxShape.circle,
           color: Color(0xFFF0F8EA),
           border: Border.all(
             color: Color(0xFFE8F5E0),
             width: 2,
           ),
         ),
         child: Icon(
           Icons.eco,
           size: 35,
           color: Color(0xFF4A7C2C),
         ),
       ),
       Padding(
         padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        child:  Text(
           name,
           textAlign: TextAlign.center,
           maxLines: 2,
           style: const TextStyle(
               color: Color(0xFF2D5016),
               fontFamily: "Poppins",
               fontSize: 12,
               fontWeight: FontWeight.w500,
           ),
         ),
       )
     ],
   );
  }
}