

import 'package:flutter/material.dart';

class ShopAppBar extends StatelessWidget implements PreferredSizeWidget{
  const ShopAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF4A7C2C),
      elevation: 0,
      centerTitle: true,
      title: const Text(
        "Tìm Sản Phẩm",
        style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600
        ),
      ),
      automaticallyImplyLeading: false,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}