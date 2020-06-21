import 'dart:math';

import 'package:dharma_deshana/constant/app_constant.dart';
import 'package:dharma_deshana/provider/carousel_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class DraggableButton extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget appBar;
  final double widgetWidth;

  DraggableButton({
    @required this.child,
    @required this.widgetWidth,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    final CarouselProvider provider =
        Provider.of<CarouselProvider>(context, listen: false);
    return Selector<CarouselProvider, Tuple2<double, double>>(
      selector: (_, provider) => Tuple2(provider.left, provider.top),
      builder: (_, tuple, draggable) => Stack(
        children: [
          Positioned(
            left: tuple.item1,
            top: tuple.item2,
            child: draggable,
          ),
        ],
      ),
      child: Draggable(
        child: child,
        feedback: child,
        onDragEnd: (details) {
          _handleDragEnded(context, details, provider);
        },
        childWhenDragging: Container(
          width: 0.0,
          height: 0.0,
        ),
      ),
    );
  }

  void _handleDragEnded(BuildContext context, DraggableDetails drag,
      CarouselProvider provider) {
    if (!provider.isMetaInit) {
      Size size = MediaQuery.of(context).size;
      provider.setMetaData(
        size.width,
        size.height -
            (appBar != null ? appBar.preferredSize.height : 0.0) -
            AppConstant.navbarHeight,
        Size(widgetWidth, widgetWidth),
      );
    }
    final double width = provider.width;
    final double height = provider.height;
    final Size widSize = provider.widSize;

    final Offset offset = drag.offset;

    switch (_getAnchor(offset, width, height)) {
      case Anchor.LEFT_FIRST:
        provider.setWidgetLocation(
            widSize.width / 2, max(widSize.height / 2, offset.dy));
        break;
      case Anchor.TOP_FIRST:
        provider.setWidgetLocation(
            max(widSize.width / 2, offset.dx), widSize.height / 2);
        break;
      case Anchor.RIGHT_SECOND:
        provider.setWidgetLocation(
            width - widSize.width, max(widSize.height, offset.dy));
        break;
      case Anchor.TOP_SECOND:
        provider.setWidgetLocation(
            min(width - widSize.width, offset.dx), widSize.height / 2);
        break;
      case Anchor.LEFT_THIRD:
        provider.setWidgetLocation(
            widSize.width / 2, min(height - widSize.height, offset.dy));
        break;
      case Anchor.BOTTOM_THIRD:
        provider.setWidgetLocation(
            max(widSize.width / 2, offset.dx), height - widSize.height);
        break;
      case Anchor.RIGHT_FOURTH:
        provider.setWidgetLocation(
            width - widSize.width, min(height - widSize.height, offset.dy));
        break;
      case Anchor.BOTTOM_FOURTH:
        provider.setWidgetLocation(
            max(min(width - widSize.width, offset.dx), offset.dx),
            height - widSize.height);
        break;
    }
  }

  Anchor _getAnchor(Offset position, double width, double height) {
    if (position.dx < width / 2 && position.dy < height / 2) {
      return position.dx < position.dy ? Anchor.LEFT_FIRST : Anchor.TOP_FIRST;
    } else if (position.dx >= width / 2 && position.dy < height / 2) {
      return width - position.dx < position.dy
          ? Anchor.RIGHT_SECOND
          : Anchor.TOP_SECOND;
    } else if (position.dx < width / 2 && position.dy >= height / 2) {
      return position.dx < height - position.dy
          ? Anchor.LEFT_THIRD
          : Anchor.BOTTOM_THIRD;
    } else {
      return width - position.dx < height - position.dy
          ? Anchor.RIGHT_FOURTH
          : Anchor.BOTTOM_FOURTH;
    }
  }
}

enum Anchor {
  LEFT_FIRST,
  TOP_FIRST,
  RIGHT_SECOND,
  TOP_SECOND,
  LEFT_THIRD,
  BOTTOM_THIRD,
  RIGHT_FOURTH,
  BOTTOM_FOURTH
}
