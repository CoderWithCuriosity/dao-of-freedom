import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app/game_state.dart';
import '../game/dao_game.dart';
import '../game/worlds/world_registry.dart';
import '../ui/hud/player_stats_bar.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  DaoGame? _game;
  String? _loadedWorldId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.watch<GameState>();
    final status = state.playerStatus;

    if (status == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.of(context).pushReplacementNamed('/menu');
      });
      return;
    }

    // (Re)create the game when first entering or when the world changes.
    if (_game == null || _loadedWorldId != state.currentWorldId) {
      _loadedWorldId = state.currentWorldId;
      _game = DaoGame(
        playerStatus: status,
        worldDef: WorldRegistry.byId(state.currentWorldId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final game = _game;
    if (game == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0E0E0E),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final state = context.watch<GameState>();

    return Scaffold(
      body: Stack(
        children: [
          GameWidget(key: ValueKey(_loadedWorldId), game: game),

          // HUD, top-left
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: state.playerStatus == null
                    ? const SizedBox.shrink()
                    : PlayerStatsBar(status: state.playerStatus!),
              ),
            ),
          ),

          // World switcher, top-right
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xCC0E0E0E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0x33FFFFFF)),
                  ),
                  child: DropdownButton<String>(
                    value: state.currentWorldId,
                    underline: const SizedBox.shrink(),
                    dropdownColor: const Color(0xFF1A1A1A),
                    style: const TextStyle(color: Colors.white70),
                    items: WorldRegistry.all
                        .map((w) => DropdownMenuItem(
                              value: w.id,
                              child: Text(w.name),
                            ))
                        .toList(),
                    onChanged: (id) {
                      if (id != null) {
                        context.read<GameState>().setWorld(id);
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}