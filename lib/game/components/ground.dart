import 'dart:ui' as ui;

import 'package:flame/components.dart' hide Matrix4;
import 'package:flame/game.dart' hide Matrix4;
import 'package:flutter/material.dart';

import '../worlds/world_definition.dart';

/// The whole land, drawn by repeating one tile image.
class Ground extends PositionComponent with HasGameReference<FlameGame> {
  Ground({required this.definition, required this.camera})
      : super(
          position: Vector2.zero(),
          size: Vector2.all(definition.size),
          priority: -100, // behind player and everything else
        );

  final WorldDefinition definition;
  final CameraComponent camera;

  late final Paint _groundPaint;
  late final Paint _edgePaint;
  late final Rect _land;

  @override
  Future<void> onLoad() async {
    _land = Rect.fromLTWH(0, 0, definition.size, definition.size);

    final image = await game.images.load(definition.tileAsset);
    final s = definition.tileScale;

    _groundPaint = Paint()
      ..shader = ui.ImageShader(
        image,
        TileMode.repeated,
        TileMode.repeated,
        Matrix4.diagonal3Values(s, s, 1).storage,
        filterQuality: FilterQuality.low,
      );

    _edgePaint = Paint()
      ..color = definition.edgeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;
  }

  @override
  void render(Canvas canvas) {
    // Only paint what the camera can see (clipped to the land).
    final visible = camera.visibleWorldRect.intersect(_land);
    if (visible.isEmpty) return;

    canvas.drawRect(visible, _groundPaint);
    canvas.drawRect(_land, _edgePaint);
  }
}