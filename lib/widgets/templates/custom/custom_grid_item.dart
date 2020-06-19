import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:transparent_image/transparent_image.dart';

class CustomGridItem extends StatelessWidget {
  final String title;
  final Function onTap;
  final String image;
  final double height;

  CustomGridItem({
    @required this.title,
    @required this.onTap,
    @required this.height,
    @required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      onClick: () {},
      pressed: false,
      duration: Duration(seconds: 0),
      minDistance: 5,
      drawSurfaceAboveChild: true,
      padding: EdgeInsets.zero,
      child: Material(
        type: MaterialType.transparency,
        child: Ink(
          child: InkWell(
            highlightColor: Colors.lightBlueAccent.withOpacity(0.1),
            onTap: onTap,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: height * 0.13,
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent.withOpacity(0.1),
                      border: Border.all(
                          width: height * 0.005, color: Colors.white),
                      shape: BoxShape.circle,
                    ),
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: ClipOval(
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: image,
                          width: height * 0.13,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: height * 0.035,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      style: NeumorphicStyle(
        color: Colors.transparent,
        surfaceIntensity: 0.4,
        depth: 7,
        shape: NeumorphicShape.convex,
        intensity: 30,
        shadowLightColor: Colors.transparent,
      ),
    );
  }
}
