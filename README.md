# size_tailored_text

A Flutter text widget that **automatically adjusts font size** so that text fits within the given width, height, and max lines without clipping or overflowing. Use it like `Text` while getting the largest font that fits the space.

## Features

- **Automatic font scaling**  
  Regardless of how large `style.fontSize` is, the widget shrinks it so the text fits within **width**, **height**, and **maxLines**.
- **Word-based line breaks**  
  Text is split on spaces so lines wrap at word boundaries and words are not broken in the middle.
- **Text-like API**  
  Most arguments from `Text` are supported: `style`, `textAlign`, `textDirection`, `maxLines`, `locale`, etc.
- **Infinite constraints**  
  If `width` or `height` is `double.infinity`, that axis is capped using the corresponding size from `MediaQuery`.

## Installation

Add to your `pubspec.yaml`, then run `flutter pub get`:

```yaml
dependencies:
  size_tailored_text: ^1.0.7
```

## Usage

Use it like the standard `Text` widget. The same arguments as `Text` are available, plus **size** and **font-tuning** options.

```dart
import 'package:size_tailored_text/size_tailored_text.dart';

// Basic: fit to parent size
SizeTailoredTextWidget(
  'Your string here',
  style: TextStyle(fontSize: 50, color: Colors.black),
  maxLines: 5,
  textAlign: TextAlign.left,
);

// Fixed area: fit inside width × height
SizeTailoredTextWidget(
  'Long text or large font will scale down to fit the area.',
  width: 200,
  height: 200,
  style: TextStyle(fontSize: 200, color: Colors.black, fontWeight: FontWeight.w800),
  maxLines: 5,
  minFontSize: 1,
  textAlign: TextAlign.left,
);
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|--------|-------------|
| `text` | `String` | (required) | The string to display. |
| `width` | `double?` | `null` | Maximum width. `null` uses parent's `maxWidth`; `infinity` uses `MediaQuery.sizeOf(context).width`. |
| `height` | `double?` | `null` | Maximum height. `null` uses parent's `maxHeight`; `infinity` uses `MediaQuery.sizeOf(context).height`. |
| `style` | `TextStyle?` | `DefaultTextStyle` | Text style. `fontSize` is used as the initial size; the widget may reduce it to fit. |
| `maxLines` | `int` | `1` | Maximum number of lines. |
| `minFontSize` | `double` | `8` | Minimum font size. The widget will not shrink below this. |
| `stepGranularity` | `double` | `0.5` | Step size when decreasing/increasing font. Smaller values give finer tuning. |
| `textAlign` | `TextAlign?` | `TextAlign.start` | Horizontal alignment. |
| `textDirection` | `TextDirection?` | `null` | Text direction. |
| `locale` | `Locale?` | `null` | Locale. |
| `textScaler` | `TextScaler` | `TextScaler.noScaling` | Font scaling (e.g. accessibility). |
| `textWidthBasis` | `TextWidthBasis?` | `TextWidthBasis.parent` | Width basis. |
| `textHeightBehavior` | `TextHeightBehavior?` | `null` | Line height behavior. |

For details on the same arguments as `Text`, see the Flutter [Text](https://api.flutter.dev/flutter/widgets/Text-class.html) documentation.

## How it works

1. **Resolve area**  
   Uses `width` / `height` when provided; otherwise uses the constraints from `LayoutBuilder`. Any `infinity` axis is capped with the corresponding `MediaQuery` size.
2. **Find font size**  
   Starts from `style.fontSize` (or a cached value from the previous build), then uses `TextPainter` to check for overflow and steps down by `stepGranularity` until the text fits within the area and `maxLines`.
3. **Line breaking**  
   Splits on whitespace and wraps when a line would exceed `width`.
4. **Caching**  
   The chosen font size is stored in state and reused as the starting point on the next build to reduce repeated layout work.

## Example comparison

Below, standard `Text` vs `SizeTailoredTextWidget` in a fixed-size area.

<table style="border-collapse: collapse; border: 1px solid #dddddd;">
    <tr>
        <td>
            <img alt="" src="https://aqoong.github.io/readme-assets/size-tailored-text/stt_no_sized.png" width="350"/>
        </td>
        <td>
            <pre><code>SizeTailoredTextWidget(
  text,
  maxLines: 5,
  minFontSize: 1,
  textAlign: TextAlign.left,
  style: style,
);
Text(
  text,
  maxLines: 5,
  textAlign: TextAlign.left,
  style: style,
);</code></pre>
        </td>
    </tr>
    <tr>
        <td>
            <img alt="" src="https://aqoong.github.io/readme-assets/size-tailored-text/stt_sized.png" width="350"/>
        </td>
        <td>
            <pre><code>SizeTailoredTextWidget(
  text,
  width: 200,
  height: 200,
  maxLines: 5,
  minFontSize: 1,
  textAlign: TextAlign.left,
  style: style,
);
SizedBox(
  width: 200,
  height: 200,
  child: Text(
    text,
    maxLines: 5,
    textAlign: TextAlign.left,
    style: style,
  ),
);</code></pre>
        </td>
    </tr>
</table>

## License

MIT License

Copyright (c) 2024 AQoong(cooldnjsdn@gmail.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
