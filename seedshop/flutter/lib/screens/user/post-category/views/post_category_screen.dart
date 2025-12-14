

import 'package:ecommerce_sem4/models/user/post-category/request/search_request.dart';
import 'package:ecommerce_sem4/models/user/post-category/response/post_category_model.dart';
import 'package:ecommerce_sem4/screens/user/layout/views/layout_screen.dart';
import 'package:ecommerce_sem4/screens/user/post-category/views/components/post_category_item_component.dart';
import 'package:ecommerce_sem4/services/user/auth/auth_service.dart';
import 'package:ecommerce_sem4/services/user/post-category/post_category_service.dart';
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostCategoryScreen extends StatefulWidget{
  const PostCategoryScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PostCategoryList();
}

class _PostCategoryList extends State<PostCategoryScreen>{
  final searchApiPostCategory= postCategorySearchUri;
  List<PostCategory> postCategories = [];
  Map<String, String> headers = <String, String>{};
  String? accessToken="";

  @override
  void initState() {
    super.initState();
    AuthService().checkLoginStatus(context);
    _loadPostCategories();
  }

  Future<void> _loadPostCategories() async {
    final pref = await SharedPreferences.getInstance();
    accessToken = pref.getString("accessToken");

    headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };

    Map<String, Object?> request = PostCategorySearchRequest(
        pageNumber: 1,
        pageSize: 10000000,
        sortBy: "Id",
        sortDir: "asc")
        .toMap();

    final data = await PostCategoryService().search(searchApiPostCategory, headers, request);

    setState(() {
      postCategories = data!.data;
    });
  }



  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(80.0),
            child:AppBar(
              flexibleSpace: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(12, 15, 12, 15),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 24,
                            ),
                            onPressed: () {
                              // Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          LayoutScreen()));
                            },
                            color: whiteColor,
                          ),
                        ],
                      ),
                      const Text(
                        "Danh Sách Bài Viết",
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: 23,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )
              ),
              backgroundColor: greenBgColor,
              automaticallyImplyLeading: false,
            ),
          ),
          body: Container(
            padding: const EdgeInsets.fromLTRB(12, 15, 12, 15),
            child: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                      itemCount: postCategories.length,
                      itemBuilder: (context, index) {
                        final postCategory = postCategories[index];
                        return PostCategoryItem(name: postCategory.postCategoryName, postCategoryId: postCategory.id,);
                      },
                    )
                )
              ],
            ),
          )
      ),
    );
  }
}