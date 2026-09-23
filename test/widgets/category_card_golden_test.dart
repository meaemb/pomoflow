import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:pomoflow/components/category_card.dart';
import 'package:pomoflow/models/category.dart';

void main() {
  final categories = [
    Category(name: 'Work', count: 12, imageUrl: ''),
    Category(name: 'Study', count: 10, imageUrl: ''),
    Category(name: 'Coding', count: 8, imageUrl: ''),
  ];

  testGoldens('CategoryCard - Light Theme', (tester) async {
    final builder = GoldenBuilder.grid(columns: 2, widthToHeightRatio: 0.9)
      ..addScenario('Work', CategoryCard(category: categories[0]))
      ..addScenario('Study', CategoryCard(category: categories[1]))
      ..addScenario('Coding', CategoryCard(category: categories[2]));

    await tester.pumpWidgetBuilder(
      builder.build(),
      wrapper: materialAppWrapper(theme: ThemeData.light()),
    );

    await screenMatchesGolden(tester, 'category_card_light');
  });

  testGoldens('CategoryCard - Dark Theme', (tester) async {
    final builder = GoldenBuilder.grid(columns: 2, widthToHeightRatio: 0.9)
      ..addScenario('Work', CategoryCard(category: categories[0]))
      ..addScenario('Study', CategoryCard(category: categories[1]));

    await tester.pumpWidgetBuilder(
      builder.build(),
      wrapper: materialAppWrapper(theme: ThemeData.dark()),
    );

    await screenMatchesGolden(tester, 'category_card_dark');
  });
}