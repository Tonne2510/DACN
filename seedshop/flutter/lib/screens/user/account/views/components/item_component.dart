

import 'package:flutter/material.dart';

class ItemComponent extends StatelessWidget{
  final String text;
  final Widget iconButton;
  final void Function()? event;

  const ItemComponent({super.key, required this.text, required this.iconButton, required this.event});

  void _logout() {
    event!();
  }

  @override
  Widget build(BuildContext context) {
   return GestureDetector(
     onTap: _logout,
     child: Row(
       children: [
         Container(
           decoration: BoxDecoration(
               shape: BoxShape.rectangle,
               color: Color(0xFFC2E3CD),
               borderRadius: BorderRadius.circular(10.0)
           ),
           child: IconButton(
             icon: iconButton,
             onPressed: _logout,
           ),
         ),
         Padding(
           padding:const EdgeInsets.only(left: 10.0),
           child: Text(
            text,
             style:const TextStyle(
                 color: Colors.black,
                 fontSize: 18,
                 fontWeight: FontWeight.bold
             ),
           ),
         )
       ],
     ),
   );
  }

}