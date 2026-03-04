import 'package:flutter/material.dart';
import 'package:size_tailored_text/size_tailored_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SizeTailoredTextWidget Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  bool useTextHeightBehavior = true;

  // 문제 재현/회귀 확인용: 한글/영문 descender/기호/이모지 혼합
  final samples = const <String>[
    '짧은 제목',
    '조금 더 긴 제목입니다 (받침 포함) 값이 낮습니다',
    'English descenders: gypq jjj WWW',
    'Numbers & symbols: (12.34%) - [TEST] / A-B_C',
    'Emoji mix 😀😅🔥 + 한글 혼합 테스트',
    'VeryVeryVeryLongUnbrokenWordToForceShrinkOrOverflowBehavior',
    '안녕하세요 개행이 포함된 문자열입니다.'
  ];

  TextHeightBehavior get thb => const TextHeightBehavior(
    applyHeightToFirstAscent: false,
    applyHeightToLastDescent: false,
  );

  @override
  Widget build(BuildContext context) {
    final effectiveThb = useTextHeightBehavior ? thb : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SizeTailoredTextWidget Demo'),
        actions: [
          Row(
            children: [
              const Text('textHeightBehavior'),
              Switch(
                value: useTextHeightBehavior,
                onChanged: (v) => setState(() => useTextHeightBehavior = v),
              ),
              const SizedBox(width: 8),
            ],
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '각 카드에서 왼쪽은 고정 Text, 오른쪽은 SizeTailoredTextWidget 입니다.\n'
                'Switch로 textHeightBehavior on/off 비교하세요.',
          ),
          const SizedBox(height: 16),
          ...samples.map((s) => _caseCard(context, s, effectiveThb)),
        ],
      ),
    );
  }

  Widget _caseCard(BuildContext context, String text, TextHeightBehavior? thb) {
    // width가 좁을수록 shrink가 잘 발생하므로 일부러 폭을 제한
    const cardWidth = 260.0;
    const cardHeight = 80.0;

    final baseStyle = const TextStyle(
      fontSize: 24,
      height: 1,
      letterSpacing: -0.1,
      fontWeight: FontWeight.w600,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: cardWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Text (reference)', style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 6),
                  Container(
                    width: cardWidth,
                    height: cardHeight,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: baseStyle,
                      textHeightBehavior: thb,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: cardWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('SizeTailoredTextWidget', style: TextStyle(fontSize: 12)),
                  const SizedBox(height: 6),
                  Container(
                    width: cardWidth,
                    height: cardHeight,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SizeTailoredTextWidget(
                      text,
                      maxLines: 1,
                      style: baseStyle.copyWith(color: Colors.black),
                      textHeightBehavior: thb,
                      // breakLongWords: false,
                      minFontSize: 8,
                      stepGranularity: 0.5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}