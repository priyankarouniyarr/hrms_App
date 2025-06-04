import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'subcategories/emergency_conatct.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/screen/hospitalcode.dart';
import 'package:hrms_app/widget/custom_appbar.dart';
import 'package:hrms_app/widget/profilemenuitem.dart';
import 'package:hrms_app/screen/profile/workingexperience.dart';
import 'package:hrms_app/screen/profile/subcategories/traning.dart';
import 'package:hrms_app/screen/profile/subcategories/documents.dart';
import 'package:hrms_app/providers/profile_providers/profile_provider.dart';
import 'package:hrms_app/screen/profile/subcategories/insurance.details.dart';
import 'package:hrms_app/screen/profile/subcategories/employement_contracts.dart';
import 'package:hrms_app/screen/profile/subcategories/personal_information%20.dart';
import 'package:hrms_app/screen/profile/subcategories/work%20and%20shift%20information.dart';
import 'package:hrms_app/screen/profile/subcategories/qualifications%20and%20experiences.dart';
import 'package:hrms_app/providers/login_screen_provider/auth_provider.dart'; // Import the AuthProvider

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await Provider.of<EmployeeProvider>(context, listen: false)
          .fetchEmployeeDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    final employeeProvider = Provider.of<EmployeeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (employeeProvider.isLoading) {
      return Scaffold(
        appBar: CustomAppBar(title: "My Profile"),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: CustomAppBar(title: "My Profile"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Color.fromARGB(255, 226, 232, 251),
              child: employeeProvider.imagepath.isNotEmpty == true
                  ? ClipOval(
                      child: Image.network(
                        "http://45.117.153.90:5001/uploads/users/${employeeProvider.imagepath}",
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.person,
                              size: 40,
                              color: const Color.fromARGB(255, 8, 96, 168));
                        },
                      ),
                    )
                  : Icon(Icons.person, size: 40),
            ),

            const SizedBox(height: 10),
            Text(
              employeeProvider.fullname,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              employeeProvider.devnagariName,
              style: TextStyle(
                  fontSize: 25,
                  color: primaryTextColor.withOpacity(0.7),
                  fontWeight: FontWeight.bold),
            ),
            // Profile Menu List
            SizedBox(
              height: 20,
            ),
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
                    ),
                    ProfileMenuItem(
                      icon: Icons.cast_for_education_rounded,
                      title: "Qualifications and Experience",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QualificationExpericence()),
                        );
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(),
                    ),
                    ProfileMenuItem(
                      icon: Icons.model_training_rounded,
                      title: "Tranings and Certifications",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Training()),
                        );
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(),
                    ),
                    ProfileMenuItem(
                      icon: Icons.work_outline,
                      title: "Working Experience",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WorkingExperience()),
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
                  onTap: () async {
                    await authProvider.logout(
                      context,
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HospitalCodeScreen(),
                      ),
                    );
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
