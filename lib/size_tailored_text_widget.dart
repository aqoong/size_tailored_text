/*
 * Copyright (c) 2024. AQoong(cooldnjsdn@gmail.com) All rights reserved.
 */

import 'package:flutter/material.dart';

class SizeTailoredTextWidget extends StatefulWidget {
  final String text;

  final TextStyle? style;
  final int maxLines;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final TextScaler textScaler;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;

  final TextOverflow overflow;

  /// If true, long unbroken words can be split at character level
  /// (only used when maxLines > 1 in this implementation).
  final bool breakLongWords;

  final double stepGranularity;
  final double minFontSize;

  const SizeTailoredTextWidget(
      this.text, {
        super.key,
        this.style,
        this.maxLines = 1,
        this.textAlign,
        this.textDirection,
        this.locale,
        this.textScaler = TextScaler.noScaling,
        this.textWidthBasis,
        this.textHeightBehavior,
        this.overflow = TextOverflow.ellipsis,
        this.breakLongWords = true,
        this.minFontSize = 8,
        this.stepGranularity = 0.5,
      })  : assert(maxLines > 0, 'maxLines must be greater than 0'),
        assert(stepGranularity > 0, 'stepGranularity must be greater than 0'),
        assert(minFontSize > 0, 'minFontSize must be greater than 0');

  @override
  State<SizeTailoredTextWidget> createState() => _SizeTailoredTextWidgetState();
}

class _SizeTailoredTextWidgetState extends State<SizeTailoredTextWidget> {
  double? _cachedFontSize;

  @override
  Widget build(BuildContext context) {
    String clearedText = widget.text;
    if (widget.maxLines == 1 && widget.text.contains('\n')) {
      clearedText = widget.text.replaceAll('\n', ' ');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final rawMaxWidth = constraints.maxWidth;
        final rawMaxHeight = constraints.maxHeight;
        final mediaSize = MediaQuery.sizeOf(context);
        final maxWidth = rawMaxWidth.isFinite ? rawMaxWidth : mediaSize.width;
        final maxHeight = rawMaxHeight.isFinite ? rawMaxHeight : mediaSize.height;

        final effectiveStyle = widget.style ?? DefaultTextStyle.of(context).style;
        final initialStyleFontSize = effectiveStyle.fontSize ?? 14.0;

        double fontSize = _cachedFontSize != null
            ? _cachedFontSize!.clamp(widget.minFontSize, initialStyleFontSize)
            : initialStyleFontSize;

        TextSpan tempTextSpan = TextSpan(
          text: clearedText,
          style: effectiveStyle.copyWith(fontSize: fontSize),
        );

        bool foundFit = false;

        while (fontSize >= widget.minFontSize) {
          final newTextSpan = _buildSpanForMeasureAndRender(
            text: clearedText,
            style: effectiveStyle.copyWith(fontSize: fontSize),
            maxWidth: maxWidth,
          );

          if (_checkOverflow(
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            textSpan: newTextSpan,
          )) {
            fontSize -= widget.stepGranularity;
          } else {
            tempTextSpan = newTextSpan;
            foundFit = true;
            break;
          }
        }

        if (foundFit && fontSize < initialStyleFontSize) {
          double tryFontSize = fontSize + widget.stepGranularity;
          while (tryFontSize <= initialStyleFontSize) {
            final trySpan = _buildSpanForMeasureAndRender(
              text: clearedText,
              style: effectiveStyle.copyWith(fontSize: tryFontSize),
              maxWidth: maxWidth,
            );

            if (_checkOverflow(
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              textSpan: trySpan,
            )) {
              break;
            }
            fontSize = tryFontSize;
            tempTextSpan = trySpan;
            tryFontSize += widget.stepGranularity;
          }
        }

        if (!foundFit) {
          fontSize = widget.minFontSize;
          tempTextSpan = _buildSpanForMeasureAndRender(
            text: clearedText,
            style: effectiveStyle.copyWith(fontSize: fontSize),
            maxWidth: maxWidth,
          );
        }

        _cachedFontSize = fontSize;

        return RichText(
          text: tempTextSpan,
          overflow: widget.overflow,
          maxLines: widget.maxLines,
          textScaler: widget.textScaler,
          locale: widget.locale,
          textAlign: widget.textAlign ?? TextAlign.start,
          textWidthBasis: widget.textWidthBasis ?? TextWidthBasis.parent,
          textDirection: widget.textDirection,
          textHeightBehavior: widget.textHeightBehavior,
          softWrap: widget.maxLines > 1,
        );
      },
    );
  }

  /// maxLines==1: 절대 '\n'을 삽입하지 않는 단일 TextSpan을 반환
  /// maxLines>1: 기존처럼 줄바꿈 스팬을 만들되, 필요시 긴 단어를 문자 단위로 분해
  TextSpan _buildSpanForMeasureAndRender({
    required String text,
    required TextStyle style,
    required double maxWidth,
  }) {
    if (widget.maxLines == 1) {
      return TextSpan(text: text, style: style);
    }

    return TextSpan(
      children: _buildTextSpansMultiLine(
        text: text,
        style: style,
        maxWidth: maxWidth,
      ),
    );
  }

  bool _checkOverflow({
    required double maxWidth,
    required double maxHeight,
    required TextSpan textSpan,
  }) {
    final textPainter = TextPainter(
      text: textSpan,
      maxLines: widget.maxLines,
      ellipsis: widget.overflow == TextOverflow.ellipsis ? '…' : null,
      textDirection: widget.textDirection ?? TextDirection.ltr,
      textAlign: widget.textAlign ?? TextAlign.start,
      textWidthBasis: widget.textWidthBasis ?? TextWidthBasis.parent,
      textScaler: widget.textScaler,
      locale: widget.locale,
      textHeightBehavior: widget.textHeightBehavior,
    );

    textPainter.layout(maxWidth: maxWidth);

    return textPainter.height > maxHeight ||
        textPainter.maxIntrinsicWidth > maxWidth ||
        textPainter.didExceedMaxLines;
  }

  /// Multi-line only: honors explicit newlines and word-wraps.
  /// If [breakLongWords] is true, long unbroken words can be split by characters.
  List<TextSpan> _buildTextSpansMultiLine({
    required String text,
    required TextStyle style,
    required double maxWidth,
  }) {
    final paragraphs = text.split(RegExp(r'\r?\n'));
    final spans = <TextSpan>[];

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: widget.maxLines,
      ellipsis: widget.overflow == TextOverflow.ellipsis ? '…' : null,
      textAlign: widget.textAlign ?? TextAlign.start,
      textDirection: widget.textDirection ?? TextDirection.ltr,
      locale: widget.locale,
      textScaler: widget.textScaler,
      textWidthBasis: widget.textWidthBasis ?? TextWidthBasis.parent,
      textHeightBehavior: widget.textHeightBehavior,
    );

    for (var p = 0; p < paragraphs.length; p++) {
      final paragraph = paragraphs[p];
      final words = paragraph.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();

      if (words.isEmpty) {
        if (p < paragraphs.length - 1) spans.add(const TextSpan(text: '\n'));
        continue;
      }

      String currentLine = '';

      for (final word in words) {
        final testLine = currentLine.isEmpty ? word : '$currentLine $word';
        textPainter.text = TextSpan(text: testLine, style: style);
        textPainter.layout(maxWidth: maxWidth);

        final overflowed = textPainter.didExceedMaxLines || textPainter.maxIntrinsicWidth > maxWidth;

        if (!overflowed) {
          currentLine = testLine;
          continue;
        }

        if (currentLine.isNotEmpty) {
          spans.add(TextSpan(text: currentLine, style: style));
          spans.add(const TextSpan(text: '\n'));
          currentLine = '';
        }

        if (!widget.breakLongWords) {
          currentLine = word;
          continue;
        }

        // Split long unbroken word by characters
        String chunk = '';
        for (final ch in word.characters) {
          final candidate = '$chunk$ch';
          textPainter.text = TextSpan(text: candidate, style: style);
          textPainter.layout(maxWidth: maxWidth);

          final charOverflowed = textPainter.maxIntrinsicWidth > maxWidth;

          if (charOverflowed && chunk.isNotEmpty) {
            spans.add(TextSpan(text: chunk, style: style));
            spans.add(const TextSpan(text: '\n'));
            chunk = ch;
          } else {
            chunk = candidate;
          }
        }
        currentLine = chunk;
      }

      if (currentLine.isNotEmpty) {
        spans.add(TextSpan(text: currentLine, style: style));
      }

      if (p < paragraphs.length - 1) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return spans;
  }
}