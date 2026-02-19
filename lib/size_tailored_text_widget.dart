/*
 * Copyright (c) 2024. AQoong(cooldnjsdn@gmail.com) All rights reserved.
 */

import 'package:flutter/material.dart';

class SizeTailoredTextWidget extends StatefulWidget {
  /// If the [style] argument is null, the text will use the style from the
  /// closest enclosing [DefaultTextStyle].
  ///
  final String text;

  ///Size([width], [height]) can be adjusted independently by setting the Widget area.
  ///If null, it matches the size of the parent area.
  ///[double.infinity] is replaced with the current MediaQuery size (width/height).
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

  const SizeTailoredTextWidget(
    this.text, {
    super.key,
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
  }) : assert(maxLines > 0, 'maxLines must be greater than 0');

  @override
  State<SizeTailoredTextWidget> createState() => _SizeTailoredTextWidgetState();
}

class _SizeTailoredTextWidgetState extends State<SizeTailoredTextWidget> {
  /// 다음 [build]에서 폰트 탐색 시작점으로 사용해 재계산 횟수를 줄임.
  double? _cachedFontSize;

  @override
  Widget build(BuildContext context) {
    String clearedText = widget.text;
    if (widget.maxLines == 1 && widget.text.contains('\n')) {
      clearedText = widget.text.replaceAll('\n', ' ');
    }

    return LayoutBuilder(builder: (context, constraints) {
      final rawMaxWidth = widget.width ?? constraints.maxWidth;
      final rawMaxHeight = widget.height ?? constraints.maxHeight;
      final mediaSize = MediaQuery.sizeOf(context);
      final maxWidth = rawMaxWidth.isFinite ? rawMaxWidth : mediaSize.width;
      final maxHeight = rawMaxHeight.isFinite ? rawMaxHeight : mediaSize.height;

      final TextStyle effectiveStyle =
          widget.style ?? DefaultTextStyle.of(context).style;
      final double initialStyleFontSize = effectiveStyle.fontSize ?? 14.0;

      // 이전 빌드에서 찾은 폰트가 있으면 그 값을 시작점으로 사용해 재계산 횟수 감소
      double fontSize = _cachedFontSize != null
          ? _cachedFontSize!.clamp(widget.minFontSize, initialStyleFontSize)
          : initialStyleFontSize;

      TextSpan tempTextSpan = TextSpan(
        text: clearedText,
        style: effectiveStyle.copyWith(fontSize: fontSize),
      );

      bool foundFit = false;
      while (fontSize >= widget.minFontSize) {
        final newTextSpan = TextSpan(
          children: _buildTextSpans(
              text: clearedText,
              style: effectiveStyle.copyWith(fontSize: fontSize),
              maxWidth: maxWidth),
        );

        if (_checkOverflow(
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            textSpan: newTextSpan)) {
          fontSize -= widget.stepGranularity;
        } else {
          tempTextSpan = newTextSpan;
          foundFit = true;
          break;
        }
      }

      // 캐시 히트 후 여유가 있으면 한 단계씩 올려 최대 허용 폰트로 맞춤
      if (foundFit && fontSize < initialStyleFontSize) {
        double tryFontSize = fontSize + widget.stepGranularity;
        while (tryFontSize <= initialStyleFontSize) {
          final trySpan = TextSpan(
            children: _buildTextSpans(
                text: clearedText,
                style: effectiveStyle.copyWith(fontSize: tryFontSize),
                maxWidth: maxWidth),
          );
          if (_checkOverflow(
              maxWidth: maxWidth,
              maxHeight: maxHeight,
              textSpan: trySpan)) {
            break;
          }
          fontSize = tryFontSize;
          tempTextSpan = trySpan;
          tryFontSize += widget.stepGranularity;
        }
      }

      // 루프가 오버플로우 상태로 끝나면, 최소 폰트로 줄바꿈만 적용해 표시
      if (!foundFit && fontSize < initialStyleFontSize) {
        tempTextSpan = TextSpan(
          children: _buildTextSpans(
              text: clearedText,
              style: effectiveStyle.copyWith(fontSize: widget.minFontSize),
              maxWidth: maxWidth),
        );
        fontSize = widget.minFontSize;
      }

      _cachedFontSize = fontSize;

      return RichText(
        text: tempTextSpan,
        textScaler: widget.textScaler,
        locale: widget.locale,
        maxLines: widget.maxLines,
        textAlign: widget.textAlign ?? TextAlign.start,
        textWidthBasis: widget.textWidthBasis ?? TextWidthBasis.parent,
        textDirection: widget.textDirection,
        textHeightBehavior: widget.textHeightBehavior,
      );
    });
  }

  bool _checkOverflow(
      {required double maxWidth,
      required double maxHeight,
      required TextSpan textSpan}) {
    final TextPainter textPainter = TextPainter(
      text: textSpan,
      maxLines: widget.maxLines,
      textDirection: widget.textDirection ?? TextDirection.ltr,
      textAlign: widget.textAlign ?? TextAlign.start,
      textWidthBasis: widget.textWidthBasis ?? TextWidthBasis.parent,
      textScaler: widget.textScaler,
      locale: widget.locale,
      textHeightBehavior: widget.textHeightBehavior,
    );

    textPainter.layout(maxWidth: maxWidth);

    final lineMetrics = textPainter.computeLineMetrics();
    final lineHeight = lineMetrics.isNotEmpty ? lineMetrics.first.height : 0;

    bool isOverflowing = textPainter.height > maxHeight ||
        textPainter.maxIntrinsicWidth > maxWidth ||
        textPainter.didExceedMaxLines ||
        lineHeight * widget.maxLines < textPainter.height;

    return isOverflowing;
  }

  List<TextSpan> _buildTextSpans(
      {required String text,
      required TextStyle style,
      required double maxWidth}) {
    final words = text.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
    if (words.isEmpty) return [TextSpan(text: text, style: style)];
    final spans = <TextSpan>[];

    String currentLine = '';

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: widget.maxLines,
      textAlign: widget.textAlign ?? TextAlign.start,
      textDirection: widget.textDirection ?? TextDirection.ltr,
      locale: widget.locale,
      textScaler: widget.textScaler,
      textWidthBasis: widget.textWidthBasis ?? TextWidthBasis.parent,
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
