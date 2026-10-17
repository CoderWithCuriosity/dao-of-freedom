import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../core/game_config.dart';

class Player extends PositionComponent {
  Player({required Vector2 position})
      : super(
          position: position,
          size: Vector2.all(GameConfig.playerSize),
          anchor: Anchor.center,
        );

  /// Normalized direction the player should move.
  /// Set externally (by the joystick) each frame. Zero means "stop".
  final Vector2 moveDirection = Vector2.zero();

  @override
  void update(double dt) {
    super.update(dt);

    if (moveDirection.length2 > 0) {
      // Normalize so diagonal movement isn't faster.
      final dir = moveDirection.normalized();
      position += dir * GameConfig.playerSpeed * dt;
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = GameConfig.colorPlayer;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        size.toRect(),
        const Radius.circular(8),
      ),
      paint,
    );
  }
}