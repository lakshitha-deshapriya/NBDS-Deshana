import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class CustomNeumorphicButton extends StatelessWidget {
  final Function onTap;
  final double height;
  final NeumorphicBoxShape shape;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final double intensity;
  final double depth;

  CustomNeumorphicButton({
    @required this.shape,
    @required this.icon,
    @required this.height,
    @required this.onTap,
    @required this.backgroundColor,
    this.color = Colors.blueGrey,
    this.intensity = 10,
    this.depth = 3,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      padding: EdgeInsets.zero,
      drawSurfaceAboveChild: true,
      onClick: onTap,
      child: Container(
        padding: EdgeInsets.all(height * 0.3),
        child: Icon(
          icon,
          color: color,
          size: height,
        ),
      ),
      boxShape: shape,
      style: NeumorphicStyle(
        color: backgroundColor,
        shape: NeumorphicShape.convex,
        shadowLightColor: Colors.transparent,
        intensity: intensity,
        depth: depth,
      ),
    );
  }
}
