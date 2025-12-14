import 'dart:convert';
import 'dart:io';
import 'package:ecommerce_sem4/models/user/account/response/account_model.dart';
import 'package:ecommerce_sem4/services/user/account/account_service.dart';
import 'package:ecommerce_sem4/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailsModal extends StatefulWidget {
  const UserDetailsModal({Key? key}) : super(key: key);

  @override
  _UserDetailsModalState createState() => _UserDetailsModalState();
}

class _UserDetailsModalState extends State<UserDetailsModal> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String? _gender = 'Male'; // Default gender
  XFile? _avatar; // Avatar image
  final apiGetDetailAccount = getByIdAccountUri;
  String? accessToken = "";
  String? userId = "";
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false; // Loading state for API requests
  Map<String, String> headers = <String, String>{};
  Account? account;

  // Function to fetch user details from API
  Future<void> _fetchUserDetails() async {
    setState(() {
      _isLoading = true;
    });
    final pref = await SharedPreferences.getInstance();
    accessToken = pref.getString("accessToken");
    userId = pref.getString("id");

    headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $accessToken',
    };
    final response = await AccountService().detail(apiGetDetailAccount+"/"+userId.toString(), headers);

    if (response!=null) {
      account = response;

      print(account);

      setState(() {
        _usernameController.text = account?.userName! ?? "";
        _phoneController.text = account?.phoneNumber ?? ""; // Handle null case
        _addressController.text = account?.address ?? "";
        _gender = account?.gender.toString()?? 'Male'; // Provide a default value if null
      });

      print(_gender);
    }


    setState(() {
      _isLoading = false;
    });
  }

  // Function to pick an avatar image
  Future<void> _pickAvatar() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _avatar = image;
    });
  }

  // Submit the form and save the data
  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });



      // Prepare the data to submit
      final updatedUserDetails = {
        'Username': _usernameController.text,
        'Phone': _phoneController.text,
        'Address': _addressController.text,
        'Gender': _gender=='Male'?'1':'0',

        // Add avatar data if needed
      };
      print(updatedUserDetails);

      // var request = http.MultipartRequest('PUT', Uri.parse(updateAccountUri+"/"+userId.toString()));

      // Attach text fields
      // request.fields['Username'] = _usernameController.text;
      // request.fields['Email'] = account!.email!;
      // request.fields['Password'] = "123";
      // request.fields['Address'] = _addressController.text;
      // request.fields['Gender'] = _gender=='Male'?'1':'0';
      // request.fields['Role'] = account!.roleName!;
      // request.fields['Phone'] = _phoneController.text;


      // Call API to submit the updated data
      final response = await AccountService().update(updateAccountUri+"/"+userId.toString(), headers, updatedUserDetails);

      // final response = await request.send();

      print(response);

      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lưu thông tin thành công!')),
        );
        Navigator.pop(context); // Close the modal
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lưu thông tin thất bại')),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch user details when the modal is opened
    _fetchUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar section
            // GestureDetector(
            //   onTap: _pickAvatar,
            //   child: CircleAvatar(
            //     radius: 50,
            //     backgroundColor: Colors.grey[300],
            //     backgroundImage: _avatar != null
            //         ? FileImage(File(_avatar!.path)) as ImageProvider
            //         : null,
            //     child: _avatar == null
            //         ? const Icon(
            //       Icons.camera_alt,
            //       size: 30,
            //       color: Colors.white,
            //     )
            //         : null,
            //   ),
            // ),
            const SizedBox(height: 16),
            // Username field
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Tên đăng nhập'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            // Phone field
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Số điện thoại'),
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return 'Please enter your phone number';
              //   }
              //   return null;
              // },
            ),
            const SizedBox(height: 8),
            // Address field
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Địa chỉ'),
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return 'Please enter your address';
              //   }
              //   return null;
              // },
            ),
            const SizedBox(height: 8),
            // Gender selection
            DropdownButtonFormField<String>(
              value: _gender,
              decoration: const InputDecoration(labelText: 'Giới tính'),
              items: ['Male', 'Female',]
                  .map((gender) => DropdownMenuItem<String>(
                value: gender,
                child: Text(gender),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _gender = value!;
                });
              },
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return 'Please select your gender';
              //   }
              //   return null;
              // },
            ),
            const SizedBox(height: 16),
            // Submit button
           Row(
             children: [
               ElevatedButton(
                 onPressed: () => _submitForm(context),
                 child: const Text('Cập nhật'),
               ),
               ElevatedButton(
                 style: ElevatedButton.styleFrom(
                   foregroundColor: Colors.white, // Text color
                   backgroundColor: Colors.blue,  // Button background color
                 ),
                 onPressed: () => Navigator.pop(context), // Add context to Navigator.pop
                 child: const Text('Close'),
               ),


             ],
           )
          ],
        ),
      ),
    );
  }
}
