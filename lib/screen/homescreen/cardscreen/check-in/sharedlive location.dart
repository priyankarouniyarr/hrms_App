import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:hrms_app/constants/colors.dart';
import 'package:hrms_app/utlis/socket_handle.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    final provider = Provider.of<ShareliveLocation>(context, listen: false);

    try {
      // Check internet connection first
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await provider.getcurrentlocation(context);
        await provider.sharelivelocation(context);
      } else {
        throw SocketException("No Internet");
      }
    } on SocketException catch (_) {
      await showSocketErrorDialog(
        context: context,
        onRetry: () => _initializeLocation(),
      );
    }
  }

  void _shareLocation(double latitude, double longitude) {
    String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
    Share.share(googleMapsUrl);
  }

  Future<void> _retryLocation() async {
    final provider = Provider.of<ShareliveLocation>(context, listen: false);
    await provider.getcurrentlocation(context);
    await provider.sharelivelocation(context);

    if (_controller != null &&
        provider.latitude != null &&
        provider.longitude != null) {
      _controller!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(double.parse(provider.latitude!),
              double.parse(provider.longitude!)),
        ),
      );
    }
  }

  void _showSnackbarMessages(BuildContext context, ShareliveLocation provider) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.successMessage!,
                style: TextStyle(color: Colors.green)),
            backgroundColor: cardBackgroundColor,
          ),
        );
        provider.clearSuccessMessage();
      }

      if (provider.errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage,
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
        );
        provider.clearErrorMessage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShareliveLocation>(context);
    final userLocation = (provider.latitude != null &&
            provider.longitude != null)
        ? LatLng(
            double.parse(provider.latitude!), double.parse(provider.longitude!))
        : null;

    _showSnackbarMessages(context, provider);

    return Scaffold(
      appBar: CustomAppBarProfile(title: "Live Location"),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  if (userLocation != null && !provider.loading)
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: userLocation,
                        zoom: 16,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId('my_location'),
                          position: userLocation,
                          infoWindow: InfoWindow(
                              title: provider.aDDress ?? "Your Location"),
                        )
                      },
                      onMapCreated: (controller) => _controller = controller,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                    ),
                  if (provider.loading)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text("Fetching location..."),
                        ],
                      ),
                    ),
                  if (userLocation == null && !provider.loading)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_off,
                              size: 40, color: Colors.grey),
                          SizedBox(height: 10),
                          Text("Location unavailable"),
                          ElevatedButton(
                            onPressed: _retryLocation,
                            child: Text("Retry"),
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
                child: ElevatedButton.icon(
                  onPressed: () => _shareLocation(
                      userLocation.latitude, userLocation.longitude),
                  icon: Icon(Icons.share_location),
                  label: Text("Share Location"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primarySwatch[900],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
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
