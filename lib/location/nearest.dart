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
  var best = islands.first;
  var shortest = double.infinity;
  for (final island in islands) {
    final metres = distanceTo(position, island);
    if (metres < shortest) {
      shortest = metres;
      best = island;
    }
  }
  return (island: best, metres: shortest);
}

/// 850 m, 16 km.
String formatDistance(double metres) {
  if (metres < 1000) return '${metres.round()} m';
  return '${(metres / 1000).round()} km';
}
