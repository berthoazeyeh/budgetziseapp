import 'package:flutter/material.dart';

final class MyColors {
  const MyColors._();

  static const primary = Color(0xFF667eea); // Violet clair (boutons, focus)
  static const primaryDark = Color(0xFF764ba2); // Violet foncé (dégradé)
  static const primaryGradient = [primary, primaryDark];

  static const secondary = Color(0xFF191919); // inchangé
  static const white = Color(0xFFFFFFFF);
  static const lightGray = Color(0xFFF8FAFC);
  static const borderGray = Color(0xFFF1F5F9);
  static const darkGray = Color(0xFF64748B); // Texte secondaire
  static const darkerGray = Color(0xFF1E293B); // Titres foncés

  static const success = Color(0xFF10B981); // Vert succès
  static const warning = Color(0xFFF59E0B); // Orange
  static const danger = Color(0xFFEF4444); // Rouge
  static const info = Color(0xFF2563EB); // Bleu info
  static const purple = Color(0xFF7C3AED); // Violet supplémentaire

  static const lightSuccess = Color(0xFFECFDF5); // Fond succès
  static const lightDanger = Color(0xFFFEE2E2); // Fond erreur
  static const lightInfo = Color(0xFFEFF6FF); // Fond info
  static const lightWarning = Color(0xFFFFFBEB); // Fond warning
}
