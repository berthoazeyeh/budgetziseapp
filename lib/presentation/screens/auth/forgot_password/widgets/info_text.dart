import 'package:flutter/material.dart';

class InfoText extends StatelessWidget {
  final String title;
  final String description;
  final String footerText;

  const InfoText({
    super.key,
    required this.title,
    required this.description,
    required this.footerText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Icon container
        Container(
          width: 80,
          height: 80,
          margin: const EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: Text('🔐', style: TextStyle(fontSize: 36)),
          ),
        ),

        // Title
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 16),

        // Description
        Text(
          description,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 16,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 30),

        // Footer text (appears at bottom)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            footerText,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
