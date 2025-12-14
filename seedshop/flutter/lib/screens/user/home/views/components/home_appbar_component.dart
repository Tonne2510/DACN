
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      flexibleSpace: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: "Tìm kiếm sản phẩm...",
                contentPadding: EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 20.0),
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                suffixIcon: Icon(Icons.search, color: Color(0xFF4A7C2C)),
              ),
            )
          ],
        ),
      ),
      backgroundColor: Color(0xFF4A7C2C),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}