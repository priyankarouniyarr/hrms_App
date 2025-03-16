import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/providers/check_in_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/check-in/subcategories/sharedlive%20location.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class CheckInScreen extends StatefulWidget {
  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    final checkInProvider = Provider.of<CheckInProvider>(context);

    LatLng? userLocation =
        (checkInProvider.latitude != null && checkInProvider.longitude != null)
            ? LatLng(double.parse(checkInProvider.latitude!),
                double.parse(checkInProvider.longitude!))
            : LatLng(0.0, 0.0);

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: CustomAppBarProfile(title: "Check In Details"),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        await checkInProvider.punchPost();
                        _showDialog(checkInProvider);
                        mapController.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target:
                                  userLocation, // Target position (marker location)
                              zoom: 15.0, // Adjust zoom level
                            ),
                          ),
                        );
                      },
                      child: _buildCheckInButton(checkInProvider),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        //  await checkInProvider.punchPost();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ShareLiveLocationScreen()));
                      },
                      child: _buildLocationButton(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              _buildStatusCard(checkInProvider),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.access_time_rounded, size: 50),
                  StreamBuilder(
                    stream: Stream.periodic(Duration(seconds: 1)),
                    builder: (context, snapshot) {
                      return Center(
                        child: Text(
                          "  ${DateFormat('hh:mm:ss a').format(DateTime.now())}",
                          style: TextStyle(
                              fontSize: 25,
                              color: primarySwatch,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                  Center(
                    child: Text(
                      "  ${DateFormat('d MMM yyyy').format(DateTime.now())}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Center(
                    child: Text(
                      checkInProvider.isCheckedIn
                          ? ' Last Check-in at: ${checkInProvider.checkInTime ?? '- -'}'
                          : ' Last Check-out at: ${checkInProvider.checkOutTime ?? '--'}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),
              // Google Map
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: userLocation,
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        visible: true,
                        markerId: MarkerId("current_location"),
                        position: userLocation,
                        infoWindow: InfoWindow(title: checkInProvider.aDDress),
                      )
                    },
                    onMapCreated: (GoogleMapController controller) {
                      mapController = controller;
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckInButton(CheckInProvider provider) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18, horizontal: 30),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.fingerprint, color: Colors.blue, size: 30),
          SizedBox(height: 15),
          Text(
            provider.isCheckedIn ? 'Check Out' : 'Check In',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.location_on, color: Colors.green, size: 30),
          SizedBox(height: 15),
          Text(
            "Share Live Location",
            style: TextStyle(
              color: Colors.green,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(CheckInProvider provider) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatusColumn("Check In", provider.checkInTime),
            Text("/",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500)),
            _buildStatusColumn("Check Out", provider.checkOutTime),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusColumn(String label, String? time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 4),
        Text(
          time ?? '--:--',
          style: TextStyle(
              fontSize: 20,
              color: primarySwatch[900],
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  void _showDialog(CheckInProvider checkInProvider) {
    if (checkInProvider.successMessage != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Column(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 50),
                SizedBox(height: 10),
                Text(checkInProvider.isCheckedIn
                    ? "Check-In Successful"
                    : "Check-Out Successful"),
              ],
            ),
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
    } else if (checkInProvider.errorMessage.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(checkInProvider.errorMessage),
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
    }
  }
}
