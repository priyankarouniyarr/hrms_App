import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hrms_app/providers/check-in_provider/check_in_provider.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/check-in/sharedlive%20location.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class CheckInScreen extends StatefulWidget {
  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  GoogleMapController? mapController;
  LatLng userLocation = LatLng(0.0, 0.0);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CheckInProvider>(context, listen: false).getpunches();
    });
    super.initState();
  }

  @override
  void dispose() {
    mapController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkInProvider = Provider.of<CheckInProvider>(context);

    userLocation =
        (checkInProvider.latitude != null && checkInProvider.longitude != null)
            ? LatLng(double.parse(checkInProvider.latitude!),
                double.parse(checkInProvider.longitude!))
            : LatLng(0.0, 0.0);

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: CustomAppBarProfile(title: "Check In Details"),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              // Punch and Share Live Location Buttons
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await checkInProvider.punchPost();
                          _showDialog(checkInProvider);

                          mapController!.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: userLocation,
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Center(
                      child: Text(
                        checkInProvider.getPunches.isNotEmpty
                            ? 'Last Punch Time: ${DateFormat('hh:mm a').format(checkInProvider.getPunches.first.punchTime)}'
                            : '--',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.red),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),
                // Google Map

                if (checkInProvider.getPunches.isEmpty)
                  Container(
                    height: 300,
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
                            infoWindow: InfoWindow(
                                title: checkInProvider.aDDress,
                                snippet:
                                    'Lat: ${userLocation.latitude}, Lng: ${userLocation.longitude}'),
                          )
                        },
                        onMapCreated: (GoogleMapController controller) {
                          mapController = controller;

                          mapController!.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: userLocation,
                                zoom: 15,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                else
                  // If there are punches, show the map and last punch location
                  Container(
                    height: 300,
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
                            infoWindow: InfoWindow(
                                title: checkInProvider.aDDress,
                                snippet:
                                    'Lat: ${userLocation.latitude}, Lng: ${userLocation.longitude}'),
                          ),
                        },
                        onMapCreated: (GoogleMapController controller) {
                          mapController = controller;
                          mapController!.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: userLocation,
                                zoom: 15,
                              ),
                            ),
                          );
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
            'Punch',
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
    bool showAll = false;

    return StatefulBuilder(
      builder: (context, setState) {
        final displayedPunches = showAll
            ? provider.getPunches
            : provider.getPunches.take(2).toList();

        return Card(
          elevation: 5,
          shadowColor: Colors.grey.withOpacity(0.2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today's Punch Records",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primarySwatch,
                      ),
                    ),
                    Icon(Icons.fingerprint, color: primarySwatch),
                  ],
                ),
                SizedBox(height: 10),
                if (provider.getPunches.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "No punches recorded yet",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  )
                else
                  Column(
                    children: [
                      ...displayedPunches.map((punch) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      DateFormat('EEEE, hh:mm:ss a')
                                          .format(punch.punchTime),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: primarySwatch,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "${punch.systemDtl}",
                              style: TextStyle(
                                fontSize: 14,
                                color: const Color.fromARGB(255, 30, 146, 0),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      if (provider.getPunches.length > 2 && !showAll)
                        TextButton(
                          onPressed: () => setState(() => showAll = true),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(50, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Show all ',
                                style: TextStyle(
                                  color: primarySwatch,
                                  fontSize: 14,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: primarySwatch,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      if (showAll && provider.getPunches.length > 4)
                        TextButton(
                          onPressed: () => setState(() => showAll = false),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(50, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Show less',
                                style: TextStyle(
                                  color: primarySwatch,
                                  fontSize: 14,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_up,
                                color: primarySwatch,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
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
                Text("Punches Successfully"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await checkInProvider.getpunches();
                  setState(() {});
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
