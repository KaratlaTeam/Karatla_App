import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpp01/bloc/drivingAcademyDataBloc/drivingAcademyDataEvent.dart';
import 'package:kpp01/bloc/drivingAcademyDataBloc/drivingAcademyDataState.dart';
import 'package:kpp01/dataModel/drivingAcademyDataModel.dart';
import 'package:kpp01/dataModel/httpModel.dart';
import 'package:kpp01/httpSource.dart';
import 'package:kpp01/stringScource.dart';

class DrivingAcademyDataBloc extends Bloc<DrivingAcademyDataEvent,DrivingAcademyDataState>{
  DrivingAcademyDataBloc():super(DrivingAcademyDataStateGetting());

  DrivingAcademyDataModelList drivingAcademyDataModelList = DrivingAcademyDataModelList()..initialData();

  @override
  Stream<DrivingAcademyDataState> mapEventToState(DrivingAcademyDataEvent event)async* {
    if(event is DrivingAcademyDataEventGetData){
      yield DrivingAcademyDataStateGetting();
      try{
        print("get from share");
        DrivingAcademyDataModelList drivingAcademyDataModelList = DrivingAcademyDataModelList()..initialData();
        drivingAcademyDataModelList = await drivingAcademyDataModelList.getSharePAcademyDataList(event.systemLanguage, drivingAcademyDataModelList);
        if(drivingAcademyDataModelList == null){
          add(DrivingAcademyDataEventGetDataFromInternet(systemLanguage: event.systemLanguage));
        }else{
          ///TODO check internet
          this.drivingAcademyDataModelList = drivingAcademyDataModelList;
          yield DrivingAcademyDataStateGot(drivingAcademyDataModelList: this.drivingAcademyDataModelList);
        }
        
      }catch(e){
        yield DrivingAcademyDataStateError(e: e)..backError();

      }
    }else if(event is DrivingAcademyDataEventGetDataFromInternet){
      yield DrivingAcademyDataStateGetting();
      try{
        print("get from internet");
        ///TODO check internet
        //TODO change to http 
        DrivingAcademyDataModelList drivingAcademyDataModelList = DrivingAcademyDataModelList()..initialData();

        //String requestBody = await rootBundle.loadString(StringSource.academyRoot);
        //var json = await jsonDecode(requestBody);
        //HttpModel httpMode = HttpModel.fromJson(json);

        HttpSource httpSource = HttpSource();
        HttpModel  httpModel = await httpSource.requestGet(
        HttpSource.getQcademyJsonData + event.systemLanguage,
        );

        drivingAcademyDataModelList = DrivingAcademyDataModelList.fromJson(httpModel.data);
        await drivingAcademyDataModelList.setSharePAcademyDataList(event.systemLanguage, drivingAcademyDataModelList);
        this.drivingAcademyDataModelList = drivingAcademyDataModelList;
        yield DrivingAcademyDataStateGot(drivingAcademyDataModelList: this.drivingAcademyDataModelList);

      }catch (e){
        yield DrivingAcademyDataStateError(e: e)..backError();
      }
    }
  }


}