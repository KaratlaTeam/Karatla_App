import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirstPageView extends StatefulWidget {
  @override
  _FirstPageViewState createState() => _FirstPageViewState();
}
class _FirstPageViewState extends State<FirstPageView>{

  static const colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  static const colorizeTextStyle = TextStyle(
    fontSize: 20.0,
    fontFamily: 'Horizon',
  );

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300.0,
          child: AnimatedTextKit(
            animatedTexts: [
              ColorizeAnimatedText(
                'The Best House Manager',
                textStyle: colorizeTextStyle,
                textAlign: TextAlign.center,
                colors: colorizeColors,
              ),
            ],
            isRepeatingAnimation: true,
            repeatForever: true,
          ),
        ),
      ),
    );
  }
}