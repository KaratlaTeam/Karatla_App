import 'package:kpp01/myPlugin/MyThemeData.dart';
import 'package:kpp01/myPlugin/dataAppSizePlugin.dart';
import 'package:kpp01/myPlugin/myDeviceData.dart';

class AppDataModel{

  MyThemeData myThemeData;
  DataAppSizePlugin dataAppSizePlugin;
  MyDeviceData myDeviceData;

  initialData(){
    this.myThemeData = MyThemeData();
    this.dataAppSizePlugin = DataAppSizePlugin()..getSizeData();
    this.myDeviceData = MyDeviceData()..initialData();
  }

}