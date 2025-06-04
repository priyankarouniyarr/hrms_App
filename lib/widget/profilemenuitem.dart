import 'package:flutter/material.dart';
import 'package:hrms_app/constants/colors.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap; // Corrected to onTap

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap, // Use onTap here
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: lightColor,
            boxShadow: [
              BoxShadow(
                color: lightColor.withOpacity(0.5),
              ),
            ],
          ),
          child: Center(
            child: Icon(icon, color: primarySwatch[900], size: 18),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 19,
          color: primaryTextColor,
        ),
        onTap: onTap, // Correctly using onTap here
      ),
    );
  }
}
