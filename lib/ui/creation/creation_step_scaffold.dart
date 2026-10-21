import 'package:flutter/material.dart';

/// Shared layout for one wizard step.
class CreationStepScaffold extends StatelessWidget {
  const CreationStepScaffold({
    super.key,
    required this.stepLabel,
    required this.title,
    required this.subtitle,
    required this.child,
    required this.onBack,
    required this.onNext,
    this.nextLabel = 'Next',
    this.nextEnabled = true,
    this.showBack = true,
  });

  final String stepLabel; // e.g. "Step 1 of 4"
  final String title;
  final String subtitle;
  final Widget child;
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final String nextLabel;
  final bool nextEnabled;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stepLabel.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF7FDBFF),
              fontSize: 11,
              letterSpacing: 3,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w300,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white38, fontSize: 13),
          ),
          const SizedBox(height: 24),
          Expanded(child: child),
          const SizedBox(height: 16),
          Row(
            children: [
              if (showBack)
                TextButton(
                  onPressed: onBack,
                  child: const Text(
                    'Back',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              const Spacer(),
              FilledButton(
                onPressed: nextEnabled ? onNext : null,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF7FDBFF),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 14),
                ),
                child: Text(
                  nextLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}