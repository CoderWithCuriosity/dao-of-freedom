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

  // ── Sheet config ───────────────────────────────────────────────────
  static const bool _useDedupSheet = true;

  static const double _cellSize = 224;
  static int get _cols => _useDedupSheet ? 8 : 6;

  /// Frame indices (global index = row * cols + col).
  static const _mergedFrames = _Frames(
    idleFront: [0, 1, 2, 3],
    idleBack: [24, 25, 26, 27],
    idleRight: [12, 13, 14, 15],
    idleLeft: [12, 13, 14, 15],
    runFront: [48, 49, 50, 51, 52, 53],
    runBack: [54, 55, 56, 57, 58, 59],
    runRight: [60, 61, 62, 63, 64, 65],
    runLeft: [60, 61, 62, 63, 64, 65],
    attackFront: [62, 63, 64, 65, 66, 67],
    attackBack: [56, 57, 58, 59, 60, 61],
    attackRight: [68, 69, 70, 71, 72, 73],
    attackLeft: [79, 80, 81, 82, 83, 84],
  );

  static const _dedupFrames = _Frames(
    idleFront: [0, 1, 2, 3],
    idleBack: [14, 15, 16, 15],
    idleRight: [8, 8, 9, 9],
    idleLeft: [8, 8, 9, 9],
    runFront: [27, 28, 29, 30, 31, 32],
    runBack: [33, 34, 35, 36, 35, 37],
    //spin is 19,20,21
    //how to take a right step 39
    //section 3 ends in 49
    runRight: [55, 52, 53, 51],
    runLeft: [50, 51, 52, 53, 54, 55],
    attackFront: [62, 63, 64, 65, 66, 67],
    attackBack: [56, 57, 58, 59, 60, 61],
    attackRight: [72, 46, 47, 48, 68, 46],
    // attackRight: [68, 69, 70, 71, 72],
    attackLeft: [82, 48, 46,  80, 47, 45],
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
  late final SpriteAnimation _attackFront;
  late final SpriteAnimation _attackBack;
  late final SpriteAnimation _attackRight;
  late final SpriteAnimation _attackLeft;

  late SpriteAnimationTicker _ticker;
  SpriteAnimation? _currentAnimation;
  Facing _facing = Facing.south;

  static const double _artScale = 1.4;

  bool _isAttacking = false;

  void attack() {
    if (_isAttacking) return;

    _isAttacking = true;

    // Pick attack animation based on current direction
    final attackAnim = switch (_facing) {
      Facing.south => _attackFront,
      Facing.north => _attackBack,
      Facing.east => _attackRight,
      Facing.west => _attackLeft,
    };

    _setAnimation(attackAnim, loop: false);

    // Reset attacking state once the animation finishes
    _ticker.completed.then((_) {
      _isAttacking = false;
    });
  }

  @override
  Future<void> onLoad() async {
    final img = await game.images.load('player/PC/CHARACTER_1.png');
    final sheet = SpriteSheet(image: img, srcSize: Vector2.all(_cellSize));

    final f = _useDedupSheet ? _dedupFrames : _mergedFrames;

    SpriteAnimation fromIndices(
      List<int> indices, {
      double step = 0.12,
      bool loop = true,
    }) {
      return SpriteAnimation(
        indices
            .map(
              (i) => SpriteAnimationFrame(
                sheet.getSprite(i ~/ _cols, i % _cols),
                step,
              ),
            )
            .toList(),
        loop: loop,
      );
    }

    _idleFront = fromIndices(f.idleFront, step: 0.4);
    _idleBack = fromIndices(f.idleBack, step: 0.4);
    _idleRight = fromIndices(f.idleRight, step: 0.4);
    _idleLeft = fromIndices(f.idleLeft, step: 0.4);

    _runFront = fromIndices(f.runFront, step: 0.1);
    _runBack = fromIndices(f.runBack, step: 0.1);
    _runRight = fromIndices(f.runRight, step: 0.1);
    _runLeft = fromIndices(f.runLeft, step: 0.1);

    _attackFront = fromIndices(f.attackFront, step: 0.08, loop: false);
    _attackBack = fromIndices(f.attackBack, step: 0.08, loop: false);
    _attackRight = fromIndices(f.attackRight, step: 0.08, loop: false);
    _attackLeft = fromIndices(f.attackLeft, step: 0.08, loop: false);

    _setAnimation(_idleFront);
  }

  void _setAnimation(SpriteAnimation anim, {bool loop = true}) {
    if (identical(_currentAnimation, anim)) return;
    _currentAnimation = anim;
    _ticker = anim.createTicker();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // If attacking, update ticker and skip movement animation updates
    if (_isAttacking) {
      _ticker.update(dt);
      return;
    }

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

    final flipX = _facing == Facing.west;
    final drawSize = size * _artScale;

    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);
    if (flipX) canvas.scale(-1, 1);
    frame.render(
      canvas,
      position: Vector2(-drawSize.x / 2, -drawSize.y / 2),
      size: drawSize,
    );
    canvas.restore();
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
    required this.attackFront,
    required this.attackBack,
    required this.attackRight,
    required this.attackLeft,
  });

  final List<int> idleFront;
  final List<int> idleBack;
  final List<int> idleRight;
  final List<int> idleLeft;
  final List<int> runFront;
  final List<int> runBack;
  final List<int> runRight;
  final List<int> runLeft;
  final List<int> attackFront;
  final List<int> attackBack;
  final List<int> attackRight;
  final List<int> attackLeft;
}
