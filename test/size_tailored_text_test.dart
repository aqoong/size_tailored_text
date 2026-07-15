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

    final richText = tester.widget<RichText>(find.byType(RichText));
    final renderedFontSize = (richText.text as TextSpan).style?.fontSize;
    expect(renderedFontSize, lessThan(24));
  });

  testWidgets('No shrink is applied when there is enough room', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 400,
              height: 100,
              child: SizeTailoredTextWidget(
                'Short text',
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

    final richText = tester.widget<RichText>(find.byType(RichText));
    final renderedFontSize = (richText.text as TextSpan).style?.fontSize;
    expect(renderedFontSize, 24);
  });

  testWidgets('Font size grows back after the available width increases', (tester) async {
    double width = 60;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: StatefulBuilder(
              builder: (context, setState) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: width,
                    height: 40,
                    child: const SizeTailoredTextWidget(
                      'Short text',
                      maxLines: 1,
                      style: TextStyle(fontSize: 24),
                      minFontSize: 8,
                      stepGranularity: 0.5,
                    ),
                  ),
                  TextButton(
                    onPressed: () => setState(() => width = 400),
                    child: const Text('widen'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    final richTextFinder = find.descendant(
      of: find.byType(SizeTailoredTextWidget),
      matching: find.byType(RichText),
    );

    await tester.pumpAndSettle();
    final shrunkFontSize = ((tester.widget<RichText>(richTextFinder).text) as TextSpan).style?.fontSize;
    expect(shrunkFontSize, lessThan(24));

    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();

    final grownFontSize = ((tester.widget<RichText>(richTextFinder).text) as TextSpan).style?.fontSize;
    expect(grownFontSize, 24);
  });
}