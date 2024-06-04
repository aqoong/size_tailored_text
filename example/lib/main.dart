import 'package:flutter/material.dart';
import 'package:size_tailored_text/size_tailored_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const text = '안녕하세요. 이것은 긴 문자열 테스트입니다. Hello. This is Long String test. Hello. This is Long String test. Hello. This is Long String test.';
    const style = TextStyle(
      fontSize: 210,
      overflow: TextOverflow.fade,
      color: Colors.black,
      fontWeight: FontWeight.w800,
      height: 1.2,
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizeTailoredText(
                text: text,
                textStyle: style,
                maxLines: 5,
                textAlign: TextAlign.start,
              ),
              borderContainer(const Text(text, style: style)),
              borderContainer(const SizeTailoredText(
                text: text,
                textStyle: style,
                maxLines: 3,
                textAlign: TextAlign.center,
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget borderContainer(Widget child) => Container(
        width: double.infinity,
        height: 200,
        decoration: const BoxDecoration(
            border: Border.fromBorderSide(BorderSide(color: Colors.red))),
        child: child,
      );
}
