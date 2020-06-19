import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:transparent_image/transparent_image.dart';

class AlbumCover extends StatefulWidget {
  final String coverUrl;
  final bool animate;
  final double height;

  AlbumCover(this.coverUrl, this.height, {this.animate = false});

  @override
  _AlbumCoverState createState() => _AlbumCoverState();
}

class _AlbumCoverState extends State<AlbumCover> with TickerProviderStateMixin {
  AnimationController controllerPlayer;
  Animation<double> animationPlayer;
  final _commonTween = new Tween<double>(begin: 0.0, end: 1.0);

  @override
  initState() {
    super.initState();

    controllerPlayer = new AnimationController(
        duration: const Duration(milliseconds: 15000), vsync: this);
    if (widget.animate) {
      animationPlayer =
          new CurvedAnimation(parent: controllerPlayer, curve: Curves.linear);
      animationPlayer.addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            controllerPlayer.repeat();
          } else if (status == AnimationStatus.dismissed) {
            controllerPlayer.forward();
          }
        },
      );
    }
  }

  @override
  void dispose() {
    if (widget.animate) {
      controllerPlayer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animate) {
      if (widget.coverUrl != null) {
        controllerPlayer.forward();
      } else {
        controllerPlayer.stop(canceled: false);
      }
    }
    return RotationTransition(
      turns: _commonTween.animate(controllerPlayer),
      child: AspectRatio(
        aspectRatio: 1,
        child: Neumorphic(
          style: NeumorphicStyle(
              depth: 10,
              intensity: 20,
              shadowLightColor: Colors.transparent,
              color: Colors.lightBlueAccent.withOpacity(0.1),
              border: NeumorphicBorder(
                  color: Colors.lightBlueAccent.withOpacity(0.5)),
              shape: NeumorphicShape.convex),
          boxShape: NeumorphicBoxShape.circle(),
          child: Neumorphic(
            margin: EdgeInsets.all(widget.height * 0.02),
            boxShape: NeumorphicBoxShape.circle(),
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: widget.coverUrl,
              fit: BoxFit.fill,
            ),
            style: NeumorphicStyle(
              color: Colors.lightBlueAccent.withOpacity(0.1),
              depth: -5,
              shape: NeumorphicShape.convex,
            ),
          ),
        ),
      ),
    );
  }
}
