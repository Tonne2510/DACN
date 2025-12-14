

import 'package:ecommerce_sem4/route/user/router_constants.dart';
import 'package:ecommerce_sem4/screens/user/onboarding/views/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService{

  //check token valid
  bool isExpiredToken(int expirationTimestamp) {
    DateTime expirationDate = DateTime.fromMillisecondsSinceEpoch(expirationTimestamp);

    DateTime currentDate = DateTime.now();
    if (currentDate.isBefore(expirationDate)) {
      return false;
    } else {
      return true;
    }
  }

  //check isLogined
  Future<void> checkLoginStatus(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();
    String? accessToken = pref.getString("accessToken");
    if(accessToken!=null){
      int? exp = pref.getInt("exp");
      bool isExpired = isExpiredToken(exp!);
      if (isExpired) {
        await logout();
        // Navigator.pushReplacementNamed(context, onboardingScreenRoute);
        // Navigator.of(context).pushAndRemoveUntil(
        //   MaterialPageRoute(builder: (context) => OnBoardingScreen()),
        //       (Route<dynamic> route) => false,
        // );
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => OnBoardingScreen()),
              (Route<dynamic> route) => false,
        );

      }
    }else {
      // Navigator.pushReplacementNamed(context, onboardingScreenRoute);
      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(builder: (context) => OnBoardingScreen()),
      //       (Route<dynamic> route) => false,
      // );
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => OnBoardingScreen()),
            (Route<dynamic> route) => false,
      );
    }
  }

  // Logout function to clear all user data
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}