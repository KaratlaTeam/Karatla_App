import 'package:PPM/myPlugin/myDeviceLocation.dart';
import 'package:flutter/material.dart';
import 'package:PPM/myPlugin/MyThemeData.dart';
import 'package:PPM/myPlugin/dataAppSizePlugin.dart';
import 'package:PPM/myPlugin/myDeviceData.dart';

class AppDataModel{

  MyThemeData myThemeData;
  DataAppSizePlugin dataAppSizePlugin;
  MyDeviceData myDeviceData;
  MyDeviceLocation myDeviceLocation;

  initialData(){
    this.myThemeData = MyThemeData();
    this.dataAppSizePlugin = DataAppSizePlugin()..getSizeData();
    this.myDeviceData = MyDeviceData()..initialData();
    this.myDeviceLocation = MyDeviceLocation()..initialData();
  }

}