
import 'package:ecommerce_sem4/models/user/post/request/search_request.dart';
import 'package:ecommerce_sem4/models/user/post/response/post_model.dart';
import 'package:ecommerce_sem4/screens/user/category/views/category_screen.dart';
import 'package:ecommerce_sem4/screens/user/explore/views/shop_screen.dart';
import 'package:ecommerce_sem4/screens/user/home/views/components/card_product_component.dart';
import 'package:ecommerce_sem4/screens/user/post-category/views/post_category_screen.dart';
import 'package:ecommerce_sem4/screens/user/post/views/components/post_item_component.dart';
import 'package:ecommerce_sem4/screens/user/post/views/filter_post_screen.dart';
import 'package:ecommerce_sem4/services/user/auth/auth_service.dart';
import 'package:ecommerce_sem4/services/user/post/post_service.dart';
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostCategoryPostScreen extends StatefulWidget{
  final String postCategoryId;
  final String postCategoryName;
  bool? isCheckScreen;
  final String? keyword;
  PostCategoryPostScreen({super.key, required this.postCategoryId, required this.postCategoryName, this.isCheckScreen, this.keyword
  });

  @override
  State<StatefulWidget> createState() => _PostCategoryPost();
}

class _PostCategoryPost extends State<PostCategoryPostScreen>{
  final searchApiPost = postSearchUri;
  List<Post> posts = [];
  String? accessToken = "";
  Map<String, String> headers = <String, String>{};
  final formatCurrency = NumberFormat.currency(symbol: "₫", decimalDigits: 0);
  final imageUrl = "http://10.0.2.2:5069/images/";

  @override
  void initState(){
    super.initState();
    AuthService().checkLoginStatus(context);
    _loadPost();
  }

  Future<void> _loadPost() async{
    final pref = await SharedPreferences.getInstance();
    accessToken = pref.getString("accessToken");

    headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };

    Map<String, Object?> request = PostSearchRequest(
      pageNumber: 1,
      pageSize: 10000,
      sortBy: "Id",
      sortDir: "asc",
      postCategoryId: widget.postCategoryId,
      keyword: widget.keyword
    ).toMap();

    final data = await PostService().search(searchApiPost, headers, request);

    setState(() {
      posts = data!.data;
    });
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:  Scaffold(
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
                                    (widget.isCheckScreen!)?const ExploreScreen(): const PostCategoryScreen()));
                          },
                          color: whiteColor,
                        ),
                      ],
                    ),
                     Text(
                      widget.postCategoryName,
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 23,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.filter_list,
                            size: 35,
                          ),
                          onPressed: () {
                            // Navigator.pushNamed(context, filterProductRoute);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        FilterPostScreen(isCheck: widget.isCheckScreen!,isScreen: false,)));
                          },
                          color: whiteColor,
                        ),
                      ],
                    )
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
                child:
                ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];

                    return PostItem(image: post.image,name: post.title, description: post.description,post: post,);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}