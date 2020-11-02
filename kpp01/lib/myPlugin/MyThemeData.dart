import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';

import './dataAppSizePlugin.dart';
import 'package:flutter/material.dart';

class MyThemeData {
  final int index;
  final DataAppSizePlugin dataAppSizeModel;
  MyThemeData({
    this.index,
    this.dataAppSizeModel,
});

  ThemeData get themeDataLight => _getThemeDataLight(index, dataAppSizeModel);
  ThemeData get themeDataDark => _getThemeDataDark(index, dataAppSizeModel);
  Color get myThemeColor => _myThemeColor;
  Color get scaffoldColor => _scaffoldColor;
  Color get mySkyBlue => _mySkyBlue;
  Color get unSelectColor => _unSelectColor;
  Color get myGreyBlue => _myGreyBlue;
  Color get myWhiteBlue => _myWhiteBlue;

  static const MaterialColor _ThemeDataLightColor = MaterialColor(_myThemeColorInt, _colorWhite,);
  static const MaterialColor _ThemeDataDarkColor = MaterialColor(_primaryColorBlack, _colorBlack,);

  static const int _myThemeColorInt = 0xFF87CEFA;
  static const Color _myThemeColor = _mySkyBlue;
  static const Color _scaffoldColor = _myWhiteBlue;
  static const Color _unSelectColor = _myGreyBlue;

  static const int _primaryColorWhite = 0xFFFFFFFF;///白色
  static const int _primaryColorBlack = 0xFF000000;///黑色

  static const Color _mySkyBlue = Color(0xFF87CEFA);///  天蓝
  static const Color _myGreyBlue = Color(0xFFcadfec);/// 藏蓝
  static const Color _myWhiteBlue = Color(0xFFF4F8FB);/// 白蓝色

  static const Map<int , Color> _colorWhite ={
    50: const Color(0xFFFF5722),
    100: const Color(0xFFFF5722),
    200: _myGreyBlue,///进度条背景色,输入标颜色,光标选择时颜色
    300: _myThemeColor,///textSelectionHandleColor
    400: const Color(0xFFFF5722),
    500: const Color(_myThemeColorInt),///控制tab横线,进度条，ios textSelectionHandleColor,
    600: const Color(0xFFFF5722),
    700: const Color(0xFFFF5722),
    800: const Color(0xFFFF5722),
    900: const Color(0xFFFF5722),
  };

  /// not use!
  static const Map<int , Color> _colorBlack ={
    50: const Color(0xFFFF5722),
    100: const Color(0xFFFF5722),
    200: _myGreyBlue,///进度条背景色,输入标颜色,光标选择时颜色
    300: _myThemeColor,///textSelectionHandleColor
    400: const Color(0xFFFF5722),
    500: const Color(_myThemeColorInt),///控制tab横线,进度条，ios textSelectionHandleColor,
    600: const Color(0xFFFF5722),
    700: const Color(0xFFFF5722),
    800: const Color(0xFFFF5722),
    900: const Color(0xFFFF5722),
  };

  _getThemeDataLight(int index, DataAppSizePlugin dataAppSizeModel) {
    switch (index) {
      case 0:
        {
          return ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            primarySwatch: _ThemeDataLightColor,
            primaryColor: _myThemeColor,
            primaryColorBrightness: Brightness.light,
            primaryColorLight: _myThemeColor,
            primaryColorDark: _myThemeColor,
            tabBarTheme: TabBarTheme(indicatorSize: TabBarIndicatorSize.label),
            scaffoldBackgroundColor: _scaffoldColor,
            appBarTheme: AppBarTheme(elevation: 0,color: _scaffoldColor),
            textTheme: TextTheme(
              bodyText2: TextStyle(
                fontSize: dataAppSizeModel.scaleFortSize*16,
              ),
            ),
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: SharedAxisPageTransitionsBuilder(
                  transitionType: SharedAxisTransitionType.horizontal,
                ),
                TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
                  transitionType: SharedAxisTransitionType.horizontal,
                ),
              },
            ),
          );
        }
        break;
    }
  }

  _getThemeDataDark(int index, DataAppSizePlugin dataAppSizeModel) {
    switch (index) {
      case 0:
        {
          return ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: SharedAxisPageTransitionsBuilder(
                  transitionType: SharedAxisTransitionType.horizontal,
                ),
                TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
                  transitionType: SharedAxisTransitionType.horizontal,
                ),
              },
            ),
            primarySwatch: _ThemeDataDarkColor,
            tabBarTheme: TabBarTheme(indicatorSize: TabBarIndicatorSize.label),
            textTheme: TextTheme(
              body1: TextStyle(
                fontSize: dataAppSizeModel.scaleFortSize*16,
                ///letterSpacing: dataAppSizeModel.scaleW*0.5,
                ///wordSpacing: dataAppSizeModel.scaleW*0.7,
              ),
            ),
          );
        }
        break;
    }
  }
}