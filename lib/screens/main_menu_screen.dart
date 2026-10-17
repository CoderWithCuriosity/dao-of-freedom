import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app/game_state.dart';

import '../app/routes.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // watch → rebuild when GameState changes.
    final hasPlayer = context.watch<GameState>().hasPlayer;
    debugPrint(hasPlayer.toString());
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Dao of Freedom',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 48),
            _MenuButton(
              label: 'New Game',
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRoutes.characterCreation),
            ),
            const SizedBox(height: 16),
            _MenuButton(
              label: 'Continue',
              onTap: hasPlayer
                  ? () => Navigator.of(context).pushNamed(AppRoutes.game)
                  : null,
            ),
            const SizedBox(height: 16),
            _MenuButton(
              label: 'Quit',
              onTap: () => Navigator.of(context).maybePop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return SizedBox(
      width: 260,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: enabled ? Colors.white54 : Colors.white12),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: enabled ? Colors.white : Colors.white24,
            fontSize: 18,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
