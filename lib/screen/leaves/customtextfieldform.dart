import 'package:flutter/material.dart';
import 'package:hrms_app/constants/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;

  final String hintText;
  final bool readOnly;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.readOnly = false,
    this.onTap,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primarySwatch, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: primarySwatch, width: 2.0),
        ),
        suffixIcon: Icon(Icons.calendar_month, color: primarySwatch[900]),
      ),
    );
  }
}
