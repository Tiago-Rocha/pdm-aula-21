import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../location/location_service.dart';
import '../location/nearest.dart';
import '../models/island.dart';

/// Where the person is. Knows the service, not the widgets.
class LocationNotifier extends ChangeNotifier {
  LocationNotifier(this._service); // injected, not created here

  final LocationService _service;

  bool isLocating = false;
  LocationStatus? status; // null until the first tap
  Position? position;
  Nearest? nearest;
  String? error;

  Future<void> locate(List<Island> islands) async {
    isLocating = true;
    error = null;
    notifyListeners(); // the card shows the progress bar
    try {
      status = await _service.check();
      if (status == LocationStatus.ready) {
        final found = await _service.position();
        position = found;
        // TODO 2: nearest, from found and islands
      }
    } on TimeoutException {
      error = 'Sem sinal. Tenta perto de uma janela.';
    } catch (e) {
      error = '$e';
    } finally {
      isLocating = false;
      notifyListeners(); // the card shows the answer
    }
  }

  /// What to tell the person, in one line.
  String get message {
    if (error != null) return error!;
    final nearest = this.nearest;
    final position = this.position;
    return switch (status) {
      null => 'Toca no botão para saber a ilha mais próxima.',
      LocationStatus.serviceOff =>
        'A localização está desligada no telemóvel.',
      LocationStatus.deniedForever =>
        'Sem permissão. Muda isso nas definições.',
      LocationStatus.denied =>
        'Sem a tua posição não há ilha mais próxima.',
      LocationStatus.ready when nearest != null =>
        'Estás a ${formatDistance(nearest.metres)} de ${nearest.island.name}.',
      LocationStatus.ready when position != null =>
        'Estás em ${position.latitude.toStringAsFixed(2)}, '
            '${position.longitude.toStringAsFixed(2)}.',
      LocationStatus.ready => 'Sem posição.',
    };
  }
}
