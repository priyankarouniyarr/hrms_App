import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hrms_app/providers/check_in_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hrms_app/screen/profile/subcategories/appbar_profilescreen%20categories/customprofile_appbar.dart';

class ShareLiveLocationScreen extends StatefulWidget {
  @override
  State<ShareLiveLocationScreen> createState() =>
      _ShareLiveLocationScreenState();
}

class _ShareLiveLocationScreenState extends State<ShareLiveLocationScreen> {
  GoogleMapController? _controller;

  @override
  Widget build(BuildContext context) {
    final checkInProvider = Provider.of<CheckInProvider>(context);
    LatLng? userLocation =
        (checkInProvider.latitude != null && checkInProvider.longitude != null)
            ? LatLng(double.parse(checkInProvider.latitude!),
                double.parse(checkInProvider.longitude!))
            : null;
    return Scaffold(
      appBar: CustomAppBarProfile(title: "Live Location"),
      body: SafeArea(
        child: Container(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: userLocation!,
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
              _controller = controller;
            },
          ),
        ),
      ),
    );
  }
}
