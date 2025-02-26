import 'package:flutter/material.dart';
import 'package:hrms_app/constants/colors.dart';

class CustomAppBarProfile extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  const CustomAppBarProfile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: cardBackgroundColor,
      title: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: primarySwatch,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
