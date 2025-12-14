import 'package:ecommerce_sem4/route/user/router_constants.dart';
import 'package:ecommerce_sem4/screens/user/account/views/account_order_screen.dart';
import 'package:ecommerce_sem4/screens/user/account/views/components/item_component.dart';
import 'package:ecommerce_sem4/screens/user/account/views/components/user_detail_modal_component.dart';
import 'package:ecommerce_sem4/screens/user/account/views/settings_screen.dart';
import 'package:ecommerce_sem4/screens/user/account/views/support_screen.dart';
import 'package:ecommerce_sem4/screens/user/plant_disease/plant_disease_screen.dart';
import 'package:ecommerce_sem4/services/user/auth/auth_service.dart';
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AccountScreen extends StatelessWidget{
  const AccountScreen({super.key});

  void logout(BuildContext context) {
    AuthService().logout();
    Navigator.pushReplacementNamed(context, logInScreenRoute);
  }

  void redirectToUserOrder(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
            const AccountOrderScreen()));
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
            const SettingsScreen()));
  }

  void _navigateToSupport(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
            const SupportScreen()));
  }

  void _navigateToPlantDisease(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
            const PlantDiseaseScreen()));
  }

  // Function to show the UserDetailsModal
  void _showUserDetailsModal(BuildContext context) {
    // showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true,
    //   builder: (BuildContext context) {
    //     return UserDetailsModal();
    //   },
    // );
    showDialog(
      context: context,
      barrierDismissible: false, // Optional: If you want to prevent dismissing by tapping outside the dialog
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero, // Remove padding around the dialog
          backgroundColor: Colors.white, // Optional: Remove background color if needed
          child: Container(
            width: double.infinity, // Ensure the child widget takes full width
            padding: EdgeInsets.all(0), // Remove any internal padding
            child: UserDetailsModal(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AuthService().checkLoginStatus(context);
    });
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: greenBgColor,
          title: const Text(
            "Tài Khoản",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Color(0xFFF4F4F4),
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
            child: Column(
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child:  Container(
                          alignment: Alignment.center,
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(65.0),
                              shape: BoxShape.rectangle,
                              color: Color(0xFFE8F5E0)
                          ),
                          child: Icon(
                            Icons.account_circle,
                            size: 130,
                            color: greenBgColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "Admin",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        "admin@gmail.com",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w300
                        ),

                      ),
                      SizedBox(height: 40,),
                    ],

                  ),
                ),
               const SizedBox(height: 30,),
                Container(
                  child: Column(
                    children: [
                      ItemComponent(text: "Đơn Hàng", iconButton: const Icon(Icons.shopping_bag), event: (){redirectToUserOrder(context);}),
                      const SizedBox(height: 15,),
                      ItemComponent(text: "Thông Tin Cá Nhân", iconButton: const Icon(Icons.account_circle), event: (){_showUserDetailsModal(context);}),
                      const SizedBox(height: 15,),
                      ItemComponent(text: "Cài Đặt", iconButton:const Icon(Icons.settings), event: (){_navigateToSettings(context);}),
                      const  SizedBox(height: 15,),
                      ItemComponent(text: "Chẩn Đoán Bệnh Cây", iconButton: const Icon(Icons.eco), event: (){_navigateToPlantDisease(context);}),
                      const  SizedBox(height: 15,),
                      ItemComponent(text: "Trợ Giúp & Hỗ Trợ", iconButton: const Icon(Icons.help_outline), event: (){_navigateToSupport(context);}),
                      const  SizedBox(height: 15,),
                      ItemComponent(text: "Đăng xuất", iconButton:const Icon(Icons.logout), event: ()=> logout(context)),
                    ],

                  ),
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}