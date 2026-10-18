import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

/// A round on/off button for the HUD. It reads its state through
/// [isActive] every frame, so it always reflects the player's real state
/// (e.g. turning teleport on also turns flying on).
class HudToggleButton extends PositionComponent with TapCallbacks {
  HudToggleButton({
    required this.label,
    required this.isActive,
    required this.onToggle,
    required this.activeColor,
    required Vector2 position,
    this.radius = 28,
  }) : super(
         position: position,
         size: Vector2.all(radius * 2),
         anchor: Anchor.center,
       );

  final String label;
  final bool Function() isActive;
  final VoidCallback onToggle;
  final Color activeColor;
  final double radius;

  late final TextPainter _text;

  @override
  Future<void> onLoad() async {
    _text = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
  }

  @override
  void onTapDown(TapDownEvent event) => onToggle();

  @override
  void render(Canvas canvas) {
    final on = isActive();
    final c = Offset(radius, radius);

    canvas.drawCircle(
      c,
      radius,
      Paint()
        ..color = on ? activeColor.withAlpha(200) : const Color(0x55FFFFFF),
    );
    canvas.drawCircle(
      c,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = on ? activeColor : const Color(0x88FFFFFF),
    );

    _text.paint(
      canvas,
      Offset(radius - _text.width / 2, radius - _text.height / 2),
    );
  }
}
