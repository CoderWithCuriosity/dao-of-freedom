import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/experimental.dart';

import '../core/game_config.dart';
import '../models/player_status.dart';
import 'components/ground.dart';
import 'components/hud_toggle_button.dart';
import 'components/player.dart';
import 'worlds/world_definition.dart';
import 'package:flame/input.dart';

class DaoGame extends FlameGame with HasCollisionDetection {
  DaoGame({required this.playerStatus, required this.worldDef});

  final PlayerStatus playerStatus;
  final WorldDefinition worldDef;

  late final Player player;
  late final JoystickComponent joystick;
  late final HudButtonComponent attackButton;
  late final HudToggleButton flyButton;
  late final HudToggleButton teleportButton;

  /// Size of the fixed-resolution viewport in design units. Computed in
  /// onLoad (camera.viewport.size can still be empty at that point).
  late final Vector2 viewSize;

  @override
  Color backgroundColor() => worldDef.voidColor;

  @override
  Future<void> onLoad() async {
    final designH = GameConfig.designHeightFor(size);
    final aspect = size.x / size.y;
    viewSize = Vector2(designH * aspect, designH);

    camera = CameraComponent.withFixedResolution(
      width: designH * aspect,
      height: designH,
      world: world,
    );

    // The land: one big ground for the whole world.
    world.add(Ground(definition: worldDef, camera: camera));

    player = Player(position: worldDef.spawn);
    camera.follow(player);
    world.add(player);

    // Stop the camera from showing the void past the edge.
    camera.setBounds(
      Rectangle.fromRect(
        Rect.fromLTWH(0, 0, worldDef.size, worldDef.size),
      ),
    );

    // Full-screen tap layer, added FIRST with the lowest priority so the
    // joystick and buttons sit on top of it and win the taps.
    camera.viewport.add(_TeleportTapLayer(game: this, viewSize: viewSize));

    joystick = JoystickComponent(
      knob: CircleComponent(
        radius: 24,
        paint: Paint()..color = const Color(0xFFCCCCCC),
      ),
      background: CircleComponent(
        radius: 56,
        paint: Paint()..color = const Color(0x33FFFFFF),
      ),
      margin: const EdgeInsets.only(left: 120, bottom: 120),
    );
    camera.viewport.add(joystick);

    // Attack Button setup
    attackButton = HudButtonComponent(
      button: CircleComponent(
        radius: 35,
        paint: Paint()..color = const Color(0x88FF0000),
      ),
      buttonDown: CircleComponent(
        radius: 35,
        paint: Paint()..color = const Color(0xFFFF0000),
      ),
      margin: const EdgeInsets.only(right: 120, bottom: 120),
      onPressed: () => player.attack(),
    );
    camera.viewport.add(attackButton);

    // Fly + Teleport toggles, arranged around the attack button.
    // Attack button centre is (W - 155, H - 155).
    final vp = viewSize;

    flyButton = HudToggleButton(
      label: 'FLY',
      isActive: () => player.isFlying,
      onToggle: () => player.toggleFlying(),
      activeColor: GameConfig.colorFly,
      position: Vector2(vp.x - 265, vp.y - 120),
    );
    camera.viewport.add(flyButton);

    teleportButton = HudToggleButton(
      label: 'TP',
      isActive: () => player.teleportMode,
      onToggle: () => player.toggleTeleport(),
      activeColor: GameConfig.colorTeleport,
      position: Vector2(vp.x - 215, vp.y - 240),
    );
    camera.viewport.add(teleportButton);

    debugPrint('Entered ${worldDef.name} as ${playerStatus.name}');
  }

  /// Converts a point in viewport (screen-design) coords to world coords.
  Vector2 viewportToWorld(Vector2 viewportPoint) {
    final vp = viewSize;
    return camera.viewfinder.position +
        (viewportPoint - vp / 2) / camera.viewfinder.zoom;
  }

  /// Teleport to a point given in viewport coords (used by the tap layer).
  void teleportPlayerToViewportPoint(Vector2 viewportPoint) {
    if (!player.canTeleportNow) return;

    final half = GameConfig.playerSize / 2;
    final target = viewportToWorld(viewportPoint)
      ..clamp(
        Vector2.all(half),
        Vector2.all(worldDef.size - half),
      );
    player.teleportTo(target);
  }

  @override
  void update(double dt) {
    super.update(dt);
    player.moveDirection.setFrom(joystick.relativeDelta);

    // Keep the player inside the land.
    final half = GameConfig.playerSize / 2;
    player.position.clamp(
      Vector2.all(half),
      Vector2.all(worldDef.size - half),
    );
  }
}

/// Invisible full-screen layer. While teleport mode is on, tapping anywhere
/// that isn't a button/joystick teleports the player there.
class _TeleportTapLayer extends PositionComponent with TapCallbacks {
  _TeleportTapLayer({required this.game, required Vector2 viewSize})
    : super(size: viewSize, priority: -10);

  final DaoGame game;

  @override
  void onTapDown(TapDownEvent event) {
    if (!game.player.teleportMode) return;
    // localPosition is in viewport coords because this layer sits at (0,0).
    game.teleportPlayerToViewportPoint(event.localPosition);
  }
}