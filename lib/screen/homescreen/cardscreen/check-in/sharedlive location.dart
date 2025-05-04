import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hrms_app/providers/check-in_provider/sharelive%20_location.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class ShareLiveLocationScreen extends StatefulWidget {
  @override
  State<ShareLiveLocationScreen> createState() =>
      _ShareLiveLocationScreenState();
}

class _ShareLiveLocationScreenState extends State<ShareLiveLocationScreen>
    with WidgetsBindingObserver {
  GoogleMapController? _controller;
  late ShareliveLocation shareProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    Future.microtask(() async {
      await Provider.of<ShareliveLocation>(context, listen: false)
          .getcurrentlocation();
      if (shareProvider.latitude != null && shareProvider.longitude != null) {
        await Provider.of<ShareliveLocation>(context, listen: false)
            .sharelivelocation();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    shareProvider = Provider.of<ShareliveLocation>(context);
  }

  void _shareLocation(double latitude, double longitude) {
    String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude";
    Share.share("My current location: $googleMapsUrl");
  }

  Future<void> _retryLocation() async {
    await shareProvider.getcurrentlocation();
    if (shareProvider.latitude != null && shareProvider.longitude != null) {
      await shareProvider.sharelivelocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show success/error messages
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (shareProvider.successMessage != null) {
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
      }

      if (shareProvider.errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              shareProvider.errorMessage,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
        shareProvider.clearErrorMessage();
      }
    });

    LatLng? userLocation =
        (shareProvider.latitude != null && shareProvider.longitude != null)
            ? LatLng(double.parse(shareProvider.latitude!),
                double.parse(shareProvider.longitude!))
            : null;

    return Scaffold(
      appBar: CustomAppBarProfile(title: "Live Location"),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  if (!shareProvider.loading && userLocation != null)
                    GoogleMap(
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
                        controller.animateCamera(
                          CameraUpdate.newLatLng(userLocation),
                        );
                      },
                    ),
                  if (shareProvider.loading)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            "Fetching location...",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  if (shareProvider.loading && userLocation == null)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_off,
                            size: 48,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 12),
                          Text(
                            "Location unavailable",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _retryLocation,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primarySwatch[900],
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: Text(
                              "Retry",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            if (userLocation != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    _shareLocation(
                        userLocation.latitude, userLocation.longitude);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primarySwatch[900],
                    foregroundColor: Colors.white,
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }
}
