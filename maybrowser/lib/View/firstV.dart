import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FirstV extends StatelessWidget{
  FirstV({
    Key? key,
}):super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: Get.width*0.5,
          child: Image.asset('assets/images/May_logo.png'),
        ),
      )
    );
  }
}