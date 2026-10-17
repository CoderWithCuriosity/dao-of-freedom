import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Pure description of one world. Add new worlds by creating
/// another instance in WorldRegistry, no other code changes needed.
class WorldDefinition {
  const WorldDefinition({
    required this.id,
    required this.name,
    required this.size,
    required this.groundColor,
    required this.patchColor,
    required this.edgeColor,
    required this.voidColor,
    this.seed = 1,
    this.showGrid = false,
  });

  final String id;
  final String name;

  /// Width/height of the square land in world units.
  final double size;

  final Color groundColor; // main land color
  final Color patchColor;  // subtle variation tiles on top of the ground
  final Color edgeColor;   // border line around the world
  final Color voidColor;   // what you see beyond the edge
  final int seed;          // changes the patch pattern per world
  final bool showGrid;

  Vector2 get spawn => Vector2.all(size / 2);
}