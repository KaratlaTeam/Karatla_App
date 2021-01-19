
import 'dart:async';
import 'package:PPM/bloc/appDataBloc/appDataBloc.dart';
import 'package:PPM/myPlugin/myDeviceLocation.dart';
import 'package:bloc/bloc.dart';
import 'package:PPM/bloc/systemLanguage/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:PPM/bloc/drivingAcademyDataBloc/drivingAcademyDataEvent.dart';
import 'package:PPM/bloc/drivingAcademyDataBloc/drivingAcademyDataState.dart';
import 'package:PPM/bloc/internetCheckBloc/internetCheckBloc.dart';
import 'package:PPM/bloc/internetCheckBloc/internetCheckEvent.dart';
import 'package:PPM/bloc/internetCheckBloc/internetCheckState.dart';
import 'package:PPM/dataModel/drivingAcademyDataModel.dart';
import 'package:PPM/dataModel/httpModel.dart';
import 'package:PPM/httpSource.dart';
import 'package:geolocator/geolocator.dart';

class DrivingAcademyDataBloc extends Bloc<DrivingAcademyDataEvent,DrivingAcademyDataState>{
  DrivingAcademyDataBloc(this.internetCheckBloc, this.systemLanguageBloc, this.appDataBloc):super(DrivingAcademyDataStateGetting()){
      streamSubscription = internetCheckBloc.listen((InternetCheckState internetCheckState) {
      if(internetCheckState is InternetCheckStateGod && drivingAcademyDataEvent is DrivingAcademyDataEventCheckInternetThenGet){
        add(DrivingAcademyDataEventGetDataFromInternet());
      }else if(internetCheckState is InternetCheckStateError && drivingAcademyDataEvent is DrivingAcademyDataEventCheckInternetThenGet){
        if(drivingAcademyDataModelList == null){
          add(DrivingAcademyDataEventInternetErrorWithoutData());
        }
      }
     });

     streamSubscription2 = systemLanguageBloc.listen((SystemLanguageState systemLanguageState) {
       if(systemLanguageState is SystemLanguageStateJustChanged){
         add(DrivingAcademyDataEventGetData(systemLanguage: systemLanguageState.systemLanguageModel.codeString()));
       }
     });
  }

  DrivingAcademyDataModelList drivingAcademyDataModelList ;
  StreamSubscription streamSubscription; 
  StreamSubscription streamSubscription2; 
  InternetCheckBloc internetCheckBloc;
  DrivingAcademyDataEvent drivingAcademyDataEvent;
  SystemLanguageBloc systemLanguageBloc;
  AppDataBloc appDataBloc;

  @override
  Future<void> close() {
    streamSubscription.cancel();
    streamSubscription2.cancel();
    return super.close();
  }

  @override
  Stream<DrivingAcademyDataState> mapEventToState(DrivingAcademyDataEvent event)async* {
    if(event is DrivingAcademyDataEventGetData){
      yield DrivingAcademyDataStateGetting();
      try{
        print("get from share");
        DrivingAcademyDataModelList drivingAcademyDataModelList = DrivingAcademyDataModelList()..initialData() ;
        drivingAcademyDataModelList = await drivingAcademyDataModelList.getSharePAcademyDataList(event.systemLanguage, drivingAcademyDataModelList);
        this.drivingAcademyDataModelList = drivingAcademyDataModelList;
        if(drivingAcademyDataModelList == null){
          add(DrivingAcademyDataEventCheckInternetThenGet(systemLanguage: event.systemLanguage));
        }else{
          
          yield* _locationCheck();
          //yield DrivingAcademyDataStateGot(drivingAcademyDataModelList: this.drivingAcademyDataModelList);
        }
        
      }catch(e){
        yield DrivingAcademyDataStateError(e: e)..backError();

      }
    }else if(event is DrivingAcademyDataEventCheckInternetThenGet){
      drivingAcademyDataEvent = event;
      internetCheckBloc.add(InternetCheckEventCheck());

    }else if(event is DrivingAcademyDataEventGetDataFromInternet){
      yield* _mapStartToGetDataFromInternet(drivingAcademyDataEvent);
      drivingAcademyDataEvent = null;
    }else if(event is DrivingAcademyDataEventInternetErrorWithoutData){
      yield DrivingAcademyDataStateError(e: "Get data error, please try again latter.")..backError();
    }
  }

  Stream<DrivingAcademyDataState> _mapStartToGetDataFromInternet(DrivingAcademyDataEventCheckInternetThenGet eventCheckInternetThenGet)async*{
    yield DrivingAcademyDataStateGetting();
      try{
        print("get academy data from internet");
        print("system language: ${eventCheckInternetThenGet.systemLanguage}");
        DrivingAcademyDataModelList drivingAcademyDataModelList = DrivingAcademyDataModelList()..initialData();

        HttpSource httpSource = HttpSource();
        HttpModel  httpModel = await httpSource.requestGet(
        HttpSource.getQcademyJsonData + eventCheckInternetThenGet.systemLanguage,
        );

        drivingAcademyDataModelList = DrivingAcademyDataModelList.fromJson(httpModel.data);
        await drivingAcademyDataModelList.setSharePAcademyDataList(eventCheckInternetThenGet.systemLanguage, drivingAcademyDataModelList);
        this.drivingAcademyDataModelList = drivingAcademyDataModelList;

        
        yield* _locationCheck();
        //yield DrivingAcademyDataStateGot(drivingAcademyDataModelList: this.drivingAcademyDataModelList);

      }catch (e){
        yield DrivingAcademyDataStateError(e: e)..backError();
      }
  }

  _sortByLocation()async{
    print("sort");
    //TODO sort list
    MyDeviceLocation myDeviceLocation = appDataBloc.appDataModel.myDeviceLocation;
    double myLongitude = myDeviceLocation.position.longitude;
    double myLatitude = myDeviceLocation.position.latitude;
    // 2.9517488522900077, 101.82337690484789
    //this.drivingAcademyDataModelList.mySort(2.9517488522900077, 101.82337690484789);
    this.drivingAcademyDataModelList.mySort(myLatitude, myLongitude);
    
  }

  Stream<DrivingAcademyDataState> _locationCheck()async*{
    MyDeviceLocation myDeviceLocation = appDataBloc.appDataModel.myDeviceLocation;
    await myDeviceLocation.getPosition();
    if(myDeviceLocation.position == null){
      yield DrivingAcademyDataStateError(e: "Please allow PPM to use your location")..backError();
    }else{
      await _sortByLocation();
      yield DrivingAcademyDataStateGot(drivingAcademyDataModelList: this.drivingAcademyDataModelList);
    }
  }

}