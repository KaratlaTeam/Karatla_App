import 'package:kpp01/myPlugin/MyThemeData.dart';
import 'package:kpp01/myPlugin/dataAppSizePlugin.dart';

class AppDataModel{

  MyThemeData myThemeData;
  DataAppSizePlugin dataAppSizePlugin;

  initialData(){
    this.myThemeData = MyThemeData();
    this.dataAppSizePlugin = DataAppSizePlugin()..getSizeData();
  }

}