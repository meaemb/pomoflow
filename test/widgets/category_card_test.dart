import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomoflow/components/category_card.dart';
import 'package:pomoflow/models/category.dart';

Widget _wrapWithMaterial(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: ListView(
        children: [child],
      ),
    ),
  );
}

void main() {
  group('CategoryCard', () {
    final testCategory = Category(
      name: 'Work',
      count: 12,
      imageUrl: 'https://cdn-icons-png.flaticon.com/128/5578/5578703.png',
    );

    testWidgets('CategoryCard can build', (tester) async {
      await tester.pumpWidget(
        _wrapWithMaterial(CategoryCard(category: testCategory)),
      );

      expect(find.byType(CategoryCard), findsOneWidget);
      expect(find.text('Work'), findsOneWidget);
      expect(find.text('12 tips'), findsOneWidget);
    });
  });
}