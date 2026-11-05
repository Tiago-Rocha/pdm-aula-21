import 'package:geolocator/geolocator.dart';

import '../models/island.dart';

/// The closest island and how far it is, in metres.
typedef Nearest = ({Island island, double metres});

/// Metres in a straight line from the position to the centre of the island.
double distanceTo(Position position, Island island) {
  return Geolocator.distanceBetween(
    position.latitude,
    position.longitude,
    island.latitude,
    island.longitude,
  );
}

/// Measures the distance to every island; the shortest wins.
Nearest nearestIsland(Position position, List<Island> islands) {
  // TODO 2: distanceTo each island; keep the shortest
  return (island: islands.first, metres: 0);
}

/// 850 m, 16 km.
String formatDistance(double metres) {
  if (metres < 1000) return '${metres.round()} m';
  return '${(metres / 1000).round()} km';
}
