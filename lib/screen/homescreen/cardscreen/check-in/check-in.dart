import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hrms_app/providers/check-in_provider/check_in_provider.dart';
import 'package:hrms_app/screen/homescreen/cardscreen/check-in/sharedlive location.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen categories/customprofile_appbar.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  GoogleMapController? mapController;
  LatLng? mapLocation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPunches();
    });
  }

  Future<void> _loadPunches() async {
    final provider = Provider.of<CheckInProvider>(context, listen: false);
    await provider.getpunches(context);

    if (provider.getPunches.isNotEmpty) {
      var lastPunch = provider.getPunches.first;
      mapLocation = splitLatLon(lastPunch.systemDtl);
      print("Using last punch location: ${mapLocation}");

      /// Animate map to this location if controller already exists
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(mapLocation!, 15),
        );
      }
    } else {
      mapLocation = null;
      print("No punches - map will not show");
    }

    setState(() {});
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkInProvider = Provider.of<CheckInProvider>(context);

    return Scaffold(
      backgroundColor: cardBackgroundColor,
      appBar: CustomAppBarProfile(title: "Check In Details"),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          await checkInProvider.getcurrentlocation();
                          await checkInProvider.punchPost();
                          await _loadPunches();

                          if (checkInProvider.getPunches.isNotEmpty) {
                            var latestPunch = checkInProvider.getPunches.first;
                            var newLocation =
                                splitLatLon(latestPunch.systemDtl);
                            setState(() {
                              mapLocation = newLocation;
                            });

                            if (mapController != null) {
                              mapController!.animateCamera(
                                CameraUpdate.newLatLngZoom(newLocation, 15),
                              );
                            }
                          }

                          _showDialog(checkInProvider);
                        },
                        child: _buildCheckInButton(),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ShareLiveLocationScreen()),
                          );
                        },
                        child: _buildLocationButton(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                _buildStatusCard(checkInProvider),
                SizedBox(height: 20),
                if (mapLocation != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 300,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: mapLocation!,
                          zoom: 14,
                        ),
                        markers: {
                          Marker(
                            markerId: MarkerId("last_punch"),
                            position: mapLocation!,
                            infoWindow: InfoWindow(
                                title: checkInProvider.aDDress ??
                                    "Last Punch Location",
                                snippet:
                                    'Lat: ${mapLocation!.latitude}, Lng: ${mapLocation!.longitude}'),
                          ),
                        },
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        onMapCreated: (controller) {
                          mapController = controller;
                          mapController!.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(target: mapLocation!, zoom: 15),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckInButton() {
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
                                  Icon(Icons.check_circle,
                                      color: Colors.green, size: 20),
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
                            Text(
                              formatLatLong(punch.systemDtl),
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromARGB(255, 30, 146, 0),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      if (provider.getPunches.length > 2 && !showAll)
                        TextButton(
                          onPressed: () => setState(() => showAll = true),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Show all ',
                                  style: TextStyle(color: primarySwatch)),
                              Icon(Icons.keyboard_arrow_down,
                                  color: primarySwatch),
                            ],
                          ),
                        ),
                      if (showAll && provider.getPunches.length > 4)
                        TextButton(
                          onPressed: () => setState(() => showAll = false),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Show less',
                                  style: TextStyle(color: primarySwatch)),
                              Icon(Icons.keyboard_arrow_up,
                                  color: primarySwatch),
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

  String formatLatLong(String input) {
    try {
      // Remove unnecessary spaces
      input = input.replaceAll(" ", "");

      // Extract the latitude and longitude parts
      final parts = input.split(',');

      // Parse the latitude
      final latPart = parts[0].split(':')[1];
      final lat = double.parse(latPart);

      // Parse the longitude
      final longPart = parts[1].split(':')[1];
      final long = double.parse(longPart);

      // Format to two decimal places
      return 'Lat: ${lat.toStringAsFixed(2)}, Long: ${long.toStringAsFixed(2)}';
    } catch (e) {
      // If there’s any issue, return the original string
      return input;
    }
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
                Text("Punch Successful"),
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

  LatLng splitLatLon(String systemDtl) {
    List<String> parts = systemDtl.split(',');
    var lat = parts[0].trim().split(': ')[1].trim();
    var lon = parts[1].trim().split(': ')[1].trim();
    return LatLng(double.parse(lat), double.parse(lon));
  }
}
