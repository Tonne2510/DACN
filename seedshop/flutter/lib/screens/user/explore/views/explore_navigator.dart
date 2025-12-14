
import 'package:ecommerce_sem4/screens/user/explore/views/shop_screen.dart';
import 'package:flutter/material.dart';

class ExploreNavigator extends StatelessWidget {
  const ExploreNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (routeSettings){
        return MaterialPageRoute(
          builder: (context) => const ExploreScreen(),
        );
      },
    );
  }
}
