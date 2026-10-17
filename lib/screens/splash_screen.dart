import 'package:flutter/material.dart';

import '../app/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goNext();
  }

  Future<void> _goNext() async {
    // Give the user a moment to see the title.
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.mainMenu);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0E0E0E),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Dao of Freedom',
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                letterSpacing: 4,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 12),
            Text(
              '道 · 自 · 由',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 20,
                letterSpacing: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}