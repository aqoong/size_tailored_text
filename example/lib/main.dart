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
    const text = '안녕하세요.dfdsafdsafsd dsff next time. plugin example app test Nice Weather in Earth. 입니다!';
    const style = TextStyle(
      fontSize: 100,
      overflow: TextOverflow.fade,
      color: Colors.black,
      fontWeight: FontWeight.w800,
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizeTailoredText(
                text,
                width: 200,
                height: 200,
                maxLines: 5,
                minFontSize: 1,
                textAlign: TextAlign.left,
                style: style,
              ),
              Text(
                text,
                maxLines: 5,
                style: style,

              ),
              // borderContainer(const Text(text, style: style)),
              // SizeTailoredText(
              //   text: text,
              //   textStyle: style,
              //   maxWidth: 100,
              //   maxHeight: 100,
              //   maxLines: 6,
              //   textAlign: TextAlign.start,
              // )
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
