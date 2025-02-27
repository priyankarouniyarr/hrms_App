import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/providers/check_in_provider.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class CheckInScreen extends StatelessWidget {
  Future<void> _getLiveLocation(BuildContext context) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enable location services')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permission denied')),
        );
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print('Live Location: ${position.latitude}, ${position.longitude}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Live Location: ${position.latitude}, ${position.longitude}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckInProvider>(
      builder: (context, checkInProvider, child) {
        // Show success popup if there's a success message
        if (checkInProvider.successMessage != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Success"),
                  content: Text(checkInProvider.successMessage!),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("OK"),
                    ),
                  ],
                );
              },
            );
          });
        }

        return Scaffold(
          backgroundColor: cardBackgroundColor,
          appBar: CustomAppBarProfile(title: "Check In"),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            print("Punch Post tapped");
                            checkInProvider.punchPost();
                          },
                          child: IconTextContainer(
                            icon: Icons.fingerprint,
                            text: 'Punch Post',
                            iconColor: Colors.blue,
                            containerColor: Colors.blue[50]!,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            print("Shared Live Location tapped");
                          },
                          child: IconTextContainer(
                            icon: Icons.my_location_outlined,
                            text: 'Shared Live Location',
                            iconColor: Colors.green,
                            containerColor: Colors.green[50]!,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class IconTextContainer extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final Color containerColor;

  const IconTextContainer({
    Key? key,
    required this.icon,
    required this.text,
    this.iconColor = Colors.black,
    this.containerColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 40),
            SizedBox(height: 8),
            Text(
              text,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
