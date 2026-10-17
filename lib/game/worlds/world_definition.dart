import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Pure description of one world. Add a new world by adding one instance
/// in WorldRegistry + one tile png in assets/images/tiles/.
class WorldDefinition {
  const WorldDefinition({
    required this.id,
    required this.name,
    required this.size,
    required this.tileAsset,
    required this.edgeColor,
    required this.voidColor,
    this.tileScale = 1.0,
    this.showGrid = false,
  });

  final String id;
  final String name;

  /// Width/height of the square land in world units.
  final double size;

  /// Path relative to assets/images/, e.g. 'tiles/verdant_plains.png'.
  final String tileAsset;

  /// How big one tile is drawn: 1.0 = 256 world units. 0.5 = smaller hexes.
  final double tileScale;

  final Color edgeColor; // border line around the world
  final Color voidColor; // what you see beyond the edge
  final bool showGrid;

  Vector2 get spawn => Vector2.all(size / 2);
}