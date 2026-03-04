# size_tailored_text

A Flutter text widget that **automatically adjusts font size** so that text fits within the parent’s layout constraints and max lines without clipping or overflowing. Use it like `Text` while getting the largest font that fits the space. Wrap it in a `SizedBox`, `Container`, or similar to define the area.

## Features

- **Automatic font scaling**  
  Regardless of how large `style.fontSize` is, the widget shrinks it so the text fits within the **parent’s constraints** and **maxLines**.
- **Explicit newlines**  
  When `maxLines` > 1, newline characters (`\n`, `\r\n`) in the string are honored as line breaks. Font size is then adjusted so that the resulting lines fit within the given area.
- **Word-based line breaks**  
  Within each line (or paragraph, after applying explicit newlines), text is split on spaces so lines wrap at word boundaries and words are not broken in the middle.
- **Text-like API**  
  Most arguments from `Text` are supported: `style`, `textAlign`, `textDirection`, `maxLines`, `locale`, etc.
- **Overflow handling**  
  When text cannot fit even at `minFontSize`, you can control the look with `overflow` (e.g. ellipsis, fade, clip).
- **Long word breaking**  
  Optional splitting of long unbroken words at character boundaries so they fit within the available width (`breakLongWords`).
- **Bounded by parent**  
  If the parent gives unbounded constraints (`double.infinity`), the widget caps them using `MediaQuery` size so layout remains valid.

## Installation

Add to your `pubspec.yaml`, then run `flutter pub get`:

```yaml
dependencies:
  size_tailored_text: ^1.1.0
```

## Usage

Use it like the standard `Text` widget. The same arguments as `Text` are available, plus **font-tuning** options. The widget uses the parent’s constraints for the area; wrap in `SizedBox` or `Container` to set the size.

```dart
import 'package:size_tailored_text/size_tailored_text.dart';

// Fit to parent (e.g. inside a SizedBox)
SizedBox(
  width: 200,
  height: 200,
  child: SizeTailoredTextWidget(
    'Long text or large font will scale down to fit the area.',
    style: TextStyle(fontSize: 200, color: Colors.black, fontWeight: FontWeight.w800),
    maxLines: 5,
    minFontSize: 1,
    textAlign: TextAlign.left,
  ),
);
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|--------|-------------|
| `text` | `String` | (required) | The string to display. |
| `style` | `TextStyle?` | `DefaultTextStyle` | Text style. `fontSize` is used as the initial size; the widget may reduce it to fit. |
| `maxLines` | `int` | `1` | Maximum number of lines. |
| `minFontSize` | `double` | `8` | Minimum font size. The widget will not shrink below this. Must be > 0. |
| `overflow` | `TextOverflow` | `TextOverflow.ellipsis` | How to display when text still overflows at `minFontSize` (ellipsis, fade, clip, visible). |
| `breakLongWords` | `bool` | `true` | If true, long words with no spaces can be split at character boundaries to fit width. |
| `stepGranularity` | `double` | `0.5` | Step size when decreasing/increasing font. Smaller values give finer tuning. Must be > 0. |
| `textAlign` | `TextAlign?` | `TextAlign.start` | Horizontal alignment. |
| `textDirection` | `TextDirection?` | `null` | Text direction. |
| `locale` | `Locale?` | `null` | Locale. |
| `textScaler` | `TextScaler` | `TextScaler.noScaling` | Font scaling (e.g. accessibility). |
| `textWidthBasis` | `TextWidthBasis?` | `TextWidthBasis.parent` | Width basis. |
| `textHeightBehavior` | `TextHeightBehavior?` | `null` | Line height behavior. |

For details on the same arguments as `Text`, see the Flutter [Text](https://api.flutter.dev/flutter/widgets/Text-class.html) documentation.

## How it works

1. **Resolve area**  
   Uses the parent’s constraints from `LayoutBuilder`. If any axis is unbounded (`double.infinity`), it is capped with the corresponding `MediaQuery` size.
2. **Find font size**  
   Starts from `style.fontSize` (or a cached value from the previous build), then uses `TextPainter` to check for overflow and steps down by `stepGranularity` until the text fits within the area and `maxLines`.
3. **Line breaking**  
   The text is split on newlines (`\n`, `\r\n`) into paragraphs. Each paragraph is then word-wrapped: splits on whitespace and wraps when a line would exceed the available width. Long words can be split at character boundaries if `breakLongWords` is true. When `maxLines` is 1, newlines in the string are replaced with spaces so everything stays on one line.
4. **Overflow**  
   If the text still does not fit at `minFontSize`, it is rendered at `minFontSize` and the `overflow` property (e.g. ellipsis) is applied by the underlying `RichText`.
5. **Caching**  
   The chosen font size is stored in state and reused as the starting point on the next build to reduce repeated layout work.

## Example comparison

Comparison of `Text` vs `SizeTailoredTextWidget` in a constrained area (same text and style; `SizeTailoredTextWidget` scales to fit the parent).

<p align="center">
  <img alt="Text vs SizeTailoredTextWidget" src="https://aqoong.github.io/readme-assets/size-tailored-text/example.png" width="600"/>
</p>

## License

MIT License

Copyright (c) 2024 AQoong(cooldnjsdn@gmail.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
