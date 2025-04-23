import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hrms_app/providers/check-in_provider/sharelive%20_location.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen categories/customprofile_appbar.dart';

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

    Future.microtask(() =>
        Provider.of<ShareliveLocation>(context, listen: false)
            .sharelivelocation());
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

  void _shareLocation(double latitude, double longitude) {
    String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude";
    Share.share("My current location: $googleMapsUrl");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarProfile(title: "Live Location"),
      body: SafeArea(
        child: Consumer<ShareliveLocation>(
          builder: (context, shareProvider, child) {
            // Display success message
            if (shareProvider.successMessage != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      shareProvider.successMessage!,
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                      ),
                    ),
                    backgroundColor: cardBackgroundColor,
                  ),
                );
                shareProvider.clearSuccessMessage();
              });
            }

            LatLng? userLocation = (shareProvider.latitude != null &&
                    shareProvider.longitude != null)
                ? LatLng(double.parse(shareProvider.latitude!),
                    double.parse(shareProvider.longitude!))
                : null;

            if (shareProvider.loading) {
              return Center(child: CircularProgressIndicator());
            }

            if (shareProvider.errorMessage.isNotEmpty) {
              return Center(child: Text(shareProvider.errorMessage));
            }

            return Column(
              children: [
                Expanded(
                  child: userLocation == null
                      ? Center(child: Text("Location not available"))
                      : GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: userLocation,
                            zoom: 15,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId("current_location"),
                              position: userLocation,
                              infoWindow: InfoWindow(
                                title: shareProvider.aDDress ?? "Your Location",
                              ),
                            ),
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
                          SnackBar(
                            content: Text('Location is unavailable',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                )),
                            backgroundColor: Colors.red,
                          ),
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
