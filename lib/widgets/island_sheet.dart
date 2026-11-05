import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../location/nearest.dart';
import '../models/island.dart';
import '../state/location_notifier.dart';

/// A sheet with the island and, when the position is known, the distance.
void showIslandSheet(BuildContext context, Island island) {
  final position = context.read<LocationNotifier>().position;
  showModalBottomSheet<void>(
    context: context,
    builder: (_) => ListTile(
      leading: Image.network(island.imageUrl, width: 56),
      title: Text(island.name),
      subtitle: Text(
        position == null
            ? 'Toca em "A minha posição" para saber a distância.'
            : 'A ${formatDistance(distanceTo(position, island))} de ti.',
      ),
    ),
  );
}
