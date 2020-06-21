import 'package:flutter/material.dart';

class CarouselProvider extends ChangeNotifier {

  double _left;
  double _top;

  double _width;
  double _height;
  Size _widgetSize;
  bool _metaInitialized = false;

  double get left => _left;
  double get top => _top;

  double get width => _width;
  double get height => _height;
  Size get widSize => _widgetSize;
  bool get isMetaInit => _metaInitialized;

  setWidgetLocation(double left, double top) {
    _left = left;
    _top = top;
    notifyListeners();
  }

  setMetaData(double width, double height, Size widgetSize){
    _width = width;
    _height = height;
    _widgetSize = widgetSize;
    _metaInitialized = true;
  }
}
