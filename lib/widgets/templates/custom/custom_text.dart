import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double width;
  final double velocity;
  final double height;
  final Color color;

  CustomText({
    @required this.text,
    this.width = -1,
    this.velocity = 25,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = TextStyle(
      fontSize: height,
      fontWeight: FontWeight.bold,
      color: color,
    );

    bool addMarquee() {
      final double titleWidth = getTextSize(this.text, textStyle).width;

      return width > 0 && titleWidth > width;
    }

    return addMarquee()
        ? Container(
            child: Marquee(
              text: text,
              scrollAxis: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.center,
              blankSpace: width * 0.2,
              velocity: velocity,
              style: textStyle,
            ),
          )
        : RichText(
            text: TextSpan(
              text: text,
              style: textStyle,
            ),
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.fade,
          );
  }

  Size getTextSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textScaleFactor: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}
