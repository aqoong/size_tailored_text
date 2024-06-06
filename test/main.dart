import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:size_tailored_text/size_tailored_text.dart';

void main() {
  test('Sample test', () {
    final String text = List.generate(Random().nextInt(500), (index) => index).toString();
    final TextStyle textStyle = TextStyle(
      fontSize: 10,
    );
    expect(SizeTailoredText(text: text, textStyle: textStyle, maxLines: Random().nextInt(10),), 'expected output');
  });
}