import 'package:ecommerce_sem4/screens/user/account/views/account_screen.dart';
import 'package:ecommerce_sem4/screens/user/auth/views/login_screen.dart';
import 'package:ecommerce_sem4/screens/user/auth/views/signup_screen.dart';
import 'package:ecommerce_sem4/screens/user/cart/views/cart_screen.dart';
import 'package:ecommerce_sem4/screens/user/category/views/category_screen.dart';
import 'package:ecommerce_sem4/screens/user/explore/views/search_screen.dart';
import 'package:ecommerce_sem4/screens/user/explore/views/shop_screen.dart';
import 'package:ecommerce_sem4/screens/user/favourite/views/favourite_screen.dart';
import 'package:ecommerce_sem4/screens/user/home/views/home_screen.dart';
import 'package:ecommerce_sem4/screens/user/layout/views/layout_screen.dart';
import 'package:ecommerce_sem4/screens/user/onboarding/views/onboarding_screen.dart';
import 'package:ecommerce_sem4/screens/user/product/views/category_product_screen.dart';
import 'package:ecommerce_sem4/screens/user/product/views/filter_product_screen.dart';
import 'package:ecommerce_sem4/screens/user/product/views/product_detail_screen.dart';
import 'package:ecommerce_sem4/screens/user/splash_screen.dart';
import 'package:flutter/material.dart';
import 'router_constants.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case onboardingScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const OnBoardingScreen(),
      );
    case logInScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case signUpScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      );
    case homScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const LayoutScreen(),
      );
    case categoryScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const CategoryScreen(),
      );
    // case categoryProductRoute:
    //   return MaterialPageRoute(
    //     builder:  (context) => const CategoryProductScreen(),
    //   );
    case filterProductRoute:
      return MaterialPageRoute(
        builder: (context) => const FilterProductScreen(isCheck: false,),
      );
    case exploreScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const ExploreScreen(),
      );
    case searchProductRoute:
      return MaterialPageRoute(
        builder: (context) => const SearchScreen()
      );
    // case productDetailRoute:
    //   return MaterialPageRoute(
    //     builder: (context) => const ProductDetailScreen()
    //   );
    case cartRoute:
      return MaterialPageRoute(
        builder: (context) => const CartScreen()
      );
    case favouriteRoute:
      return MaterialPageRoute(
        builder: (context) => const FavouriteScreen()
      );
    case accountRoute:
      return MaterialPageRoute(
        builder: (context) => const AccountScreen()
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const SplashScreen(),
      );
  }
}