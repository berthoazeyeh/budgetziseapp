import 'package:budget_zise/budget_zise.dart';
import 'package:flutter/material.dart';

class FeaturesRow extends StatelessWidget {
  final List<String> features = [
    LocaleKeys.home_feature_row1.tr(),
    LocaleKeys.home_feature_row2.tr(),
  ];
  final List<String> features1 = [
    LocaleKeys.home_feature_row3.tr(),
    LocaleKeys.home_feature_row4.tr(),
  ];

  FeaturesRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 15,
      children: [
        Row(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: features.map((text) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.40,
              padding: const EdgeInsets.all(0),
              child: Row(
                children: [
                  const Icon(Icons.check_box, color: Colors.green, size: 20),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        Row(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: features1.map((text) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.40,
              padding: const EdgeInsets.all(0),
              child: Row(
                children: [
                  const Icon(Icons.check_box, color: Colors.green, size: 20),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
