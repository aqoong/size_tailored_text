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
    const text =
        '안녕하세요.dfdsafdsafsd dsff next time.\nplugin example app test Nice Weather in Earth. 입니다!\nAnother point is empty empty....확인용입니다.';
    const style = TextStyle(
      fontSize: 50,
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
              SizeTailoredTextWidget(
                text,
                width: 200,
                height: 200,
                maxLines: 5,
                minFontSize: 1,
                style: style,
              ),
              SizedBox(
                width: 200,
                height: 200,
                child: Text(
                  text,
                  maxLines: 5,
                  style: style,
                  overflow: TextOverflow.fade,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
