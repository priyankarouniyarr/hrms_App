import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // Import for placemarkFromCoordinates

Future<void> handleLocationPermission() async {
  bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!isLocationServiceEnabled) {
    print("Location services are disabled.");
    return;
  }

  // Check current permission
  LocationPermission permission = await Geolocator.checkPermission();

  // If permission is denied, request permission
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print("Location permission denied.");
      return; // Permission denied
    }
  }

  // If permission is denied forever, request again or inform the user
  if (permission == LocationPermission.deniedForever) {
    print("Location permission denied forever.");
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.deniedForever) {
      print("Location permission still denied forever.");
      return; // Permission still denied forever
    }
  }

  try {
    // Fetch the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Fetch the address from the coordinates (latitude, longitude)
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks[0]; // Get the first result
      String address =
          '${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      print('Current address: $address');
    } else {
      print('No address found for the current location.');
    }

    // You can use the latitude and longitude as well
    print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
  } catch (e) {
    print("Error getting location or address: $e");
  }
}
