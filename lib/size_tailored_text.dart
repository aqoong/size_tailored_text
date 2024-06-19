/*
 * Copyright (c) 2024. AQoong(cooldnjsdn@gmail.com) All rights reserved.
 */
library size_tailored_text;

import 'package:flutter/material.dart';

class SizeTailoredText extends StatelessWidget {
  /// If the [style] argument is null, the text will use the style from the
  /// closest enclosing [DefaultTextStyle].
  ///
  final String text;

  ///Size([width], [height]) can be adjusted independently by setting the Widget area.
  ///If null, it matches the size of the parent area.
  final double? width;
  final double? height;

  final TextStyle? style;
  final int maxLines;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final TextScaler textScaler;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;

  /// [stepGranularity] argument is The coefficient that controls the fontSize.
  /// The smaller the value, the more sophisticated it works.
  final double stepGranularity;

  /// You can set the minimum fontSize.
  /// If it does not get smaller than [minFontSize]
  /// If overflow occurs, the letters are no longer visible.
  final double minFontSize;

  const SizeTailoredText(
    this.text, {
    Key? key,
    this.width,
    this.height,
    this.style,
    this.maxLines = 1,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.textScaler = TextScaler.noScaling,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.minFontSize = 8,
    this.stepGranularity = 0.5,
  })  : assert(maxLines > 0, 'maxLines must be greater than 0'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = width ?? constraints.maxWidth;
      final maxHeight = height ?? constraints.maxHeight;
      final TextStyle effectiveStyle =
          style ?? DefaultTextStyle.of(context).style;
      double fontSize = effectiveStyle.fontSize!;
      late TextSpan tempTextSpan;

      while (fontSize - stepGranularity >= minFontSize) {
        tempTextSpan = TextSpan(
          children: _buildTextSpans(
              text: text,
              style: effectiveStyle.copyWith(fontSize: fontSize),
              maxWidth: maxWidth),
        );

        if (_checkOverflow(
            maxWidth: maxWidth, maxHeight: maxHeight, textSpan: tempTextSpan)) {
          fontSize -= stepGranularity;
        } else {
          break;
        }
      }

      return RichText(
        text: tempTextSpan,
        textScaler: textScaler,
        locale: locale,
        maxLines: maxLines,
        textAlign: textAlign ?? TextAlign.start,
        textWidthBasis: textWidthBasis ?? TextWidthBasis.parent,
        textDirection: textDirection,
        textHeightBehavior: textHeightBehavior,
      );
    });
  }

  bool _checkOverflow(
      {required double maxWidth,
      required double maxHeight,
      required TextSpan textSpan}) {
    final TextPainter textPainter = TextPainter(
      text: textSpan,
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.start,
      textWidthBasis: TextWidthBasis.parent,
    );

    textPainter.layout(maxWidth: maxWidth);

    final lineMetrics = textPainter.computeLineMetrics();
    final lineHeight = lineMetrics.isNotEmpty ? lineMetrics.first.height : 0;

    bool isOverflowing = textPainter.height > maxHeight ||
        textPainter.maxIntrinsicWidth > maxWidth ||
        textPainter.didExceedMaxLines ||
        lineHeight * maxLines < textPainter.height;

    return isOverflowing;
  }

  List<TextSpan> _buildTextSpans(
      {required String text,
      required TextStyle style,
      required double maxWidth}) {
    final words = text.split(' '); // 공백으로 분리된 단어 리스트
    final spans = <TextSpan>[];

    String currentLine = '';

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: maxLines,
      textAlign: textAlign ?? TextAlign.start,
      textDirection: textDirection ?? TextDirection.ltr,
      locale: locale,
      textScaler: textScaler,
      textWidthBasis: TextWidthBasis.parent,
    );

    for (var word in words) {
      String testLine = currentLine.isEmpty ? word : '$currentLine $word';
      textPainter.text = TextSpan(text: testLine, style: style);
      textPainter.layout(maxWidth: maxWidth);

      if (textPainter.didExceedMaxLines ||
          textPainter.maxIntrinsicWidth > maxWidth) {
        if (currentLine.isNotEmpty) {
          spans.add(TextSpan(text: currentLine, style: style));
          spans.add(const TextSpan(text: '\n'));
        }
        currentLine = word;
      } else {
        currentLine = testLine;
      }
    }

    if (currentLine.isNotEmpty) {
      spans.add(TextSpan(text: currentLine, style: style));
    }

    return spans;
  }
}
