# size_tailored_text

Size the text to the size of the parent widget.

### Feature
* No matter how large the FontSize is, **reset the fontSize** based on the width of the parent widget and the set maxLines.
* Support word-break functionality so words don't break.

## How to Use

It's similar to using a typical Text Widget.  
Inputable arguments are left open the same as the arguments in Text Widget.
~~~

final text = "Strings Strings...";
final style = TextStyle(
    ...
    fontSize: 200,
    color: Colors.balck,
    ...
);
SizeTailoredText(
    ...
    text,
    width: 200,
    height: 200,
    style: style,
    maxLines: 5,
    minFontSize: 1,
    textAlign: TextAlign.left,
    ...
),

~~~

## Example

<table style="border-collapse: collapse;border: 1px solid #dddddd;">
    <tr>
        <td>
            <img alt="" src="https://aqoong.github.io/readme-assets/size-tailored-text/stt_no_sized.png" width="350"/>
        </td>
        <td>
            <pre><code>
SizeTailoredText(
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
            <pre><code>
SizeTailoredText(text,
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

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
