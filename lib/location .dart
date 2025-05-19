import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<void> handleLocationPermission() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      print(
          "Location service is OFF. You can prompt the user to enable it if needed.");
    } else {
      print("Location service is ON");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    print("Initial permission: $permission");

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      print("Permission after request: $permission");

      if (permission == LocationPermission.denied) {
        print("Permission denied. App will continue without location access.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print(
          "Permission permanently denied. App will continue without location access.");
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      try {
        Position position = await Geolocator.getCurrentPosition();
        print('Location: ${position.latitude}, ${position.longitude}');
      } catch (e) {
        print("Error getting location: $e");
      }
    } else {
      print(
          "Location permission denied or not granted. App will continue without location access.");
    }
  }
}
