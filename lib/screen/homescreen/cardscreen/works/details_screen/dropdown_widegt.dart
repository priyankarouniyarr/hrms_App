import 'package:flutter/material.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/leaves/dropdown_custom.dart';

Widget buildDropdown(String title, String? value, List<String> items,
    ValueChanged<String?> onChanged) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          color: primarySwatch,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(height: 5),
      CustomDropdown(
        value: value,
        items: items,
        hintText: "",
        onChanged: (val) => onChanged(val),
      ),
    ],
  );
}

Widget buildDropdownMap(
  String title,
  String? selectedValue,
  List<Map<String, dynamic>> items,
  ValueChanged<String?> onChanged,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          color: primarySwatch,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      SizedBox(height: 5),
      DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: primarySwatch, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: primarySwatch, width: 2),
          ),
          filled: true,
          fillColor: cardBackgroundColor,
        ),
        isExpanded: true,
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item["value"],
                  child: Text(item["label"]),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    ],
  );
}
