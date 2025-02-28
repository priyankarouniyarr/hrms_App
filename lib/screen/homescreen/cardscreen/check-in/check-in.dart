import 'package:flutter/material.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/check-in/subcategories/punchpost.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class CheckInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarProfile(title: "Check In Details"),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Equal spacing
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PunchInScreen()),
                  );
                },
                child: IconTextContainer(
                  icon: Icons.fingerprint,
                  text: 'Punch Post',
                  iconColor: Colors.blue,
                  containerColor: Colors.blue[50]!,
                ),
              ),
            ),
            SizedBox(width: 10), // Space between buttons
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShareLiveLocationScreen()),
                  );
                },
                child: IconTextContainer(
                  icon: Icons.location_on,
                  text: 'Share Live Location',
                  iconColor: Colors.green,
                  containerColor: Colors.green[50]!,
                ),
              ),
            ),
          ],
        ),
      ),
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
      height: 120,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 40),
          SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// Dummy Share Live Location Screen
class ShareLiveLocationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Location")),
      body: Center(child: Text("Live Location Screen Coming Soon!")),
    );
  }
}
