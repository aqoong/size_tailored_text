// This is a basic Flutter widget test for the SizeTailoredTextWidget demo app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:size_tailored_text_example/main.dart';

void main() {
  testWidgets('Demo page renders app bar, switch and comparison cards', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('SizeTailoredTextWidget Demo'), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);
    // ListView only builds visible cards; just check the first sample renders.
    expect(find.text('짧은 제목'), findsWidgets);
    expect(find.byType(Card), findsWidgets);
  });

  testWidgets('Scrolling reveals every sample card', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.text('안녕하세요 개행이 포함된 문자열입니다.'),
      200,
      scrollable: find.byType(Scrollable),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('Toggling textHeightBehavior switch does not throw', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(Card), findsWidgets);
  });
}
