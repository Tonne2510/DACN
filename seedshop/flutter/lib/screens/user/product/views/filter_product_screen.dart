
import 'package:ecommerce_sem4/models/user/category/request/search_request.dart';
import 'package:ecommerce_sem4/models/user/category/response/category_model.dart';
import 'package:ecommerce_sem4/route/user/router_constants.dart';
import 'package:ecommerce_sem4/screens/user/explore/views/search_screen.dart';
import 'package:ecommerce_sem4/screens/user/product/views/category_product_screen.dart';
import 'package:ecommerce_sem4/screens/user/product/views/components/list_title_radio_component.dart';
import 'package:ecommerce_sem4/services/user/auth/auth_service.dart';
import 'package:ecommerce_sem4/services/user/category/category_service.dart';
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterProductScreen extends StatefulWidget {
  final bool isCheck;
  final bool? isScreen;
  const FilterProductScreen({super.key, required this.isCheck, this.isScreen});

  @override
  State<StatefulWidget> createState() => _FilterProduct();
}
class _FilterProduct extends State<FilterProductScreen>{
  final searchApiCategory= categorySearchUri;
  String? accessToken = "";
  List<Category> categories=[];
  Map<String, String> headers = <String, String>{};
  String? selectedValue;
  String? categoryName;

  @override
  void initState(){
    super.initState();
    AuthService().checkLoginStatus(context);
    _loadCategories();
  }

  void _applyFilter(BuildContext context, String selectedCategoryId) {
   Navigator.pop(context, selectedCategoryId);
   }

  void _applyFilterForSecondScreen() {
    if (selectedValue != null) {
        Navigator.push(
        context,
        MaterialPageRoute(
        builder: (context) =>
        CategoryProductScreen(categoryId: selectedValue!, categoryName: categoryName!,isCheckScreen: widget.isCheck,))
     );
    }
  }

  Future<void> _loadCategories() async {
    final pref = await SharedPreferences.getInstance();
    accessToken = pref.getString("accessToken");

    headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };

    Map<String, Object?> request = CategorySearchRequest(
        pageNumber: 1,
        pageSize: 100000,
        sortBy: "Id",
        sortDir: "desc")
        .toMap();

    final data = await CategoryService().search(searchApiCategory, headers, request);

    setState(() {
      categories = data!.data;
    });
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
              backgroundColor: Color(0xFF4A7C2C),
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
                        const  Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child:  Text(
                              "Danh Mục",
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
                              categoryName = "Tất cả";
                              selectedValue = value;
                            });
                          },
                        ),
                          ...categories.map((category) {
                            return TitleRadion(
                              name: category.categoryName,
                              value: category.id.toString(),
                              selectedValue: selectedValue,
                              onChanged: (value){
                                setState(() {
                                  categoryName = category.categoryName;
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
                            if(selectedValue==null){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content:  Text('Vui lòng chọn danh mục trước khi áp dụng bộ lọc.')),
                              );
                            }
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