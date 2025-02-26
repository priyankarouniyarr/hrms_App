import 'package:flutter/material.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/custom_appbar.dart';
import 'package:hrms_app/screen/profile/profilemenuitem.dart';
import 'package:hrms_app/screen/profile/subcategories/documents.dart';
import 'package:hrms_app/screen/profile/subcategories/emergency_conatct.dart';
import 'package:hrms_app/screen/profile/subcategories/insurance.details.dart';
import 'package:hrms_app/screen/profile/subcategories/employement_contracts.dart';
import 'package:hrms_app/screen/profile/subcategories/personal_information%20.dart';
import 'package:hrms_app/screen/profile/subcategories/work%20and%20shift%20information.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: CustomAppBar(title: "My Profile"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color.fromARGB(255, 205, 201, 201),
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              "Priyanka", //user
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text("work@mail.com", //email
                style: TextStyle(
                    fontSize: 16, color: primaryTextColor.withOpacity(0.7))),
            Text("02134343", //phone number
                style: TextStyle(
                    fontSize: 16, color: primaryTextColor.withOpacity(0.7))),
            const SizedBox(height: 20),

            // Profile Menu List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                color: backgroundColor,
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    ProfileMenuItem(
                      icon: Icons.person,
                      title: "Personal Information",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PersonalInformationScreen()),
                        );
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(),
                    ), // Horizontal Line
                    ProfileMenuItem(
                      icon: Icons.contact_emergency,
                      title: "Emergency Contact",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmergencyContact()),
                        );
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(),
                    ),
                    ProfileMenuItem(
                      icon: Icons.business_center,
                      title: "Work and Shift Information",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Workshiftinformation()),
                        );
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(),
                    ),
                    ProfileMenuItem(
                      icon: Icons.file_copy_sharp,
                      title: "Documents",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Documents()),
                        );
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(),
                    ),
                    ProfileMenuItem(
                      icon: Icons.verified_user,
                      title: "Insurance Details",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InsuranceDetails(),
                            ));
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(),
                    ),
                    ProfileMenuItem(
                      icon: Icons.handshake,
                      title: "Employment Contracts",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EmployementContracts()));
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Logout Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Card(
                color: backgroundColor,
                elevation: 3,
                child: InkWell(
                  onTap: () {
                    print("Logout Pressed");
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: accentColor),
                        SizedBox(width: 8),
                        Text(
                          "Logout",
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
