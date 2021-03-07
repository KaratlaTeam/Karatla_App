import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hm/model/houseM.dart';
import 'package:hm/binding.dart';
import 'package:hm/model/roomM.dart';
import 'package:hm/view/customerPage.dart';
import 'package:hm/view/homeV.dart';
import 'package:hm/view/houseCreateV.dart';
import 'package:hm/view/houseDetailV.dart';
import 'package:hm/view/houseV.dart';
import 'package:hm/view/roomCreateV.dart';
import 'package:hm/view/roomDetailV.dart';
import 'package:hm/view/roomV.dart';

void main() async{
  //WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.white,
    statusBarBrightness: Brightness.light,

    /// Only honored in iOS.
    statusBarIconBrightness: Brightness.dark,

    ///Only honored in Android version M and greater.
    systemNavigationBarIconBrightness: Brightness.dark,

    ///Only honored in Android versions O and greater.
  ));

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final ThemeData _themeData = ThemeData(
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Rental Management',
      enableLog: true,
      //logWriterCallback: ,
      //initialBinding: ,
      initialRoute: RN.home,
      getPages: _getPages(),
      unknownRoute: GetPage(name: RN.home, page: () => HomeV()),
      routingCallback: _routingCallback(),
      theme: _themeData,
      onInit: (){
        printInfo(info: "onInit");
      },
      onReady: (){
        printInfo(info: "onReady");
      },
      onDispose: (){
        printInfo(info: "onDispose");
      }
    );
  }

  List<GetPage> _getPages(){
    final List<GetPage> _pageList = [
      GetPage(
        name: RN.home,
        page: () => HomeV(),
        binding: HomeBinding(),
      ),

      GetPage(
        name: RN.house,
        page: () => HouseV(),
        binding: HouseBinding(),
      ),
      GetPage(
        name: RN.houseDetail,
        page: () => HouseDetailV(),
        //binding: HomeBinding(),
      ),
      GetPage(
        name: RN.houseCreate,
        page: () => HouseCreateV(),
        //binding: HomeBinding(),
      ),

      GetPage(
        name: RN.room,
        page: () => RoomV(),
        binding: RoomBinding(),
      ),
      GetPage(
        name: RN.roomDetail,
        page: () => RoomDetailV(),
        //binding: HomeBinding(),
      ),
      GetPage(
        name: RN.roomCreate,
        page: () => RoomCreateV(),
        //binding: HomeBinding(),
      ),

      GetPage(
        name: RN.customer,
        page: () => CustomerPage(),
        //binding: HomeBinding(),
      ),
    ];
    return _pageList;
  }

  ValueChanged<Routing> _routingCallback(){
    return (routing) {
      if(routing.current == RN.home){
        //printInfo(info: "/");

      }else if(routing.current == RN.house){
        //printInfo(info: "/housePage");

      }else if(routing.current == RN.houseCreate){
        //printInfo(info: "/customerPage");

      }else if(routing.current == RN.customer){
        //printInfo(info: "/customerPage");

      }
    };
  }

}

class RN{
  static const String home = '/';

  static const String house = '/house';
  static const String houseDetail = '/houseDetail';
  static const String houseCreate = '/houseCreate';

  static const String room = '/room';
  static const String roomDetail = '/roomDetail';
  static const String roomCreate = '/roomCreate';

  static const String customer = '/customer';
}
