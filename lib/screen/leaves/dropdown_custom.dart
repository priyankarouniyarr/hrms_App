import 'package:flutter/material.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

// Custom Dropdown for String values
class CustomDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String hintText;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<String>(
      isExpanded: true,
      value: value,
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.8),
                  ),
                ),
              ))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primarySwatch, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primarySwatch, width: 3),
        ),
        filled: true,
        fillColor: cardBackgroundColor,
      ),
      hint: Text(
        hintText,
        style: TextStyle(
          color: Colors.black.withOpacity(0.5),
        ),
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        offset: const Offset(0, 0),
      ),
      selectedItemBuilder: (BuildContext context) {
        return items.map((String item) {
          return Text(
            item,
            style: TextStyle(
              color: Colors.black.withOpacity(0.8),
              fontSize: 14,
            ),
          );
        }).toList();
      },
    );
  }
}

class CustomDropdown2 extends StatelessWidget {
  final int? value;
  final List<Map<String, dynamic>> items;
  final String hintText;
  final ValueChanged<int?> onChanged;

  final String? Function(int?)? validator;

  const CustomDropdown2({
    Key? key,
    required this.value,
    required this.items,
    required this.hintText,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField2<int>(
        isExpanded: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        value: value,
        barrierColor: Colors.black.withOpacity(0.5),
        items: items
            .map((item) => DropdownMenuItem<int>(
                  value: item["value"],
                  child: Text(
                    item["label"],
                    style: TextStyle(color: Colors.black.withOpacity(0.8)),
                  ),
                ))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: primarySwatch, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: primarySwatch, width: 3),
          ),
          filled: true,
          fillColor: cardBackgroundColor,
        ),
        hint: Text(
          hintText,
          style: TextStyle(color: Colors.black.withOpacity(0.5)),
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            color: cardBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          offset: const Offset(0, 0),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 16),
          overlayColor: MaterialStateProperty.all(
            primarySwatch.withOpacity(0.1),
          ),
        ));
  }
}

class CustomDropdownClearFilters extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String hintText;
  final ValueChanged<String?> onChanged;

  const CustomDropdownClearFilters({
    Key? key,
    required this.value,
    required this.items,
    required this.hintText,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    {
      final dropdownItems = items.toSet().toList();

      final validatedValue = dropdownItems.contains(value) ? value : null;

      return DropdownButtonFormField2<String>(
        isExpanded: true,
        value: validatedValue,
        items: dropdownItems
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 12,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: primarySwatch, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: primarySwatch, width: 3),
          ),
          filled: true,
          fillColor: cardBackgroundColor,
        ),
        hint: Text(
          hintText,
          style: TextStyle(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          decoration: BoxDecoration(
            color: cardBackgroundColor,
            borderRadius: BorderRadius.circular(8),
          ),
          offset: const Offset(0, 0),
        ),
        selectedItemBuilder: (BuildContext context) {
          return items.map((String item) {
            return Text(
              item,
              style: TextStyle(
                color: Colors.black.withOpacity(0.8),
                fontSize: 14,
              ),
            );
          }).toList();
        },
      );
    }
  }
}
