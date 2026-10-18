import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flame/experimental.dart';

import '../core/game_config.dart';
import '../models/player_status.dart';
import 'components/ground.dart';
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

  @override
  Color backgroundColor() => worldDef.voidColor;

  @override
  Future<void> onLoad() async {
    final designH = GameConfig.designHeightFor(size);
    final aspect = size.x / size.y;

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

    debugPrint('Entered ${worldDef.name} as ${playerStatus.name}');
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