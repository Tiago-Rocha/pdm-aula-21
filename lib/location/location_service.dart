import 'package:geolocator/geolocator.dart';

/// What the phone answered when the app asked for the position.
enum LocationStatus { ready, serviceOff, denied, deniedForever }

/// Talks to the system about the position. Knows no widgets.
class LocationService {
  /// Asks for permission, if needed, and says which answer came back.
  Future<LocationStatus> check() async {
    // TODO 1: is the service on? Ask for permission, map the four answers.
    return LocationStatus.denied;
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
