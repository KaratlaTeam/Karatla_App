import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:PPM/bloc/appDataBloc/appDataEvent.dart';
import 'package:PPM/bloc/appDataBloc/appDataState.dart';
import 'package:PPM/dataModel/appDataModel.dart';
import 'package:PPM/myPlugin/MyThemeData.dart';

class AppDataBloc extends Bloc<AppDataEvent,AppDataState>{
  AppDataBloc({@required this.appDataModel}):super(AppDataStateGettingData());

  final AppDataModel appDataModel;

  @override
  Stream<AppDataState> mapEventToState(AppDataEvent event)async*{
    if(event is AppDataEventGetData){
      yield* _mapStartToGetDataToState(event);
    }
  }

  Stream<AppDataState> _mapStartToGetDataToState(AppDataEventGetData eventData)async*{
    yield AppDataStateGettingData();
    try{
      appDataModel.initialData();
      appDataModel.myThemeData = MyThemeData(index: eventData.index,dataAppSizeModel: appDataModel.dataAppSizePlugin);
      yield AppDataStateGotData(appDataModel: appDataModel);
    }catch (e){
      yield AppDataStateError(e: e);
    }
  }

}