
import 'package:ecommerce_sem4/models/user/cart/request/add_cart_request.dart';
import 'package:ecommerce_sem4/models/user/post/response/post_detail_response.dart';
import 'package:ecommerce_sem4/models/user/post/response/post_model.dart';
import 'package:ecommerce_sem4/models/user/product/response/product_model.dart';
import 'package:ecommerce_sem4/services/user/auth/auth_service.dart';
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../services/user/post/post_service.dart';

class PostDetailScreen extends StatefulWidget{
  final Post? post;

  const PostDetailScreen({super.key, required this.post});

  @override
  State<StatefulWidget> createState() => _PostDetail();
}

class _PostDetail extends State<PostDetailScreen>{
  final TextEditingController _searchController = TextEditingController();
  final postDetailUriapi = postDetailUri;
  PostDetailResponse? comments1 = null;
  String? accessToken = "";
  Map<String, String> headers = <String, String>{};

  final imageUrl = "http://10.0.2.2:5069/images/";


  Future<void> _loadPost() async{
    final pref = await SharedPreferences.getInstance();
    accessToken = pref.getString("accessToken");

    headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };

    final data = await PostService().detail(postDetailUriapi+"/"+widget.post!.id.toString(), headers,);

    setState(() {
      comments1 = data;
    });

  }


  String stripHtml(String? htmlText) {
    if(htmlText!=null){
      String text = htmlText.replaceAll(RegExp(r'<[^>]*>'), ''); // Removes all HTML tags
      
      // Common HTML entities
      text = text.replaceAll('&nbsp;', ' ');
      text = text.replaceAll('&amp;', '&');
      text = text.replaceAll('&lt;', '<');
      text = text.replaceAll('&gt;', '>');
      text = text.replaceAll('&quot;', '"');
      text = text.replaceAll('&#39;', "'");
      text = text.replaceAll('&apos;', "'");
      
      // Vietnamese accented characters
      text = text.replaceAll('&aacute;', 'á');
      text = text.replaceAll('&agrave;', 'à');
      text = text.replaceAll('&atilde;', 'ã');
      text = text.replaceAll('&acirc;', 'â');
      text = text.replaceAll('&eacute;', 'é');
      text = text.replaceAll('&egrave;', 'è');
      text = text.replaceAll('&etilde;', 'ẽ');
      text = text.replaceAll('&ecirc;', 'ê');
      text = text.replaceAll('&iacute;', 'í');
      text = text.replaceAll('&igrave;', 'ì');
      text = text.replaceAll('&itilde;', 'ĩ');
      text = text.replaceAll('&oacute;', 'ó');
      text = text.replaceAll('&ograve;', 'ò');
      text = text.replaceAll('&otilde;', 'õ');
      text = text.replaceAll('&ocirc;', 'ô');
      text = text.replaceAll('&uacute;', 'ú');
      text = text.replaceAll('&ugrave;', 'ù');
      text = text.replaceAll('&utilde;', 'ũ');
      text = text.replaceAll('&yacute;', 'ý');
      text = text.replaceAll('&ygrave;', 'ỳ');
      text = text.replaceAll('&ytilde;', 'ỹ');
      
      // Uppercase Vietnamese
      text = text.replaceAll('&Aacute;', 'Á');
      text = text.replaceAll('&Agrave;', 'À');
      text = text.replaceAll('&Atilde;', 'Ã');
      text = text.replaceAll('&Acirc;', 'Â');
      text = text.replaceAll('&Eacute;', 'É');
      text = text.replaceAll('&Egrave;', 'È');
      text = text.replaceAll('&Etilde;', 'Ẽ');
      text = text.replaceAll('&Ecirc;', 'Ê');
      text = text.replaceAll('&Iacute;', 'Í');
      text = text.replaceAll('&Igrave;', 'Ì');
      text = text.replaceAll('&Itilde;', 'Ĩ');
      text = text.replaceAll('&Oacute;', 'Ó');
      text = text.replaceAll('&Ograve;', 'Ò');
      text = text.replaceAll('&Otilde;', 'Õ');
      text = text.replaceAll('&Ocirc;', 'Ô');
      text = text.replaceAll('&Uacute;', 'Ú');
      text = text.replaceAll('&Ugrave;', 'Ù');
      text = text.replaceAll('&Utilde;', 'Ũ');
      text = text.replaceAll('&Yacute;', 'Ý');
      
      // Decode numeric entities like &#225; (á)
      text = text.replaceAllMapped(RegExp(r'&#(\d+);'), (match) {
        try {
          return String.fromCharCode(int.parse(match.group(1)!));
        } catch (e) {
          return match.group(0)!;
        }
      });
      
      // Decode hex entities like &#xE1; (á)
      text = text.replaceAllMapped(RegExp(r'&#[xX]([0-9A-Fa-f]+);'), (match) {
        try {
          return String.fromCharCode(int.parse(match.group(1)!, radix: 16));
        } catch (e) {
          return match.group(0)!;
        }
      });
      
      return text.trim();
    }else {
      return "";
    }
  }

  @override
  void initState(){
    super.initState();
    AuthService().checkLoginStatus(context);
    _loadPost();
  }

  //to release any resources as input
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: greenBgColor,
            automaticallyImplyLeading: true,
            foregroundColor: whiteColor,
            title: const Text("Chi Tiết Bài Viết"),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                    Container(
                    alignment: Alignment.topCenter,
                    width: double.infinity,
                    height: 300,
                    child: Image.network(
                      '$imageUrl${widget.post?.image}',
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                        // Return a placeholder image if there's an error loading the network image
                        return Image.asset("assets/user/images/slide1.jpg", fit: BoxFit.cover);
                      },
                    ),
                  ),

                    Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.post!.title,
                                          style: const TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                              ],
                            ),
                            const Divider(
                              color: Colors.grey,     // Set the color to grey
                              thickness: 1,           // Adjust thickness as desired
                              indent: 16,             // Optional: add spacing on the left side
                              endIndent: 16,          // Optional: add spacing on the right side
                            ),

                            Padding(
                                padding: const EdgeInsets.fromLTRB(8, 10, 0, 0),
                                child:  Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                   const Text(
                                      "Mô Tả",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                   const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                        stripHtml(widget.post!.description)
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      "Nội Dung",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                        stripHtml(widget.post!.content)
                                    ),

                                  ],
                                )
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //BottomButton(buttonName: "Add to cart",price: widget.product!.price,quantity: _quantity,event: _addToCart,)
            ],
          )
      ),
    );
  }
}