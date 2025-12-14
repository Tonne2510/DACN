import 'package:ecommerce_sem4/components/navigator/bottom_navigator_bar_component.dart';
import 'package:ecommerce_sem4/route/user/router_constants.dart';
import 'package:ecommerce_sem4/screens/user/category/views/category_screen.dart';
import 'package:ecommerce_sem4/screens/user/explore/views/components/shop_appbar_component.dart';
import 'package:ecommerce_sem4/screens/user/explore/views/components/shop_component.dart';
import 'package:ecommerce_sem4/screens/user/explore/views/explore_navigator.dart';
import 'package:ecommerce_sem4/screens/user/home/views/components/home_component.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: HomeComponent(),
      ),
    );
  }
}

