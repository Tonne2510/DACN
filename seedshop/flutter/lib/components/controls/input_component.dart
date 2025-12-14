
import 'package:flutter/material.dart';

class InputComponent extends StatelessWidget{
  final String text;
  final String placeholder;
  final TextEditingController controller;
  final FormFieldValidator<String>?  validator;
  final bool obscureText;
  const InputComponent({super.key, required this.text, required this.placeholder, required this.controller, required this.validator, this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: "Poppins",
              color: Color(0xFF333333),
              fontSize: 15
          ),
        ),
        const SizedBox(height: 8,),
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          decoration:  InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
            focusedBorder:const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF4A7C2C), width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFFF4444), width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFFF4444), width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: placeholder,
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
          ),
        )
      ],
    );
  }
}