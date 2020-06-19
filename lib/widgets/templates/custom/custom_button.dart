import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double height;
  final Color color;
  final Function onTap;
  final double iconSize;
  final IconData icon;
  final EdgeInsetsGeometry padding;

  CustomButton({
    @required this.onTap,
    @required this.height,
    @required this.color,
    @required this.iconSize,
    @required this.icon,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 15.0,
      shape: CircleBorder(),
      clipBehavior: Clip.hardEdge,
      color: Colors.white,
      child: Ink(
        height: height,
        width: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.4),
              color.withOpacity(0.7),
              color.withOpacity(1),
            ],
            stops: [0.1, 0.3, 0.6, 1],
          ),
        ),
        child: Container(
          child: InkWell(
            onTap: onTap,
            child: Container(
              width: height,
              height: height,
              alignment: Alignment.center,
              padding: padding,
              child: Icon(
                icon,
                size: iconSize,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
