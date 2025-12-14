
import 'dart:convert';

import 'package:ecommerce_sem4/components/controls/input_component.dart';
import 'package:ecommerce_sem4/models/user/auth/request/register_request.dart';
import 'package:ecommerce_sem4/route/user/router_constants.dart';
import 'package:ecommerce_sem4/screens/user/auth/views/login_screen.dart';
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class SignUpForm extends StatefulWidget {

  const SignUpForm({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm>{
  String uri = registerUri;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController =TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập email';
    }
    return null;
  }
  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    final passwordRegExp = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

    if (!passwordRegExp.hasMatch(value)) {
      return 'Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt';
    }
    return null;
  }
  String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập tên đăng nhập';
    }
    return null;
  }

  Future<void>  _submitForm(BuildContext context) async{
    String email = _emailController.text;
    String password = _passwordController.text;
    String username = _usernameController.text;
    Map<String, Object?> request = RegisterRequest(email, password,username).toMap();
    Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    };

    if(_formKey.currentState!.validate()){
      try {
        http.Response response = await http.post(
          Uri.parse(uri),
          headers: headers,
          body: jsonEncode(request),
        );

        // Check if the response is valid JSON
        if (response.statusCode == 200) {
          try {
            var data = jsonDecode(utf8.decode(response.bodyBytes));

            // Check if registration was successful
            if (data['success'] == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Đăng ký thành công")),
              );

              Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen())
                );
            } else {
              // Handle error messages from API
              String errorMessage = "Đăng ký thất bại";
              if (data['errors'] != null) {
                String errors = data['errors'].join(', ');
                if (errors.contains('Email already Registered')) {
                  errorMessage = "Email đã được đăng ký";
                } else if (errors.contains('Password does not meet requirements')) {
                  errorMessage = "Password không hợp lệ";
                }
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(errorMessage)),
              );
            }
          } catch (e) {
            print("Response: ${response.body}");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Lỗi xử lý dữ liệu")),
            );
          }
        } else {
          // Handle HTTP error status codes
          try {
            var data = jsonDecode(utf8.decode(response.bodyBytes));
            String errorMessage = "Đăng ký thất bại";
            if (data['errors'] != null) {
              String errors = data['errors'].join(', ');
              if (errors.contains('Email already Registered')) {
                errorMessage = "Email đã được đăng ký";
              } else if (errors.contains('Password does not meet requirements')) {
                errorMessage = "Password không hợp lệ";
              }
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMessage)),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Lỗi từ máy chủ")),
            );
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lỗi kết nối mạng")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Form(
      key: _formKey,
      child: Column(
        children: [
           InputComponent(text: "Tên đăng nhập", placeholder: "Nhập tên đăng nhập", controller:_usernameController , validator: usernameValidator,),
          const SizedBox(height: 15,),
           InputComponent(text: "Email", placeholder: "Nhập email của bạn", controller: _emailController, validator: emailValidator,),
          const SizedBox(height: 15.0,),
           InputComponent(text: "Mật khẩu", placeholder: "Nhập mật khẩu", controller: _passwordController, validator: passwordValidator, obscureText: true,),

          const SizedBox(height: 30.0,),
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4A7C2C),
                  Color(0xFF6BA83E),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius:  BorderRadius.circular(8)
                  ),
                ),
                onPressed: (){_submitForm(context);},
                child: const Text('Đăng Ký',style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),)
            ),
          ),
          const SizedBox(height: 25,),
          RichText(
            text: TextSpan(
                children: <TextSpan>[
                 const TextSpan(
                    text: 'Đã có tài khoản? ',
                    style: TextStyle(
                      fontSize: 14,
                      color: greyColor,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  TextSpan(
                      text: 'Đăng nhập ngay',
                      style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4A7C2C),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600
                      ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Navigate to a new screen
                        Navigator.pushNamed(
                            context,
                            logInScreenRoute
                        );
                      },
                  ),
                ]
            ),
          ),
        ],
      ),
    );
  }
}