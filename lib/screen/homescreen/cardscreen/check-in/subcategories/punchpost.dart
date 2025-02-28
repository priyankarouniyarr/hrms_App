import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/providers/check_in_provider.dart';

class PunchInScreen extends StatefulWidget {
  @override
  _PunchInScreenState createState() => _PunchInScreenState();
}

class _PunchInScreenState extends State<PunchInScreen> {
  @override
  void initState() {
    super.initState();
    _fetchCheckInData();
  }

  void _fetchCheckInData() async {
    final checkInProvider =
        Provider.of<CheckInProvider>(context, listen: false);
    await checkInProvider.punchPost();
  }

  @override
  Widget build(BuildContext context) {
    final checkInProvider =
        Provider.of<CheckInProvider>(context); // Direct access

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      body: Center(
        child: checkInProvider.loading
            ? Center(child: CircularProgressIndicator())
            : checkInProvider.errorMessage.isNotEmpty
                ? _buildErrorCard(checkInProvider.errorMessage)
                : checkInProvider.successMessage != null
                    ? _buildSuccessCard(checkInProvider)
                    : Text("Fetching check-in details..."),
      ),
    );
  }

  Widget _buildSuccessCard(CheckInProvider checkInProvider) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 50),
            SizedBox(height: 10),
            Text(
              "✅ Check-in successful!",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
            SizedBox(height: 10),
            Text(
              "🕒 Time: ${DateFormat('hh:mm a').format(DateTime.now())}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primarySwatch,
              ),
            ),
            Text(
              "🏢 Branch ID: ${checkInProvider.branchId}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primarySwatch,
              ),
            ),
            Text(
              "📍 Latitude: ${checkInProvider.latitude}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primarySwatch,
              ),
            ),
            Text(
              "📍 Longitude: ${checkInProvider.longitude}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primarySwatch,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                foregroundColor: Colors.white, // Text color
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                "Close",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard(String errorMessage) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error, color: accentColor, size: 50),
            SizedBox(height: 10),
            Text(
              "❌ Check-in Failed",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: accentColor),
            ),
            SizedBox(height: 10),
            Text(errorMessage, textAlign: TextAlign.center),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context), // Close popup
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                foregroundColor: Colors.white, // Text color
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                "Close",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
