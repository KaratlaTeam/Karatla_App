import 'package:flutter/material.dart';
import 'dart:ui';

class DataAppSizePlugin {

  double get height => _height ;
  double get width => _width ;
  double get pixelRatio => _pixelRatio;
  double get top => _top;
  double get scaleH => (_height-_top-_bottom)/(_oHeight-48-34);
  double get scaleW => _width/_oWidth;
  double get scaleFortSize {
    return scaleW/1.0;
  }
  double get bottom => _bottom;
  Brightness get brightness => _brightness;
  //对角尺寸未使用
  ///double get squareScale => _squareScale = math.sqrt(_height*_height+_width*_width)/math.sqrt(_oHeight*_oHeight+_oWidth*_oWidth);

  double _width ;
  double _height ;
  double _pixelRatio ;
  double _top;
  double _fontSizeScale;
  double _bottom;
  Brightness _brightness;
  ///double _squareScale;

  ///1792px     828px
  ///iphone 11
  ///326 ppi
  ///pixelRatio:2.0
  ///6.1 寸
  ///top:48dp
  ///bottom:34dp
  static const int _oHeight = 896;
  static const int _oWidth = 414;


  void getSizeData(){
    MediaQueryData _mediaQuery = MediaQueryData.fromWindow(window);
    this._height = _mediaQuery.size.height;
    this._width = _mediaQuery.size.width;
    this._pixelRatio = _mediaQuery.devicePixelRatio;
    this._top = _mediaQuery.padding.top;
    this._fontSizeScale = _mediaQuery.textScaleFactor;
    this._bottom = _mediaQuery.padding.bottom;
    this._brightness = _mediaQuery.platformBrightness;

    print("---------------------------New-------------------------");
    print("_height : $_height dp ${_height*_pixelRatio}px");
    print("_width : $_width dp ${_width*_pixelRatio}px");
    print("_pixelRatio: $_pixelRatio");
    print("scaleH: ${(_height-_top-_bottom)/(_oHeight-44-34)}");
    print("scaleW: ${_width/_oWidth}");
    print("scaleFortSize: ${scaleW/1.0}");
    print("_top: $_top dp");
    print("_bottom: $_bottom dp");
    print("");

    print("---------------------------Old-------------------------");
    print("iphone 11  6.1寸");
    print("_height : 896dp 1792px");
    print("_width : 414 dp 828px");
    print("_pixelRatio: 2.0");
    print("top: 48dp");
    print("bottom:34dp");
    print("");
  }
}