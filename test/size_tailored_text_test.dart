import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:size_tailored_text/size_tailored_text.dart';

void main() {
  testWidgets(
    'Widget Test',
    (WidgetTester tester) async {
      final String text = List.generate(Random().nextInt(200), (index) => index).toString();
      const TextStyle textStyle = TextStyle(
        fontSize: 30,
      );
      print(text);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizeTailoredText(
              text: text,
              textStyle: textStyle,
              maxLines: Random().nextInt(10), // 테스트할 위젯을 여기에 넣습니다.
            ),
          ),
        ),
      );
      expect(find.byType(SizeTailoredText), findsOneWidget);
    },
  );
}
