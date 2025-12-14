import 'dart:async';

import 'package:ecommerce_sem4/screens/user/home/views/home_screen.dart';
import 'package:ecommerce_sem4/screens/user/onboarding/views/onboarding_screen.dart';
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MySplashScreen();
}

class _MySplashScreen extends State<SplashScreen>{

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
               const OnBoardingScreen()
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
   return SafeArea(
     child: Scaffold(
     body:  Container(
       color: greenBgColor,
       width: double.infinity,
       height: double.infinity,
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Container(
             width: 160,
             child: Image.asset("assets/user/images/logo1.png"),
           ),
           SizedBox(
             height: 20,
           ),
           Text(
               "DESHI MART",
             style: TextStyle(
               color: Colors.white,
               fontSize: 24
             ),
           )
         ],
       ),
     ),
     ),
   );
  }
}