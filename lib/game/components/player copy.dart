import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import '../../core/game_config.dart';

/// Which way the player is looking. Used to pick the right animation row.
enum Facing { south, north, east, west }

class Player extends PositionComponent with HasGameReference {
  Player({required Vector2 position})
    : super(
        position: position,
        size: Vector2.all(GameConfig.playerSize),
        anchor: Anchor.center,
      );

  /// Normalized direction the player should move.
  final Vector2 moveDirection = Vector2.zero();

  // ── Sheet config (spritesheet_no_duplicates_packed.json) ───────────
  static const double _cellW = 183;
  static const double _cellH = 203;
  static const int _cols = 5; // 19 rows x 5 cols, 95 frames

  /// Global frame index = row * 5 + col (same as "index" in the JSON).
  ///
  /// Source sections:
  ///   S1 (0-13)   idle / turning poses
  ///   S2 (14-26)  idle / turning poses
  ///   S3 (27-49)  run front, run back, run right, attack right
  ///   S4 (50-73)  run right, attack back, attack front, attack right
  ///   S5 (74-94)  run left, attack left (true left-facing art, NO flip)
  static const _frames = _Frames(
    // S1_R1F0-F3: facing viewer
    idleFront: [0, 1, 2, 3],
    // S2_R1F0,F1,F2: back to viewer
    idleBack: [14, 15, 16, 15],
    // S1_R3F0, S1_R3F2: right profile
    idleRight: [8, 8, 9, 9],
    // S5_R2F0: left-facing neutral guard
    idleLeft: [20],
    // S3_R1F0-F5
    runFront: [27, 28, 29, 30, 31, 32],
    // S3_R2F0,F1,F2,F3,F5 (F4 was a duplicate and removed)
    runBack: [33, 34, 35, 36, 37],
    // S3_R3F0-F5 (right-facing). Alternative: S4_R1 = 50-55
    runRight: [38, 39, 40, 41, 42, 43],
    // S5_R1F0,F1,F2,F4,F5 (F3 removed as duplicate)
    runLeft: [85, 75, 86, 88, 87],
  );

  // ── Animations ─────────────────────────────────────────────────────
  late final SpriteAnimation _idleFront;
  late final SpriteAnimation _idleBack;
  late final SpriteAnimation _idleRight;
  late final SpriteAnimation _idleLeft;
  late final SpriteAnimation _runFront;
  late final SpriteAnimation _runBack;
  late final SpriteAnimation _runRight;
  late final SpriteAnimation _runLeft;

  late SpriteAnimationTicker _ticker;
  SpriteAnimation? _currentAnimation;
  Facing _facing = Facing.south;

  static const double _artScale = 1.4;

  @override
  Future<void> onLoad() async {
    final img = await game.images.load('player/PC/CHARACTER_1.png');
    final sheet = SpriteSheet.fromColumnsAndRows(
      image: img,
      columns: _cols,
      rows: 19,
    );

    SpriteAnimation fromIndices(List<int> indices, {double step = 0.12}) {
      return SpriteAnimation(
        indices
            .map(
              (i) => SpriteAnimationFrame(
                sheet.getSprite(i ~/ _cols, i % _cols),
                step,
              ),
            )
            .toList(),
      );
    }

    final f = _frames;
    _idleFront = fromIndices(f.idleFront, step: 0.4);
    _idleBack = fromIndices(f.idleBack, step: 0.4);
    _idleRight = fromIndices(f.idleRight, step: 0.4);
    _idleLeft = fromIndices(f.idleLeft, step: 0.4);

    _runFront = fromIndices(f.runFront, step: 0.1);
    _runBack = fromIndices(f.runBack, step: 0.1);
    _runRight = fromIndices(f.runRight, step: 0.1);
    _runLeft = fromIndices(f.runLeft, step: 0.1);

    _setAnimation(_idleFront);
  }

  void _setAnimation(SpriteAnimation anim) {
    if (identical(_currentAnimation, anim)) return;
    _currentAnimation = anim;
    _ticker = anim.createTicker();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (moveDirection.length2 > 0) {
      final dir = moveDirection.normalized();
      position += dir * GameConfig.playerSpeed * dt;

      if (dir.x.abs() > dir.y.abs()) {
        _facing = dir.x >= 0 ? Facing.east : Facing.west;
      } else {
        _facing = dir.y >= 0 ? Facing.south : Facing.north;
      }

      switch (_facing) {
        case Facing.south:
          _setAnimation(_runFront);
        case Facing.north:
          _setAnimation(_runBack);
        case Facing.east:
          _setAnimation(_runRight);
        case Facing.west:
          _setAnimation(_runLeft);
      }
    } else {
      switch (_facing) {
        case Facing.south:
          _setAnimation(_idleFront);
        case Facing.north:
          _setAnimation(_idleBack);
        case Facing.east:
          _setAnimation(_idleRight);
        case Facing.west:
          _setAnimation(_idleLeft);
      }
    }

    _ticker.update(dt);
  }

  @override
  void render(Canvas canvas) {
    final frame = _ticker.getSprite();

    // Cells are 183x203 (not square), so keep the aspect ratio.
    final drawH = size.y * _artScale;
    final drawW = drawH * (_cellW / _cellH);

    // The sheet has real left-facing art (section 5), so no mirroring.
    frame.render(
      canvas,
      position: Vector2(size.x / 2 - drawW / 2, size.y / 2 - drawH / 2),
      size: Vector2(drawW, drawH),
    );
  }
}

class _Frames {
  const _Frames({
    required this.idleFront,
    required this.idleBack,
    required this.idleRight,
    required this.idleLeft,
    required this.runFront,
    required this.runBack,
    required this.runRight,
    required this.runLeft,
  });

  final List<int> idleFront;
  final List<int> idleBack;
  final List<int> idleRight;
  final List<int> idleLeft;
  final List<int> runFront;
  final List<int> runBack;
  final List<int> runRight;
  final List<int> runLeft;
}