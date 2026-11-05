import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../models/island.dart';
import '../state/forecast_notifier.dart';
import '../state/location_notifier.dart';
import '../widgets/island_sheet.dart';

/// The nine islands on a map made of OpenStreetMap tiles.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _controller = MapController();

  // A box around the archipelago: the centre of the map stays inside it.
  static final _azores = LatLngBounds(
    const LatLng(36.5, -31.8), // south-west, past Flores
    const LatLng(40.0, -24.3), // north-east, past Santa Maria
  );

  @override
  Widget build(BuildContext context) {
    final islands = context.watch<ForecastNotifier>().islands;
    final position = context.watch<LocationNotifier>().position;
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa')),
      body: FlutterMap(
        mapController: _controller,
        options: MapOptions(
          initialCenter: const LatLng(38.4, -28.0),
          initialZoom: 6,
          minZoom: 5,
          maxZoom: 14,
          cameraConstraint: CameraConstraint.containCenter(bounds: _azores),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'pt.uac.tempo_acores',
          ),
          MarkerLayer(
            markers: [
              for (final island in islands) _marker(context, island),
              if (position != null) _mePin(position),
            ],
          ),
          const RichAttributionWidget(
            alignment: AttributionAlignment.bottomLeft, // the button is right
            attributions: [TextSourceAttribution('OpenStreetMap contributors')],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToMe,
        tooltip: 'A minha posição',
        child: const Icon(Icons.my_location),
      ),
    );
  }

  /// A pin with the name; a tap opens the sheet.
  Marker _marker(BuildContext context, Island island) {
    final theme = Theme.of(context);
    return Marker(
      point: LatLng(island.latitude, island.longitude),
      width: 110,
      height: 56,
      child: GestureDetector(
        onTap: () => showIslandSheet(context, island),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.place, size: 32, color: theme.colorScheme.primary),
            Text(island.name, style: theme.textTheme.labelSmall),
          ],
        ),
      ),
    );
  }

  /// The red pin of the person.
  Marker _mePin(Position position) {
    return Marker(
      point: LatLng(position.latitude, position.longitude),
      width: 40,
      height: 40,
      child: const Icon(Icons.person_pin_circle, size: 40, color: Colors.red),
    );
  }

  /// Asks for the position and moves the map there.
  Future<void> _goToMe() async {
    // TODO 4: ask the LocationNotifier, then move the camera there
  }
}
