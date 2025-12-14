
import 'package:ecommerce_sem4/screens/user/post/views/post_category_post_screen.dart';
import 'package:flutter/material.dart';

class PostCategoryItem extends StatelessWidget{
  final String name;
  final int postCategoryId;
  const PostCategoryItem({super.key, required this.name, required this.postCategoryId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    PostCategoryPostScreen(postCategoryId: postCategoryId.toString(), postCategoryName: name,isCheckScreen: false,)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        height: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            boxShadow:[
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                spreadRadius: 1,
                blurRadius: 8, // Softness of the shadow
                offset: const Offset(4, 4), // Position of the shadow (x, y)
              ),
            ]
        ),
        child:  Text(
          name,
          style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}