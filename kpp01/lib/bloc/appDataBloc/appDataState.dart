import 'package:flutter/cupertino.dart';
import 'package:kpp01/dataModel/appDataModel.dart';


abstract class AppDataState{
  const AppDataState();
}

class AppDataStateGettingData extends AppDataState{
  const AppDataStateGettingData();
}

class AppDataStateGotData extends AppDataState{
  final AppDataModel appDataModel;

  const AppDataStateGotData({@required this.appDataModel,}) : assert(appDataModel != null);
}

class AppDataStateError extends AppDataState{
  final e;
  const AppDataStateError({@required this.e}):assert(e != null);
  backError(){
    return print("AppDataStateError: \n"+e.toString());
  }
}