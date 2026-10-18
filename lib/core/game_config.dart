import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GameConfig {
  GameConfig._();

  // ---------------------------------------------------------------------------
  // World view
  // ---------------------------------------------------------------------------

  /// Reference world height. The camera keeps this many world units
  /// vertically visible regardless of device resolution.
  static const double designHeight = 720.0;

  // ---------------------------------------------------------------------------
  // Player
  // ---------------------------------------------------------------------------

  /// Player base size in world units.
  static const double playerSize = 48.0;

  /// Movement speed in world units per second.
  static const double playerSpeed = 160.0;

  // ---------------------------------------------------------------------------
  // Flying / teleport
  // ---------------------------------------------------------------------------

  /// Flying speed = playerSpeed * this.
  static const double flySpeedMultiplier = 2.0;

  /// How high (world units) the body floats above the ground while flying.
  static const double hoverHeight = 20.0;

  /// Seconds between teleports.
  static const double teleportCooldown = 0.4;

  // ---------------------------------------------------------------------------
  // Colors (placeholders until sprites arrive)
  // ---------------------------------------------------------------------------

  static const Color colorBackground = Color(0xFF1A1A1A);
  static const Color colorPlayer = Color(0xFF7FDBFF);
  static const Color colorGrid = Color(0xFF2A2A2A);

  /// Levitation circle colours.
  static const Color colorFly = Color(0xFF7FDBFF);
  static const Color colorTeleport = Color(0xFFB388FF);

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Returns the design height for a given screen size.
  ///
  /// Version A: constant. See Version B in the notes below for a
  /// screen-dependent variant.
  static double designHeightFor(Vector2 screen) => designHeight;

  static Vector2 get playerHalfSize => Vector2.all(playerSize) / 2.0;
}