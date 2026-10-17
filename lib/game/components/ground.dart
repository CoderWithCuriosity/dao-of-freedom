import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../worlds/world_definition.dart';

/// The land itself. Lives at a very low priority so trees, rocks,
/// players, etc. always render above it.
class Ground extends PositionComponent {
  Ground({required this.definition, required this.camera})
      : super(
          position: Vector2.zero(),
          size: Vector2.all(definition.size),
          priority: -100,
        );

  final WorldDefinition definition;
  final CameraComponent camera;

  static const double tile = 128.0;

  final Paint _basePaint = Paint();
  final Paint _patchPaint = Paint();
  final Paint _edgePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 12;
  final Paint _gridPaint = Paint()..strokeWidth = 1;

  @override
  void render(Canvas canvas) {
    final worldRect = Rect.fromLTWH(0, 0, size.x, size.y);
    final visible = camera.visibleWorldRect.inflate(tile).intersect(worldRect);
    if (visible.isEmpty) return;

    // 1. Base land
    _basePaint.color = definition.groundColor;
    canvas.drawRect(visible, _basePaint);

    // 2. Patches for visual variety (and so movement is noticeable)
    _patchPaint.color = definition.patchColor;
    final startX = (visible.left / tile).floor();
    final endX = (visible.right / tile).ceil();
    final startY = (visible.top / tile).floor();
    final endY = (visible.bottom / tile).ceil();

    for (var tx = startX; tx < endX; tx++) {
      for (var ty = startY; ty < endY; ty++) {
        final h = _hash(tx, ty, definition.seed);
        if (h % 4 == 0) {
          // Slightly vary size/offset so it doesn't look like a checkerboard
          final w = tile * (0.5 + (h % 50) / 100);
          final ox = (h % 37) / 37 * (tile - w);
          final oy = ((h ~/ 7) % 37) / 37 * (tile - w);
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(tx * tile + ox, ty * tile + oy, w, w),
              const Radius.circular(24),
            ),
            _patchPaint,
          );
        }
      }
    }

    // 3. Optional grid
    if (definition.showGrid) {
      _gridPaint.color = Colors.white10;
      for (var x = startX * tile; x <= endX * tile; x += tile) {
        canvas.drawLine(Offset(x, visible.top), Offset(x, visible.bottom), _gridPaint);
      }
      for (var y = startY * tile; y <= endY * tile; y += tile) {
        canvas.drawLine(Offset(visible.left, y), Offset(visible.right, y), _gridPaint);
      }
    }

    // 4. World border
    _edgePaint.color = definition.edgeColor;
    canvas.drawRect(worldRect, _edgePaint);
  }

  static int _hash(int x, int y, int seed) {
    var h = x * 73856093 ^ y * 19349663 ^ seed * 83492791;
    h = (h ^ (h >> 13)) & 0x7fffffff;
    return h;
  }
}