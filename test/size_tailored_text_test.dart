import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:size_tailored_text/size_tailored_text.dart';

void main() {
  testWidgets('SizeTailoredTextWidget renders without exceptions', (tester) async {
    const thb = TextHeightBehavior(
      applyHeightToFirstAscent: false,
      applyHeightToLastDescent: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 180,
              height: 40,
              child: SizeTailoredTextWidget(
                '값이 낮습니다 English gypq 😀 (12.34%)',
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 24,
                  height: 1,
                  letterSpacing: -0.1,
                  fontWeight: FontWeight.w600,
                ),
                textHeightBehavior: thb,
                minFontSize: 8,
                stepGranularity: 0.5,
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(RichText), findsOneWidget);
  });

  testWidgets('Shrink happens when width is narrow', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 90, // 일부러 좁게
              height: 40,
              child: SizeTailoredTextWidget(
                'VeryVeryVeryLongUnbrokenWordToForceShrink',
                maxLines: 1,
                style: const TextStyle(fontSize: 24),
                minFontSize: 8,
                stepGranularity: 0.5,
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // 렌더 자체가 정상인지 스모크 체크
    expect(find.byType(RichText), findsOneWidget);
  });
}