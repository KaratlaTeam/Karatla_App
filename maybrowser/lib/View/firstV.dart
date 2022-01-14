import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 250.0,
              child: TextLiquidFill(
                text: 'Welcome to',
                waveColor: Colors.blueAccent,
                boxBackgroundColor: Colors.white,
                textStyle: GoogleFonts.oswald(
                  fontSize: 60.0,
                  fontWeight: FontWeight.bold,
                ),
                boxHeight: 300.0,
              ),
            ),

            SizedBox(
              width: 250.0,
              child: DefaultTextStyle(
                style: GoogleFonts.rubikBeastly(
                  fontSize: 90,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 7.0,
                      color: Colors.pink,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    FlickerAnimatedText('MAY'),
                    FlickerAnimatedText('MAY'),
                    FlickerAnimatedText("MAY!"),
                  ],
                  onTap: () {
                    print("Tap Event");
                  },
                ),
              ),
            ),

          ],
        ),
      )
    );
  }
}