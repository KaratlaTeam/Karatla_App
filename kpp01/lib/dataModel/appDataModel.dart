import 'package:flutter/material.dart';
import 'package:kpp01/myPlugin/MyThemeData.dart';
import 'package:kpp01/myPlugin/dataAppSizePlugin.dart';
import 'package:kpp01/myPlugin/myDeviceData.dart';
import 'package:kpp01/typedef.dart';

class AppDataModel{

  MyThemeData myThemeData;
  DataAppSizePlugin dataAppSizePlugin;
  MyDeviceData myDeviceData;
  SystemLanguage systemLanguage;

  initialData(){
    this.myThemeData = MyThemeData();
    this.dataAppSizePlugin = DataAppSizePlugin()..getSizeData();
    this.myDeviceData = MyDeviceData()..initialData();
    this.systemLanguage = SystemLanguage.EN;
  }

}