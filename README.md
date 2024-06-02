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
const SizeTailoredText(
    text: text,
    textStyle: style,
    maxLines: 5,
);
~~~

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
