import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:get/get.dart';
import 'package:maybrowser/View/downloadV.dart';
import 'package:maybrowser/View/homeV.dart';
import 'package:maybrowser/View/tabV.dart';
import 'package:maybrowser/View/settingV.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:maybrowser/View/tabRootV.dart';
import 'package:maybrowser/binding.dart';

Future<void> main() async {
  ///If you’re running an application and need to access the binary messenger
  ///before runApp() has been called (for example, during plugin initialization),
  ///then you need to explicitly call the WidgetsFlutterBinding.ensureInitialized() first.
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(MyApp(),);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  ///主题颜色
  static const Color _myThemeColor = _myTeaGreen;
  static const Color _myTeaGreen = Color(_myThemeColorInt);///  茶色
  static const Color _myYellow = Color(0xFFfde3a0);/// 黄色
  static const Color _myWhiteBlue = Color(0xFFF4F8FB);/// 白蓝色
  static const int _myThemeColorInt = 0xFFb6c0a4;///  茶色
  static const Map<int , Color> _colorWhite ={
    50: const Color(0xFFFF5722),
    100: const Color(0xFFFF5722),
    200: _myWhiteBlue,///进度条背景色,输入标颜色,光标选择时颜色
    300: _myThemeColor,///textSelectionHandleColor
    400: const Color(0xFFFF5722),
    500: const Color(_myThemeColorInt),///控制tab横线,进度条，ios textSelectionHandleColor,
    600: const Color(0xFFFF5722),
    700: const Color(0xFFFF5722),
    800: const Color(0xFFFF5722),
    900: const Color(0xFFFF5722),
  };
  static const MaterialColor _ThemeDataLightColor = MaterialColor(_myThemeColorInt, _colorWhite,);

  ///主题设置
  final ThemeData _themeData = ThemeData(
    primarySwatch: _ThemeDataLightColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: TextButton.styleFrom(primary: Colors.white),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    tabBarTheme: TabBarTheme(labelColor: Colors.white),
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      elevation: 0,
      //backgroundColor: Colors.white,
      //iconTheme: IconThemeData(color: Colors.black),
      textTheme: TextTheme(headline6: TextStyle(color: Colors.white)),
    ),
    iconTheme: IconThemeData(color: Color(0xff5b604f)),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.only(top: 5),
    ),
  );

  ///框架入口
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'May Browser',
        enableLog: true,
        initialBinding: TabRootBinding(),
        initialRoute: RN.tabRoot,
        getPages: _getPages(),
        theme: _themeData,
        locale: Get.deviceLocale,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''), // English, no country code
          const Locale.fromSubtags(languageCode: 'zh')
        ],
        onInit: (){
          printInfo(info: "onInit-------");
          //print(Get.deviceLocale);
          if (Platform.isAndroid) {
            FlutterDisplayMode.active.then((displayMode) {
              FlutterDisplayMode.setPreferredMode(displayMode);
              print(displayMode);
            });
          }

          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Color(0xff6a7d6b),
            statusBarBrightness: Brightness.light,

            /// Only honored in iOS.
            statusBarIconBrightness: Brightness.light,

            ///Only honored in Android version M and greater.
            systemNavigationBarIconBrightness: Brightness.light,

            ///Only honored in Android versions O and greater.
          ));
        },
        onReady: (){
          printInfo(info: "onReady-------");
        },
        onDispose: (){
          printInfo(info: "onDispose");
        }
    );
  }

  ///页面路径设置
  List<GetPage> _getPages(){
    final List<GetPage> _pageList = [
      GetPage(name: RN.home, page: () => HomeV(key: key,), ),

      GetPage(name: RN.tabRoot, page: () => TabRootV(key: key),),

      GetPage(name: RN.setting, page: () => SettingV(), ),

      GetPage(name: RN.download, page: () => DownloadV(key: key,), ),

    ];
    return _pageList;
  }


}

///字符串绑定
class RN{

  static const String tab = '/tab';

  static const String home = '/';

  static const String setting = '/setting';

  static const String tabRoot = '/tabsRoot';

  static const String download = '/download';

}