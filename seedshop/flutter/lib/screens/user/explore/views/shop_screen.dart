
import 'package:ecommerce_sem4/screens/user/explore/views/components/shop_appbar_component.dart';
import 'package:ecommerce_sem4/screens/user/explore/views/components/shop_component.dart';
import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget{
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
   return const SafeArea(
     child: Scaffold(
       appBar: ShopAppBar(),
       body: ShopComponent()
     ),
   );
  }
}