

import 'package:ecommerce_sem4/components/navigator/bottom_navigator_bar_component.dart';
import 'package:ecommerce_sem4/screens/user/account/views/account_screen.dart';
import 'package:ecommerce_sem4/screens/user/cart/views/cart_screen.dart';
import 'package:ecommerce_sem4/screens/user/explore/views/explore_navigator.dart';
import 'package:ecommerce_sem4/screens/user/favourite/views/favourite_screen.dart';
import 'package:ecommerce_sem4/screens/user/home/views/home_screen.dart';
import 'package:ecommerce_sem4/screens/user/post-category/views/post_category_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LayoutScreen extends StatefulWidget{
  const LayoutScreen({super.key});

  @override
  State<StatefulWidget> createState() => LayoutPage();
}

class LayoutPage extends State<LayoutScreen>{
  int _selectedIndex = 0;

  final List<Widget> _bodyContent = [
    const HomeScreen(),
    const ExploreNavigator(),
    const CartScreen(),
    // const FavouriteScreen(),
    const PostCategoryScreen(),
    const AccountScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
   return SafeArea(
     child: Scaffold(
       body:_bodyContent[_selectedIndex],
       bottomNavigationBar: BottomNavBar(
         onItemTapped: _onItemTapped,
         selectedIndex: _selectedIndex,
       ),
     ),
   );
  }

}