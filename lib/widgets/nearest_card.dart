import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../location/location_service.dart';
import '../state/forecast_notifier.dart';
import '../state/location_notifier.dart';

/// "Onde estou?": a button, and the answer in one line.
class NearestCard extends StatelessWidget {
  const NearestCard({super.key});

  @override
  Widget build(BuildContext context) {
    final location = context.watch<LocationNotifier>();
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(child: _answer(location)),
            FilledButton.icon(
              onPressed: location.isLocating
                  ? null
                  : () => location.locate(
                      context.read<ForecastNotifier>().islands,
                    ),
              icon: const Icon(Icons.my_location),
              label: const Text('Onde estou?'),
            ),
          ],
        ),
      ),
    );
  }

  /// The message and, on a phone, a button to the system settings.
  Widget _answer(LocationNotifier location) {
    if (location.isLocating) return const LinearProgressIndicator();
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(location.message),
        if (!kIsWeb && location.status == LocationStatus.serviceOff)
          TextButton(
            onPressed: Geolocator.openLocationSettings,
            child: const Text('Ligar'),
          ),
        if (!kIsWeb && location.status == LocationStatus.deniedForever)
          TextButton(
            onPressed: Geolocator.openAppSettings,
            child: const Text('Definições'),
          ),
      ],
    );
  }
}
