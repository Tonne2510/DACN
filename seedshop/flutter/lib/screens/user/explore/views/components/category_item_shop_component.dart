import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';

class ItemShopCategory extends StatelessWidget {
  final Color colorBg;
  final Color colorSideBorder;
  final String text;

  const ItemShopCategory(
      {super.key,
      required this.colorBg,
      required this.colorSideBorder,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width / 2) - 20,
      height: 210,
      child: Card(
          color: colorBg,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 110,
                height: 110,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.5),
                ),
                child: Icon(
                  Icons.eco,
                  size: 60,
                  color: Color(0xFF4A7C2C),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 8, left: 10, bottom: 10, right: 10),
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D5016),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
