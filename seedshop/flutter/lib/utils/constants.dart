import 'dart:ui';

import 'package:flutter/material.dart';

// Color
const Color greyColor = Color(0xFF7C7C7C);
const Color greenBgColor = Color(0xFF4A7C2C);
const Color secondaryGreen = Color(0xFF6BA83E);
const Color darkGreen = Color(0xFF2D5016);
const Color lightGreenBg = Color(0xFFF0F8EA);
const Color lightGreenBg2 = Color(0xFFE8F5E0);
const Color whiteColor = Colors.white;
const Color blackColor = Colors.black;
const Color textGrey = Color(0xFF666666);
const Color borderColor = Color(0xFFE0E0E0);
const Color dashedLine = Color(0xFF8E8E8E);
const Color borderInput = Color(0xFFE0E0E0);
const Color f4f4Color = Color(0xFFF4F4F4);
const Color filterProductColor = Color(0xFFF2F3F2);
const Color errorColor = Color(0xFFFF4444);
const Color linkColor = Color(0xFF4A7C2C);

// uri
const String apiUri = "http://10.0.2.2:5069/api";
const String loginUri = "$apiUri/auth/login";
const String registerUri = "$apiUri/auth/register";
// category
const String categorySearchUri = "$apiUri/category/search";
const String categoryDetailUri = "$apiUri/category";
// product
const String productSearchUri = "$apiUri/product/search";
const String productDetailUri = "$apiUri/product";
// cart
const String cartAddUri = "$apiUri/cart/add";
const String getCartUri = "$apiUri/cart/search";
const String updateQuantityUri = "$apiUri/cart/update";
const String getCartByUserIdUri = "$apiUri/cart/getCart";
const String removeCartUri = "$apiUri/cart";

// post-category
const String postCategorySearchUri = "$apiUri/postcategory/search";
const String postCategoryDetailUri = "$apiUri/postcategory";
//post
const String postSearchUri = "$apiUri/post/search";
const String postDetailUri = "$apiUri/post";
const String postCommentUri = "$apiUri/comment";

//order
const String orderUri = "$apiUri/order/create";
const String userOrderUri = "$apiUri/order/user-orders";

//account
const String getByIdAccountUri = "$apiUri/account";
const String updateAccountUri = "$apiUri/account/user";



