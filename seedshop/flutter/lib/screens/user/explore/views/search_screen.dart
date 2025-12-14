import 'package:ecommerce_sem4/models/user/product/request/search_request.dart';
import 'package:ecommerce_sem4/models/user/product/response/product_model.dart';
import 'package:ecommerce_sem4/screens/user/home/views/components/card_product_component.dart';
import 'package:ecommerce_sem4/screens/user/product/views/filter_product_screen.dart';
import 'package:ecommerce_sem4/services/user/auth/auth_service.dart';
import 'package:ecommerce_sem4/services/user/product/product_service.dart';
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget{
  final String? keyword;
  final String? categoryId;
  const SearchScreen({super.key, this.keyword, this.categoryId});

  @override
  State<StatefulWidget> createState() =>_ShopComponent();
}

class _ShopComponent extends State<SearchScreen>{
  late final TextEditingController _searchController;
  String? accessToken = "";
  List<Product> products = [];
  Map<String, String> headers = <String, String>{};
  final searchApiProduct = productSearchUri;
  String? selectedCategory1 = "";
  final imageUrl = "http://10.0.2.2:5069/images/";

  @override
  void initState() {
    super.initState();
    AuthService().checkLoginStatus(context);
    _searchController = TextEditingController(text: widget.keyword ?? "");
    _searchProducts();
  }

  Future<void> _openFilterScreen() async {
    var selectedCategory = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const FilterProductScreen(
          isCheck: true,
          isScreen: true,
        ),
      ),
    );

    if (selectedCategory != null) {
      setState(() {
        selectedCategory1 = selectedCategory;
      });
      _searchProducts();
    }
  }

  Future<void> _searchProducts() async{
    final pref = await SharedPreferences.getInstance();
    accessToken = pref.getString("accessToken");

    headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };

    Map<String, Object?> request = ProductSearchRequest(
      pageNumber: 1,
      pageSize: 10000,
      keyword: _searchController.text,
      sortBy: "Id",
      sortDir: "desc",
      categoryId: selectedCategory1
    )
        .toMap();

    print(request);

    final data = await ProductService().search(searchApiProduct, headers, request);

    setState(() {
      products = data!.data;
    });
  }

  void _onSearch(){
    _searchProducts();
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100.0),
            child: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Color(0xFF4A7C2C),
              flexibleSpace:  Container(
                alignment: Alignment.center,
                // width: double.infinity,
                padding: const EdgeInsets.fromLTRB(10.0, 0,10.0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child:  TextFormField(
                          controller: _searchController,
                          decoration:  InputDecoration(
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
                            hintText: "Tìm kiếm sản phẩm...",
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 20.0),
                            hintStyle: TextStyle(color: greyColor, fontSize: 13),
                            suffixIcon:IconButton(
                              onPressed: _onSearch,
                              icon:  Icon(Icons.search, color: Color(0xFF4A7C2C)),
                            )

                          ),
                        )),
                        IconButton(
                          icon: const Icon(
                            Icons.filter_list,
                            size: 35,
                          ),
                          onPressed: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(builder: (context) => const FilterProductScreen()),
                            // );
                            _openFilterScreen();
                          },
                          color: whiteColor,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 15, 12, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 27.0,
                    runSpacing: 16.0,
                    children: products.map((e){
                      final formatCurrency = NumberFormat.currency(symbol: "₫", decimalDigits: 0);
                      return  Container(
                        width: 180,
                        child: CardProduct(image: '$imageUrl${e.image}' ,name: e.productName,price: formatCurrency.format(e.price), product: e,),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}