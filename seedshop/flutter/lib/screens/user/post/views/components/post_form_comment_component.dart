import 'package:ecommerce_sem4/services/user/auth/auth_service.dart';
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce_sem4/services/user/comment/comment_service.dart';
import '../../../../../models/user/comment/post/request/create_request.dart';

class FormCommentPost extends StatefulWidget {
  final String postId;
  const FormCommentPost(
      {super.key,
        required this.postId
      });

  @override
  State<StatefulWidget> createState() => _FormCommentPost();
}

class _FormCommentPost extends State<FormCommentPost> {
  final TextEditingController _commentKeyword = TextEditingController();

  final searchApiComment = postCommentUri;
  String? accessToken = "";
  String? accountId = "";
  String commentValue = "";
  Map<String, String> headers = <String, String>{};

  final imageUrl = "http://10.0.2.2:5069/images/";

  @override
  void initState(){
    super.initState();
    AuthService().checkLoginStatus(context);
  }

  void _showAlertDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    Future<void> createComment() async{

      final pref = await SharedPreferences.getInstance();
      accessToken = pref.getString("accessToken");
      accountId = pref.getString("id");
      commentValue = _commentKeyword.text.trim();
      headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      };
      if(commentValue == null || commentValue=="" || commentValue.isEmpty){
        _showAlertDialog("Error", "Comment failed. Please try again.");
        return;
      }

      Map<String, Object?> request = CreatePostCommentRequest(
          content:commentValue,
          postId: widget.postId,
          accountId: accountId
      ).toMap();

      String? data = await CommentPostService().createComment(searchApiComment, headers, request);

      if (data != "") {
        _showAlertDialog("Success", "Comment successfully!");
        _commentKeyword.clear();
      } else {
        _showAlertDialog("Error", "Comment failed. Please try again.");
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            spreadRadius: 2, // Spread radius
            blurRadius: 10, // Blur radius
            offset: const Offset(4, 4), // Shadow position (x, y)
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50, // Fixed height
              child: TextFormField(
                controller: _commentKeyword,

                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "Write a comment...",
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),

                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: () {
              createComment();
            },
          ),
        ],
      ),
    );
  }
}
