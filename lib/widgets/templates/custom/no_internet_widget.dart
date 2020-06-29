import 'package:dharma_deshana/widgets/templates/templates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class NoInternetWidget extends StatelessWidget {
  final double height;

  NoInternetWidget({@required this.height});
  @override
  Widget build(BuildContext context) {
    final width = Templates.getWidth(context);

    return Container(
      height: height,
      child: Neumorphic(
        margin: EdgeInsets.symmetric(
          vertical: height * 0.08,
          horizontal: width * 0.02,
        ),
        boxShape: NeumorphicBoxShape.roundRect(
          BorderRadius.circular(height * 0.15),
        ),
        style: NeumorphicStyle(
          depth: 10,
          intensity: 0.8,
          shape: NeumorphicShape.convex,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.redAccent.withOpacity(0.7),
                Colors.redAccent.withOpacity(0.8),
                Colors.redAccent.withOpacity(0.9),
              ],
              stops: [0.2, 0.6, 0.8],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Feather.wifi_off,
                color: Colors.white,
                size: height * 0.45,
              ),
              SizedBox(width: width * 0.04),
              Text(
                'No Internet Connection',
                overflow: TextOverflow.fade,
                softWrap: false,
                maxLines: 1,
                style: TextStyle(
                  fontSize: height * 0.3,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
