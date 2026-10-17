import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../core/game_config.dart';

/// Draws a light grid over a large area so we can visually confirm
/// camera movement and world scale.
class GridBackground extends PositionComponent {
  GridBackground({required Vector2 size, required Vector2 position})
      : super(position: position, size: size);

  static const double cellSize = 64.0;

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = GameConfig.colorGrid
      ..strokeWidth = 1.0;

    // Vertical lines
    for (double x = 0; x <= size.x; x += cellSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.y), paint);
    }

    // Horizontal lines
    for (double y = 0; y <= size.y; y += cellSize) {
      canvas.drawLine(Offset(0, y), Offset(size.x, y), paint);
    }
  }
}