import 'package:flutter/material.dart';

import '../../models/gender.dart';

class GenderToggle extends StatelessWidget {
  const GenderToggle({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final PlayerGender value;
  final ValueChanged<PlayerGender> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x33FFFFFF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _GenderPill(
            label: 'Male',
            icon: Icons.male,
            active: value == PlayerGender.male,
            onTap: () => onChanged(PlayerGender.male),
          ),
          _GenderPill(
            label: 'Female',
            icon: Icons.female,
            active: value == PlayerGender.female,
            onTap: () => onChanged(PlayerGender.female),
          ),
        ],
      ),
    );
  }
}

class _GenderPill extends StatelessWidget {
  const _GenderPill({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF7FDBFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 16,
                color: active ? Colors.black : Colors.white54),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: active ? Colors.black : Colors.white54,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}