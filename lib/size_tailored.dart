/*
 * Copyright (c) 2024. AQoong(cooldnjsdn@gmail.com) All rights reserved.
 */

import 'package:flutter/material.dart';

class SizeTailored extends StatelessWidget {
  final String text;
  final double? width;
  final double? height;
  final TextStyle? style;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final double textScaleFactor;
  final TextOverflow? textOverflow;
  final TextScaler textScaler;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final double stepGranularity;
  final double minFontSize;

  const SizeTailored(
    this.text, {
    Key? key,
    this.width,
    this.height,
    this.style,
    this.maxLines,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.textOverflow,
    @Deprecated(
      'Use textScaler instead. '
      'Use of textScaleFactor was deprecated in preparation for the upcoming nonlinear text scaling support. '
      'This feature was deprecated after v3.12.0-2.0.pre.',
    )
    this.textScaleFactor = 1.0,
    this.textScaler = TextScaler.noScaling,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.minFontSize = 8,
    this.stepGranularity = 0.5,
  }) : super(key: key);

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
        final textPainter = TextPainter(
          text: TextSpan(
              text: text, style: effectiveStyle.copyWith(fontSize: fontSize)),
          maxLines: maxLines,
          textAlign: textAlign ?? TextAlign.start,
          textDirection: textDirection ?? TextDirection.ltr,
          locale: locale,
          textScaleFactor: textScaleFactor,
          textScaler: textScaler,
          textWidthBasis: TextWidthBasis.parent,
        );

        tempTextSpan = TextSpan(
            children: _buildTextSpans(
                text: text, textPainter: textPainter, maxWidth: maxWidth));

        if (_checkOverflow(
            maxWidth: maxWidth, maxHeight: maxHeight, textSpan: tempTextSpan)) {
          fontSize -= stepGranularity;
        } else {
          break;
        }
      }

      return RichText(
        text: tempTextSpan,
        overflow: textOverflow ?? TextOverflow.clip,
        textScaleFactor: textScaleFactor,
        textScaler: textScaler,
        locale: locale,
        maxLines: maxLines,
        softWrap: true,
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
      maxLines: null,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.start,
      textWidthBasis: TextWidthBasis.parent,
    );

    textPainter.layout(maxWidth: maxWidth);

    bool isOverflowing =
        textPainter.size.height > maxHeight || textPainter.didExceedMaxLines;
    return isOverflowing;
  }

  List<TextSpan> _buildTextSpans(
      {required String text,
      required TextPainter textPainter,
      required double maxWidth}) {
    final words = text.split(' '); // 공백으로 분리된 단어 리스트
    final spans = <TextSpan>[];

    String currentLine = '';

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
