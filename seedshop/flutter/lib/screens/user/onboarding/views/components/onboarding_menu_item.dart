
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';

class OnBoardingItem extends StatelessWidget{
  final String image;
  final String title;
  const OnBoardingItem
  (
  {
    super.key,
    required this.image,
    required this.title
  }
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(image, width: 35,height: 35,),
         Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
          child:  Text(
            title,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                color: greyColor
            ),
          ),
        )
      ],
    );
  }
}