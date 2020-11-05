import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpp01/bloc/drivingAcademyDataBloc/drivingAcademyDataEvent.dart';
import 'package:kpp01/bloc/drivingAcademyDataBloc/drivingAcademyDataState.dart';
import 'package:kpp01/dataModel/drivingAcademyDataModel.dart';
import 'package:kpp01/dataModel/httpModel.dart';

class DrivingAcademyDataBloc extends Bloc<DrivingAcademyDataEvent,DrivingAcademyDataState>{
  DrivingAcademyDataBloc():super(DrivingAcademyDataStateGetting());

  DrivingAcademyDataModelList drivingAcademyDataModelList = DrivingAcademyDataModelList()..initialData();

  @override
  Stream<DrivingAcademyDataState> mapEventToState(DrivingAcademyDataEvent event)async* {
    if(event is DrivingAcademyDataEventGetData){
      yield DrivingAcademyDataStateGetting();
      try{
        DrivingAcademyDataModelList drivingAcademyDataModelList = DrivingAcademyDataModelList()..initialData();
        drivingAcademyDataModelList = await drivingAcademyDataModelList.getSharePAcademyDataList(drivingAcademyDataModelList);
        if(drivingAcademyDataModelList == null){
          add(DrivingAcademyDataEventGetDataFromInternet());
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
        ///TODO check internet
        //TODO change to http
        DrivingAcademyDataModelList drivingAcademyDataModelList = DrivingAcademyDataModelList()..initialData();
        String requestBody = await rootBundle.loadString('assets/json/drivingData.json');
        var json = await jsonDecode(requestBody);
        HttpModel httpMode = HttpModel.fromJson(json);

        drivingAcademyDataModelList = DrivingAcademyDataModelList.fromJson(httpMode.data);
        await drivingAcademyDataModelList.setSharePAcademyDataList(drivingAcademyDataModelList);
        this.drivingAcademyDataModelList = drivingAcademyDataModelList;
        yield DrivingAcademyDataStateGot(drivingAcademyDataModelList: this.drivingAcademyDataModelList);

      }catch (e){
        yield DrivingAcademyDataStateError(e: e)..backError();
      }
    }
  }


}