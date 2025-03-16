import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/providers/check_in_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class ShareLiveLocationScreen extends StatefulWidget {
  @override
  State<ShareLiveLocationScreen> createState() =>
      _ShareLiveLocationScreenState();
}

class _ShareLiveLocationScreenState extends State<ShareLiveLocationScreen>
    with WidgetsBindingObserver {
  GoogleMapController? _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _controller?.dispose();
    }
  }

  // Function to share location
  void _shareLocation(double latitude, double longitude) {
    String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude";
    Share.share(" $googleMapsUrl");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarProfile(title: "Live Location"),
      body: SafeArea(
        child: Consumer<CheckInProvider>(
          builder: (context, checkInProvider, child) {
            LatLng? userLocation = (checkInProvider.latitude != null &&
                    checkInProvider.longitude != null)
                ? LatLng(double.parse(checkInProvider.latitude!),
                    double.parse(checkInProvider.longitude!))
                : null;

            return Column(
              children: [
                Expanded(
                  child: userLocation == null
                      ? FutureBuilder(
                          future: checkInProvider.punchPost(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text("Error fetching location"));
                            } else {
                              return Center(
                                  child: Text("No location data available"));
                            }
                          },
                        )
                      : GoogleMap(
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
                                  title: checkInProvider.aDDress ??
                                      "Your Location"),
                            )
                          },
                          onMapCreated: (GoogleMapController controller) {
                            _controller = controller;
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (userLocation != null) {
                        _shareLocation(
                            userLocation.latitude, userLocation.longitude);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Location is unavailable')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primarySwatch[900],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 32.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'Share Location',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
