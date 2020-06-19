import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomIndicator extends StatelessWidget {
  final Color color;
  final double width;
  final bool showText;

  CustomIndicator({
    @required this.color,
    @required this.width,
    this.showText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SpinKitChasingDots(
          color: color,
          size: width * 0.6,
        ),
        SizedBox(height: width * 0.1),
        showText
            ? TyperAnimatedTextKit(
                text: ["Loading..."],
                textStyle: TextStyle(
                    color: color,
                    fontSize: width * 0.1,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
                speed: Duration(milliseconds: 200),
                textAlign: TextAlign.center,
                alignment:
                    AlignmentDirectional.topStart, // or Alignment.topLeft
              )
            : Container(),
      ],
    );
  }
}
