
import 'package:ecommerce_sem4/route/user/router_constants.dart';
import 'package:ecommerce_sem4/screens/user/auth/views/login_screen.dart';
import 'package:ecommerce_sem4/screens/user/onboarding/views/components/onboarding_dashed_line.dart';
import 'package:ecommerce_sem4/screens/user/onboarding/views/components/onboarding_menu_item.dart';
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen extends StatelessWidget{
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
      return SafeArea(
        child:  Scaffold(
          body: Container(
            color: greenBgColor,
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
            child: Column(
              children: [
                SizedBox(
                  child: Container(
                   // color: Colors.green,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius:  BorderRadius.circular(20),
                      border: Border.all(
                        color: blackColor,
                        width: 1
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: const Offset(0, 4),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 55, 0, 35),
                      child:  Center(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset('assets/user/images/logo.png',width: 100,),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                      child: Column(
                                        children: [
                                          RichText(
                                            text:const TextSpan(
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: 'DESHI ',
                                                    style: TextStyle(
                                                      fontSize: 30,
                                                      color: greenBgColor,
                                                      fontFamily: 'Rowdies',
                                                    ),
                                                  ),
                                                  TextSpan(
                                                      text: 'MART',
                                                      style: TextStyle(
                                                          fontSize: 30,
                                                          color: blackColor,
                                                          fontFamily: 'Rowdies'
                                                      )
                                                  ),
                                                ]
                                            ),
                                          ),
                                          const Text(
                                            'Desh ka market',
                                            style: TextStyle(
                                              fontSize: 24,
                                              color: greyColor,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ],
                                      )
                                    )
                                  ],
                                )
                              ],
                            ),
                           const SizedBox(
                              height: 50,
                            ),
                           const OnBoardingItem(image: 'assets/user/images/leaf.jpg', title: 'Organic Groceries '),
                           const Padding(
                              padding:  EdgeInsets.fromLTRB(0, 10, 20, 0),
                              child:  OnBoardingDashedLine(width: 1000, color: Colors.blue,dashGap: 10,dashLength: 100,),
                            ),

                            const SizedBox(
                              height: 5,
                            ),
                            const OnBoardingItem(image: 'assets/user/images/chicken.jpg', title: 'Whole foods and vegitable'),
                            const Padding(
                              padding:  EdgeInsets.fromLTRB(0, 10, 20, 0),
                              child:  OnBoardingDashedLine(width: 1000, color: Colors.blue,dashGap: 10,dashLength: 100,),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const OnBoardingItem(image: 'assets/user/images/trank.jpg', title: 'Fast Delivery '),
                            const Padding(
                              padding:  EdgeInsets.fromLTRB(0, 10, 20, 0),
                              child:  OnBoardingDashedLine(width: 1000, color: Colors.blue,dashGap: 10,dashLength: 100,),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const OnBoardingItem(image: 'assets/user/images/kit.jpg', title: 'East Refund and return'),
                            const Padding(
                              padding:  EdgeInsets.fromLTRB(0, 10, 20, 0),
                              child:  OnBoardingDashedLine(width: 1000, color: Colors.blue,dashGap: 10,dashLength: 100,),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const OnBoardingItem(image: 'assets/user/images/security.jpg', title: 'Secure and safe'),
                          ],
                        )
                      ),
                    )
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Welcome to our Store',
                  style: TextStyle(
                    color: whiteColor,
                    fontFamily: 'Poppins',
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 5,
                ),
               const Opacity(
                  opacity: 0.7,
                  child: Text(
                    'Get your grocery in as fast as \n one hours',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.normal,
                        fontSize: 20,
                        color: whiteColor
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 33,
                ),
                 TextButton(
                     onPressed: (){
                       // Navigator.pushNamed(context, logInScreenRoute);
                       // Navigator.pushReplacementNamed(context, logInScreenRoute);
                       Navigator.pushReplacement(
                           context,
                           MaterialPageRoute(
                               builder: (context) => const LoginScreen())
                       );
                     },
                     style: TextButton.styleFrom(
                       backgroundColor: whiteColor,
                       shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(20)
                       ),
                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                     ),
                     child: Container(
                       width: double.infinity,
                       alignment: Alignment.center,
                       child: const Text(
                         'LOGIN',
                         style: TextStyle(
                             color:greenBgColor,
                             fontSize: 20,
                             fontFamily: 'Poppins',
                             fontWeight: FontWeight.w600
                         ),
                       ),
                     )
                 ),
              ],
            ),
          ),
        ),
      );
  }
}