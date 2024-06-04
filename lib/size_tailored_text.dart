/*
 * Copyright (c) 2024. AQoong(cooldnjsdn@gmail.com) All rights reserved.
 */
library size_tailored_text;

import 'package:flutter/material.dart';

class SizeTailoredText extends StatefulWidget {
  final String text;
  final double calRefSize; //사이즈 조정 수치
  final TextStyle textStyle;

  final int maxLines;
  final Locale? locale;
  final Color? selectionColor;
  final String? semanticsLabel;
  final bool softWrap;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final TextScaler textScaler;
  final TextHeightBehavior? textHeightBehavior;
  final TextWidthBasis textWidthBasis;

  const SizeTailoredText({
    super.key,
    required this.text,
    required this.textStyle,
    this.calRefSize = 0.5,
    this.maxLines = 1,
    this.textDirection,
    this.textAlign,
    this.semanticsLabel,
    this.selectionColor,
    this.locale,
    this.softWrap = true,
    this.strutStyle,
    this.textHeightBehavior,
    this.textScaler = TextScaler.noScaling,
    this.textWidthBasis = TextWidthBasis.parent,
  });

  @override
  State<SizeTailoredText> createState() => _SizeTailoredTextState();
}

class _SizeTailoredTextState extends State<SizeTailoredText> {
  double _changedFontSize = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(SizeTailoredText oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    _changedFontSize = widget.textStyle.fontSize ?? 14;

    return LayoutBuilder(
      builder: (context, constraints) {
        double fontSize = _changedFontSize;
        final TextStyle style = _commonTextStyle();
        final textPainter = _commonTextPainter();

        while (true) {
          textPainter.layout(maxWidth: constraints.maxWidth);

          if (textPainter.didExceedMaxLines) {
            fontSize -= widget.calRefSize;
            if (fontSize <= 0) break;
            textPainter.text =
                TextSpan(text: widget.text, style: style.copyWith(fontSize: fontSize));
          } else {
            break;
          }
        }
        _changedFontSize = fontSize;

        return RichText(
          text: TextSpan(
            children: _buildTextSpans(
              widget.text,
              style.copyWith(fontSize: fontSize),
              constraints.maxWidth,
            ),
          ),
          textAlign: widget.textAlign ?? TextAlign.start,
          textHeightBehavior: widget.textHeightBehavior,
          strutStyle: widget.strutStyle,
          softWrap: widget.softWrap,
          textWidthBasis: widget.textWidthBasis,
          textDirection: widget.textDirection,
          selectionColor: widget.selectionColor,
          locale: widget.locale,
          maxLines: widget.maxLines,
        );
      },
    );
  }

  TextStyle _commonTextStyle() => widget.textStyle.copyWith(
      fontSize: _changedFontSize,
      height: widget.textStyle.height ?? 1,
      letterSpacing: widget.textStyle.letterSpacing ?? 1,
      wordSpacing: widget.textStyle.wordSpacing ?? 1);

  TextPainter _commonTextPainter() => TextPainter(
    text: TextSpan(text: widget.text, style: _commonTextStyle()),
    maxLines: widget.maxLines,
    textDirection: widget.textDirection ?? TextDirection.ltr,
    textScaler: widget.textScaler,
    locale: widget.locale,
    strutStyle: widget.strutStyle,
    textAlign: widget.textAlign ?? TextAlign.start,
    textHeightBehavior: widget.textHeightBehavior,
    textWidthBasis: widget.textWidthBasis,
  );

  List<TextSpan> _buildTextSpans(String text, TextStyle style, double maxWidth) {
    final words = text.split(' '); // 공백으로 분리된 단어 리스트
    final spans = <TextSpan>[];

    final textPainter = _commonTextPainter();

    String currentLine = '';

    for (var word in words) {
      String testLine = currentLine.isEmpty ? word : '$currentLine $word';
      textPainter.text = TextSpan(text: testLine, style: style);
      textPainter.layout(maxWidth: maxWidth);

      if (textPainter.didExceedMaxLines || textPainter.width >= maxWidth) {
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
