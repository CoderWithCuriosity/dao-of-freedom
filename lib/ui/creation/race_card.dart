import 'package:flutter/material.dart';

import '../../models/gender.dart';
import '../../models/race.dart';

/// One clickable race card. Shows the portrait, name, and a one-line
/// identity. Selected cards get a glowing border + slight scale up.
class RaceCard extends StatelessWidget {
  const RaceCard({
    super.key,
    required this.profile,
    required this.gender,
    required this.selected,
    required this.onTap,
    this.width = 160,
    this.height = 260,
  });

  final RaceProfile profile;
  final PlayerGender gender;
  final bool selected;
  final VoidCallback? onTap;
  final double width;
  final double height;

  /// Maps race+gender to the asset path.
  static String assetFor(PlayerRace race, PlayerGender gender) {
    final folder = switch (race) {
      PlayerRace.human => 'human',
      PlayerRace.demon => 'demon',
      PlayerRace.spirit => 'spirit',
      PlayerRace.halfBlood => 'halfblood',
      PlayerRace.immortal => 'immortal',
    };
    final g = gender == PlayerGender.male ? 'male' : 'female';
    return 'assets/images/card/characters/$folder/${folder}_${g}_card.jpg';
  }

  @override
  Widget build(BuildContext context) {
    final locked = !profile.startsUnlocked;
    final accent = _accentFor(profile.race);

    return GestureDetector(
      onTap: locked ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        width: width,
        height: height,
        transform: Matrix4.identity()..scale(selected ? 1.05 : 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? accent : const Color(0x33FFFFFF),
            width: selected ? 2.5 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: accent.withAlpha(120),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ]
              : null,
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A1A), Color(0xFF0A0A0A)],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(13),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Portrait
              Image.asset(
                assetFor(profile.race, gender),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFF222222),
                  alignment: Alignment.center,
                  child: const Icon(Icons.broken_image,
                      color: Colors.white24, size: 40),
                ),
              ),

              // Dark gradient at bottom so text is readable
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.55, 1.0],
                      colors: [
                        Colors.transparent,
                        Colors.black.withAlpha(220),
                      ],
                    ),
                  ),
                ),
              ),

              // Locked overlay
              if (locked)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withAlpha(160),
                    alignment: Alignment.center,
                    child: const Icon(Icons.lock,
                        color: Colors.white38, size: 36),
                  ),
                ),

              // Name + tagline
              Positioned(
                left: 10,
                right: 10,
                bottom: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      profile.displayName,
                      style: TextStyle(
                        color: locked ? Colors.white38 : Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      profile.identity,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: locked ? Colors.white24 : Colors.white60,
                        fontSize: 10,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),

              // Selected check badge
              if (selected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: accent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check,
                        color: Colors.black, size: 16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  static Color _accentFor(PlayerRace race) => switch (race) {
        PlayerRace.human => const Color(0xFF7FDBFF),
        PlayerRace.demon => const Color(0xFFFF6B6B),
        PlayerRace.spirit => const Color(0xFFB388FF),
        PlayerRace.halfBlood => const Color(0xFFFFC857),
        PlayerRace.immortal => const Color(0xFFFFE082),
      };
}