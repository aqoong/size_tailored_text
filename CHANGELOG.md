## 0.0.1

pre-release version

### features

* Automatically adjust the fontSize to a size that does not exceed the size of the parent Widget.
* Supports rewriting that prevents the word in the string from breaking.

## 0.0.3

pre-release version

### changes

* Resolving the issue where the textAlign option is not applied.

## 0.1.0

* Refactor main logic
* Check overflow in all areas horizontally and vertically

## 1.0.0

* Update "How to Use" in README.md

## 1.0.1

* Increased the scope of supported versions.

## 1.0.3

* Expand and release the supported platforms for reasons that do not use the Platform SDK.

## 1.0.4
* Modified to replace all newline characters (\n) with spaces in the text when maxLines is set to 1, ensuring the text is displayed on a single line.

## 1.0.5
* Clean the file path & dart formatted

## 1.0.6
* Improved the stability of the temporary variable used for size adjustment.

## 1.0.7

### Bug fixes
* **Overflow fallback:** When no font size fits within the given area, the widget now renders with `minFontSize` and proper line breaks instead of the initial large single-line text (which could appear broken or clipped).
* **Measurement vs rendering:** Overflow checks now use the same `textDirection`, `textAlign`, `textScaler`, `locale`, `textHeightBehavior`, and `textWidthBasis` as the widget, so layout measurement matches actual rendering (e.g. RTL and scaled text).
* **Null safety:** Replaced `effectiveStyle.fontSize!` with `effectiveStyle.fontSize ?? 14.0` to avoid runtime errors when `fontSize` is null.
* **Word splitting:** Split on any whitespace (`RegExp(r'\s+)`) and ignore empty segments; return a single span when the text is only whitespace.

### Changes
* **Loop condition:** Use `while (fontSize >= minFontSize)` so the minimum font size is always tried once.
* **Infinite constraints:** When `width` or `height` is `double.infinity`, the widget now uses `MediaQuery.sizeOf(context).width` or `height` as an upper bound to avoid layout issues.
* **Performance:** Converted to `StatefulWidget` and cache the last computed font size (`_cachedFontSize`) to use as the starting point on the next build, reducing repeated layout calculations. Removed unused cache fields (`_lastMaxWidth`, `_lastMaxHeight`, `_lastText`).
* **Maximum font:** After finding a fitting size from cache, the widget now tries increasing the font step-by-step so the largest fitting font is used when constraints are unchanged.

## 1.0.8
* README.md update

## 1.0.9

### Changes
* **Explicit newlines:** When `maxLines` > 1, newline characters (`\n`, `\r\n`) in the text are now honored as line breaks. The widget splits the string into paragraphs by newlines, word-wraps each paragraph to the given width, and then adjusts font size so the result fits. When `maxLines` is 1, newlines are still replaced with spaces so the text stays on a single line.

## 1.1.0

### ⚠️ Breaking change (important)

* **`width` and `height` parameters are removed.**  
  The widget no longer accepts explicit `width` or `height`. It always uses the **parent’s layout constraints** (from `LayoutBuilder`). To limit the area, wrap `SizeTailoredTextWidget` in a widget that provides bounded constraints (e.g. `SizedBox`, `Container`, `ConstrainedBox`). Unbounded constraints (`double.infinity`) are still capped using `MediaQuery` size.

### Added
* **`overflow`** (`TextOverflow`, default `TextOverflow.ellipsis`): When the text still does not fit at `minFontSize`, the rendered `RichText` uses this to show ellipsis, fade, clip, or visible overflow.
* **`breakLongWords`** (bool, default `true`): When a word has no spaces and is wider than the available width, the widget can split it at character boundaries to fit. Set to `false` to keep long words unsplit (overflow is then handled by `overflow`).

### Changes
* **Assertions:** `stepGranularity` and `minFontSize` must be greater than zero.
* **Overflow:** When text does not fit at `minFontSize`, the widget renders at `minFontSize` and relies on `RichText`'s `overflow` for the final appearance.
