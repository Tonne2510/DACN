
import 'package:ecommerce_sem4/models/user/post-category/request/search_request.dart';
import 'package:ecommerce_sem4/models/user/post-category/response/post_category_model.dart';
import 'package:ecommerce_sem4/screens/user/post/views/post_category_post_screen.dart';
import 'package:ecommerce_sem4/screens/user/product/views/components/list_title_radio_component.dart';
import 'package:ecommerce_sem4/services/user/auth/auth_service.dart';
import 'package:ecommerce_sem4/services/user/post-category/post_category_service.dart';
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterPostScreen extends StatefulWidget {
  final bool isCheck;
  final bool? isScreen;
  const FilterPostScreen({super.key, required this.isCheck, this.isScreen});

  @override
  State<StatefulWidget> createState() => _FilterPost();
}
class _FilterPost extends State<FilterPostScreen>{
  final searchApiPostCategory= postCategorySearchUri;
  String? accessToken = "";
  List<PostCategory> postCategories=[];
  Map<String, String> headers = <String, String>{};
  String? selectedValue;
  String? postCategoryName;
  String? keyword;
  TextEditingController _keywordController = TextEditingController();

  @override
  void initState(){
    super.initState();
    AuthService().checkLoginStatus(context);
    _loadPostCategories();
  }

  void _applyFilter(BuildContext context, String selectedCategoryId) {
   Navigator.pop(context, selectedCategoryId);
   }

  void _applyFilterForSecondScreen() {
    String? keywordValue = _keywordController.text.trim();

    // if (selectedValue != null) {
        Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) =>
        PostCategoryPostScreen(postCategoryId: selectedValue!, postCategoryName: postCategoryName!,isCheckScreen: widget.isCheck,keyword: keywordValue))
     );
    // }
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
        pageSize: 100000,
        sortBy: "Id",
        sortDir: "desc")
        .toMap();

    final data = await PostCategoryService().search(searchApiPostCategory, headers, request);

    setState(() {
      postCategories = data!.data;
    });
  }

  @override
  void dispose() {
    _keywordController.dispose(); // Dispose controller to avoid memory leaks
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return SafeArea(
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
                              Icons.close,
                              size: 28,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: whiteColor,
                          ),
                        ],
                      ),
                      const Text(
                        "Bộ Lọc",
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
          body: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.fromLTRB(12, 30, 12, 15),
                  decoration: const BoxDecoration(
                      color: filterProductColor,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(36.0), topRight: Radius.circular(36.0))
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          TextFormField(
                            controller: _keywordController,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: borderInput, width: 1.0),
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: borderInput, width: 1.0),
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Tìm kiếm bài viết...",
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 20.0), // Add padding
                              hintStyle: TextStyle(color: greyColor, fontSize: 13),
                              suffixIcon: Icon(Icons.search, color: Colors.grey),
                            ),
                          ),

                        const SizedBox(
                          height: 5,
                        ),
                        const  Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child:  Text(
                              "Danh Mục Bài Viết",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24
                              ),
                            ),
                          ),
                        TitleRadion(
                          name: "Tất cả",
                          value: "",
                          selectedValue: selectedValue,
                          onChanged: (value){
                            setState(() {
                              postCategoryName = "Tất cả";
                              selectedValue = value;
                            });
                          },
                        ),
                          ...postCategories.map((category) {
                            return TitleRadion(
                              name: category.postCategoryName,
                              value: category.id.toString(),
                              selectedValue: selectedValue,
                              onChanged: (value){
                                setState(() {
                                  postCategoryName = category.postCategoryName;
                                  selectedValue = value;
                                });
                              },
                            );
                          }).toList(),
                        ],
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius:  BorderRadius.circular(10)
                              ),
                              foregroundColor: f4f4Color,
                              backgroundColor: greenBgColor,
                              minimumSize: const Size.fromHeight(70)),
                          onPressed: () {
                            // if(selectedValue==null){
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(content:  Text('Please select a category before applying the filter.')),
                            //   );
                            // }
                            if(widget.isCheck && widget.isScreen!){
                              _applyFilter(context, selectedValue!);
                            }else {
                              _applyFilterForSecondScreen();
                            }

                          },
                          child: const Text('Áp Dụng Bộ Lọc',style: TextStyle(color: f4f4Color, fontSize: 16),)),
                    ],
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}