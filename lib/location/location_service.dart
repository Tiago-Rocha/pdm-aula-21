import 'package:geolocator/geolocator.dart';

/// What the phone answered when the app asked for the position.
enum LocationStatus { ready, serviceOff, denied, deniedForever }

/// Talks to the system about the position. Knows no widgets.
class LocationService {
  /// Asks for permission, if needed, and says which answer came back.
  Future<LocationStatus> check() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return LocationStatus.serviceOff; // off for every app, not just ours
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission(); // the dialog
    }
    return switch (permission) {
      LocationPermission.whileInUse ||
      LocationPermission.always => LocationStatus.ready,
      LocationPermission.deniedForever => LocationStatus.deniedForever,
      _ => LocationStatus.denied,
    };
  }

  /// One position. Wi-Fi accuracy is enough: islands are kilometres apart.
  Future<Position> position() {
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 15), // indoors it may never come
      ),
    );
  }
}
