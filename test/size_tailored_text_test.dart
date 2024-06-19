import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:size_tailored_text/size_tailored_text.dart';

void main() {
  testWidgets(
    'Widget Test',
    (WidgetTester tester) async {
      final String text = List.generate(Random().nextInt(100), (index) => index).toString();
      const TextStyle textStyle = TextStyle(
        fontSize: 30,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizeTailoredText(
              text,
              style: textStyle,
              maxLines: Random().nextInt(10) + 1
            ),
          ),
        ),
      );
      expect(find.byType(SizeTailoredText), findsOneWidget);
    },
  );
}
