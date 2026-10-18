import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../core/game_config.dart';

/// A short burst (ring + flash + sparks) played where the player
/// disappears and where they appear.
///
/// TODO(sprite): when you have a teleport sprite, replace [render] with a
/// SpriteAnimationComponent (or draw your sprite here) and keep [lifetime]
/// matching the animation length.
class TeleportEffect extends PositionComponent {
  TeleportEffect({
    required Vector2 position,
    this.color = GameConfig.colorTeleport,
  }) : super(position: position, anchor: Anchor.center, priority: 50) {
    final rng = Random();
    _sparks = List.generate(14, (_) {
      return _Spark(
        angle: rng.nextDouble() * pi * 2,
        speed: 70 + rng.nextDouble() * 90,
        radius: 1.5 + rng.nextDouble() * 2.5,
      );
    });
  }

  final Color color;

  /// Seconds the effect lives.
  static const double lifetime = 0.55;

  late final List<_Spark> _sparks;
  double _t = 0;

  @override
  void update(double dt) {
    super.update(dt);
    _t += dt;
    if (_t >= lifetime) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final p = (_t / lifetime).clamp(0.0, 1.0);
    final fade = 1.0 - p;

    // Expanding ring
    canvas.drawCircle(
      Offset.zero,
      8 + 44 * p,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3 * fade + 0.5
        ..color = color.withAlpha((220 * fade).round()),
    );

    // Initial flash
    if (p < 0.3) {
      final f = 1.0 - p / 0.3;
      canvas.drawCircle(
        Offset.zero,
        18 * (1 - f * 0.4),
        Paint()..color = const Color(0xFFFFFFFF).withAlpha((200 * f).round()),
      );
    }

    // Sparks flying outwards
    final ease = 1 - pow(1 - p, 2).toDouble();
    final sparkPaint = Paint();
    for (final s in _sparks) {
      final d = s.speed * ease * lifetime * 0.6;
      sparkPaint.color = color.withAlpha((255 * fade).round());
      canvas.drawCircle(
        Offset(cos(s.angle) * d, sin(s.angle) * d),
        s.radius * fade + 0.3,
        sparkPaint,
      );
    }
  }
}

class _Spark {
  const _Spark({
    required this.angle,
    required this.speed,
    required this.radius,
  });

  final double angle;
  final double speed;
  final double radius;
}
