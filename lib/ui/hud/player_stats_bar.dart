import 'package:flutter/material.dart';

import '../../models/player_status.dart';
import 'hud_theme.dart';

/// The top-left RPG HUD card: avatar, name, realm, HP, Qi.
class PlayerStatsBar extends StatelessWidget {
  const PlayerStatsBar({super.key, required this.status});

  final PlayerStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: HudTheme.panelBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: HudTheme.panelBorder, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _Avatar(initial: _initial(status.name)),
          const SizedBox(width: 12),
          _InfoColumn(status: status),
        ],
      ),
    );
  }

  static String _initial(String name) {
    final trimmed = name.trim();
    return trimmed.isEmpty ? '?' : trimmed[0].toUpperCase();
  }
}

// ─── Avatar ──────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initial});

  final String initial;

  @override
  Widget build(BuildContext context) {
    // Placeholder for a real portrait. Swap the child for an
    // Image.asset when you have art.
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: HudTheme.avatarBg,
        shape: BoxShape.circle,
        border: Border.all(color: HudTheme.avatarBorder, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          color: HudTheme.avatarBorder,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─── Name + realm + bars ─────────────────────────────────────────────

class _InfoColumn extends StatelessWidget {
  const _InfoColumn({required this.status});

  final PlayerStatus status;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Name + realm chip
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              status.name,
              style: const TextStyle(
                color: HudTheme.titleText,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(width: 8),
            _RealmChip(status: status),
          ],
        ),
        const SizedBox(height: 6),

        // HP bar
        _StatBar(
          label: 'HP',
          current: status.health.current,
          max: status.health.max,
          fillColor: HudTheme.healthBar,
          bgColor: HudTheme.healthBarBg,
        ),
        const SizedBox(height: 4),

        // Qi bar
        _StatBar(
          label: 'Qi',
          current: status.qi.current,
          max: status.qi.max,
          fillColor: HudTheme.qiBar,
          bgColor: HudTheme.qiBarBg,
        ),
      ],
    );
  }
}

// ─── Realm chip ──────────────────────────────────────────────────────

class _RealmChip extends StatelessWidget {
  const _RealmChip({required this.status});

  final PlayerStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0x227FDBFF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0x557FDBFF)),
      ),
      child: Text(
        '${_realmLabel(status.realm.name)} · ${_subStageLabel(status.subStage.name)}',
        style: const TextStyle(
          color: HudTheme.avatarBorder,
          fontSize: 11,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static String _realmLabel(String raw) {
    // qiCondensation -> Qi Condensation
    return raw
        .replaceAllMapped(RegExp(r'[A-Z]'), (m) => ' ${m.group(0)}')
        .trim()
        .split(' ')
        .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  static String _subStageLabel(String raw) {
    if (raw.isEmpty) return raw;
    return raw[0].toUpperCase() + raw.substring(1);
  }
}

// ─── A single bar ────────────────────────────────────────────────────

class _StatBar extends StatelessWidget {
  const _StatBar({
    required this.label,
    required this.current,
    required this.max,
    required this.fillColor,
    required this.bgColor,
  });

  final String label;
  final double current;
  final double max;
  final Color fillColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    final ratio = max <= 0 ? 0.0 : (current / max).clamp(0.0, 1.0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 22,
          child: Text(
            label,
            style: const TextStyle(
              color: HudTheme.mutedText,
              fontSize: 10,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: 140,
          height: 10,
          child: Stack(
            children: [
              // Track
              Container(
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              // Fill
              FractionallySizedBox(
                widthFactor: ratio,
                child: Container(
                  decoration: BoxDecoration(
                    color: fillColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 62,
          child: Text(
            '${current.toStringAsFixed(0)}/${max.toStringAsFixed(0)}',
            style: const TextStyle(
              color: HudTheme.mutedText,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }
}