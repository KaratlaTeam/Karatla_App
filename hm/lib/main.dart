
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hm/Internationalization.dart';
import 'package:hm/model/houseM.dart';
import 'package:hm/binding.dart';
import 'package:hm/model/roomM.dart';
import 'package:hm/view/checkTime/addCheckTimeV.dart';
import 'package:hm/view/checkTime/editCheckTimeV.dart';
import 'package:hm/view/deposit/addDepositV.dart';
import 'package:hm/view/deposit/editDepositV.dart';
import 'package:hm/view/house/EditHouseExpenseV.dart';
import 'package:hm/view/house/addHouseExpenseV.dart';
import 'package:hm/view/houseHolder/addHouseHolder.dart';
import 'package:hm/view/rental/addRentalFeeV.dart';
import 'package:hm/view/home/backupList.dart';
import 'package:hm/view/customer/customerPage.dart';
import 'package:hm/view/leading/firstPageV.dart';
import 'package:hm/view/home/homeV.dart';
import 'package:hm/view/house/houseCreateV.dart';
import 'package:hm/view/houseHolder/houseHoldEditV.dart';
import 'package:hm/view/house/houseV.dart';
import 'package:hm/view/rental/rentalFeeEditV.dart';
import 'package:hm/view/house/houseEditV.dart';
import 'package:hm/view/room/roomDetailEditV.dart';
import 'package:hm/view/room/roomDetailV.dart';
import 'package:hm/view/room/roomV.dart';
import 'package:hm/view/setting/settingV.dart';
import 'package:hm/view/statistics/statisticsV.dart';

void main() async{

  //WidgetsFlutterBinding.ensureInitialized();


  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final ThemeData _themeData = ThemeData(
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: AppBarTheme(
      elevation: 0,
      //backgroundColor: Colors.white,
      //iconTheme: IconThemeData(color: Colors.black),
      //textTheme: TextTheme(headline6: TextStyle(color: Colors.black)),
    )
  );

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Rental Management',
      enableLog: true,
      //logWriterCallback: ,
      //initialBinding: ,
      initialRoute: RN.firstPage,
      getPages: _getPages(),
      unknownRoute: GetPage(name: RN.home, page: () => HomeV()),
      routingCallback: _routingCallback(),
      theme: _themeData,
        translations: Messages(),
        locale: Get.deviceLocale,
        fallbackLocale: Locale('en', 'UK'),
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
        printInfo(info: "onInit");
        //print(Get.deviceLocale);
        if (Platform.isAndroid) {
          FlutterDisplayMode.current.then((displayMode) {
            FlutterDisplayMode.setMode(displayMode);
            FlutterDisplayMode.setDeviceDefault();
            print(displayMode);
          });
        }

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
      },
      onReady: (){
        printInfo(info: "onReady");
        Get.offNamed(RN.home);
      },
      onDispose: (){
        printInfo(info: "onDispose");
      }
    );
  }

  List<GetPage> _getPages(){
    final List<GetPage> _pageList = [
      GetPage(name: RN.firstPage, page: () => FirstPageView(),),

      GetPage(name: RN.home, page: () => HomeV(),binding: HouseBinding(), ),
      GetPage(name: RN.setting, page: () => SettingV(), ),
      GetPage(name: RN.statistics, page: () => StatisticsV(), ),
      GetPage(name: RN.backupList, page: () => BackupListV()),

      GetPage(name: RN.house, page: () => HouseV()),
      //GetPage(name: RN.houseDetail, page: () => HouseDetailV(),),
      GetPage(name: RN.houseCreate, page: () => HouseCreateV(),),
      GetPage(name: RN.houseEdit, page: () => HouseEditV(),),

      GetPage(name: RN.room, page: () => RoomV(), binding: RoomBinding(),),
      GetPage(name: RN.roomDetail, page: () => RoomDetailV(),),
      GetPage(name: RN.roomDetailEdit, page: () => RoomDetailEditV(),),


      GetPage(name: RN.customer, page: () => CustomerPage(),),

      GetPage(name: RN.addCheckTime, page: () => AddCheckTimeV(),),
      GetPage(name: RN.addHouseHolder, page: () => AddHouseHolderV(),),
      GetPage(name: RN.addRentalFee, page: () => AddRentalFeeV(),),
      GetPage(name: RN.addDeposit, page: () => AddDepositV(),),
      GetPage(name: RN.addExpense, page: () => AddHouseExpenseV(),),

      GetPage(name: RN.rentalFeeEdit, page: () => RentalFeeEditV(),),
      GetPage(name: RN.houseHoldEdit, page: () => EditHouseHolderV(),),
      GetPage(name: RN.depositEdit, page: () => EditDepositV(),),
      GetPage(name: RN.checkTimeEdit, page: () => EditCheckTimeV(),),
      GetPage(name: RN.expenseEdit, page: () => EditHouseExpenseV(),),
    ];
    return _pageList;
  }

  ValueChanged<Routing> _routingCallback(){
    return (routing) {
      if(routing.current == RN.home){
        //printInfo(info: "/");

      }else if(routing.current == RN.house){
        //printInfo(info: "/housePage");

      }else if(routing.current == RN.houseEdit){
        //printInfo(info: "/customerPage");

      }else if(routing.current == RN.customer){
        //printInfo(info: "/customerPage");

      }
    };
  }

}

class RN{
  static const String backUpDirectoryName = '/backup';


/// ////////////

  static const String firstPage = '/';

  static const String home = '/home';
  static const String backupList = '/backupList';

  static const String setting = '/setting';

  static const String statistics = '/statistics';

  static const String house = '/house';
  //static const String houseDetail = '/houseDetail';
  static const String houseCreate = '/houseCreate';
  static const String houseEdit = '/houseEdit';

  static const String room = '/room';
  static const String roomDetail = '/roomDetail';
  static const String roomDetailEdit = '/roomDetailEdit';

  static const String customer = '/customer';
  
  static const String addCheckTime = '/addCheckTime';
  static const String addRentalFee = '/addRentalFee';
  static const String addHouseHolder = '/addHouseHolder';
  static const String addDeposit = '/addDeposit';
  static const String addExpense = '/addExpense';

  static const String rentalFeeEdit = '/rentalFeeEdit';
  static const String houseHoldEdit = '/houseHoldEdit';
  static const String depositEdit = '/depositEdit';
  static const String checkTimeEdit = '/checkTimeEdit';
  static const String expenseEdit = '/expenseEdit';
}
