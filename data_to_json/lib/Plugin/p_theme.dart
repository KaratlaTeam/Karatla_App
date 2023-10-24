import 'package:flutter/material.dart';

class PT {

  ///主题颜色
  static const Color _myThemeColor = _myTeaGreen;
  static const Color _myTeaGreen = Color(_myThemeColorInt);///  茶色
  static const Color _myYellow = Color(0xFFfde3a0);/// 黄色
  static const Color _myWhiteBlue = Color(0xFFF4F8FB);/// 白蓝色
  static const int _myThemeColorInt = 0xFFb6c0a4;///  茶色
  static const Map<int , Color> _colorWhite ={
    50: Color(0xFFFF5722),
    100: Color(0xFFFF5722),
    200: _myWhiteBlue,///进度条背景色,输入标颜色,光标选择时颜色
    300: _myThemeColor,///textSelectionHandleColor
    400: Color(0xFFFF5722),
    500: Color(_myThemeColorInt),///控制tab横线,进度条，ios textSelectionHandleColor,
    600: Color(0xFFFF5722),
    700: Color(0xFFFF5722),
    800: Color(0xFFFF5722),
    900: Color(0xFFFF5722),
  };
  static const MaterialColor _themeDataLightColor = MaterialColor(_myThemeColorInt, _colorWhite,);

  static ThemeData themeData = ThemeData(
    primarySwatch: _themeDataLightColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: TextButton.styleFrom(primary: Colors.white),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    sliderTheme: const SliderThemeData(
      //valueIndicatorColor: Colors.white,
      valueIndicatorTextStyle: TextStyle(color: Colors.white),
    ),
    tabBarTheme: const TabBarTheme(labelColor: Colors.white),
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      elevation: 0,
      //backgroundColor: Colors.white,
      //iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(color: Colors.white),
    ),
    iconTheme: const IconThemeData(color: Color(0xff5b604f)),
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.only(top: 5),
    ),
  );
}