import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpp01/bloc/DrivingAcademyDataBloc/DrivingAcademyDataEvent.dart';
import 'package:kpp01/bloc/DrivingAcademyDataBloc/DrivingAcademyDataState.dart';
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
        drivingAcademyDataModelList = await drivingAcademyDataModelList.getSharePAcademyDataList(drivingAcademyDataModelList);
        yield DrivingAcademyDataStateGot(drivingAcademyDataModelList: drivingAcademyDataModelList);

      }catch(e){
        yield DrivingAcademyDataStateError(e: e)..backError();

      }
    }else if(event is DrivingAcademyDataEventGetDataFromInternet){
      yield DrivingAcademyDataStateGetting();
      try{
        //TODO internet
        String requestBody = await rootBundle.loadString('assets/json/drivingData.json');
        var json = await jsonDecode(requestBody);
        HttpModel httpMode = HttpModel.fromJson(json);

        drivingAcademyDataModelList = DrivingAcademyDataModelList.fromJson(httpMode.data);
        await drivingAcademyDataModelList.setSharePAcademyDataList(drivingAcademyDataModelList);
        yield DrivingAcademyDataStateGot(drivingAcademyDataModelList: drivingAcademyDataModelList);

      }catch (e){
        yield DrivingAcademyDataStateError(e: e)..backError();
      }
    }
  }


}