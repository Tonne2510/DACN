import 'package:ecommerce_sem4/screens/user/home/views/home_screen.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showSelectedLabels: true,
      backgroundColor: Colors.white,
      showUnselectedLabels: true,
      selectedItemColor: Color(0xFF4A7C2C),
      unselectedItemColor: Color(0xFF999999),
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      onTap: onItemTapped,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Khám phá',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopify),
          label: 'Giỏ hàng',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.favorite),
        //   label: 'Favourite',
        // ),
        BottomNavigationBarItem(
          icon: Icon(Icons.newspaper),
          label: 'Bài viết',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Tài khoản',
        ),
      ],
    );
  }
}
