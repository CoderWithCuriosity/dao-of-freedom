import 'package:flutter/material.dart';

/// Colors used by HUD widgets. Kept in one place so the whole HUD
/// restyles from here.
class HudTheme {
  HudTheme._();

  // Panel
  static const Color panelBg = Color(0xCC0E0E0E); // semi-transparent
  static const Color panelBorder = Color(0x33FFFFFF);
  static const Color avatarBg = Color(0xFF1F2A36);
  static const Color avatarBorder = Color(0xFF7FDBFF);

  // Text
  static const Color titleText = Color(0xFFEDEDED);
  static const Color mutedText = Color(0xFF9AA4B2);

  // Bars
  static const Color healthBar = Color(0xFFE85C5C);
  static const Color healthBarBg = Color(0x332A0F0F);
  static const Color qiBar = Color(0xFF5CC8E8);
  static const Color qiBarBg = Color(0x33203040);
}