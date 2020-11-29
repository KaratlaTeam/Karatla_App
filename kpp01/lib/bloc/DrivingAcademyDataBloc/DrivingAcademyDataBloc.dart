
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpp01/bloc/drivingAcademyDataBloc/drivingAcademyDataEvent.dart';
import 'package:kpp01/bloc/drivingAcademyDataBloc/drivingAcademyDataState.dart';
import 'package:kpp01/bloc/internetCheckBloc/internetCheckBloc.dart';
import 'package:kpp01/bloc/internetCheckBloc/internetCheckEvent.dart';
import 'package:kpp01/bloc/internetCheckBloc/internetCheckState.dart';
import 'package:kpp01/bloc/questionDataBloc/questionDataEvent.dart';
import 'package:kpp01/dataModel/drivingAcademyDataModel.dart';
import 'package:kpp01/dataModel/httpModel.dart';
import 'package:kpp01/httpSource.dart';

class DrivingAcademyDataBloc extends Bloc<DrivingAcademyDataEvent,DrivingAcademyDataState>{
  DrivingAcademyDataBloc(this.internetCheckBloc):super(DrivingAcademyDataStateGetting()){
      streamSubscription = internetCheckBloc.listen((InternetCheckState internetCheckState) {
      if(internetCheckState is InternetCheckStateGod && drivingAcademyDataEvent is QuestionDataEventCheckInternetThenGet){
        add(DrivingAcademyDataEventGetDataFromInternet());
      }
     });
  }

  DrivingAcademyDataModelList drivingAcademyDataModelList = DrivingAcademyDataModelList()..initialData();
  StreamSubscription streamSubscription; 
  InternetCheckBloc internetCheckBloc;
  DrivingAcademyDataEvent drivingAcademyDataEvent;

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }

  @override
  Stream<DrivingAcademyDataState> mapEventToState(DrivingAcademyDataEvent event)async* {
    if(event is DrivingAcademyDataEventGetData){
      yield DrivingAcademyDataStateGetting();
      try{
        print("get from share");
        DrivingAcademyDataModelList drivingAcademyDataModelList = DrivingAcademyDataModelList()..initialData();
        drivingAcademyDataModelList = await drivingAcademyDataModelList.getSharePAcademyDataList(event.systemLanguage, drivingAcademyDataModelList);
        if(drivingAcademyDataModelList == null){
          add(DrivingAcademyDataEventCheckInternetThenGet(systemLanguage: event.systemLanguage));
        }else{
          ///TODO check internet
          this.drivingAcademyDataModelList = drivingAcademyDataModelList;
          yield DrivingAcademyDataStateGot(drivingAcademyDataModelList: this.drivingAcademyDataModelList);
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
    }
  }

  Stream<DrivingAcademyDataState> _mapStartToGetDataFromInternet(DrivingAcademyDataEventCheckInternetThenGet eventCheckInternetThenGet)async*{
    yield DrivingAcademyDataStateGetting();
      try{
        print("get academy data from internet");
        print("system language: ${eventCheckInternetThenGet.systemLanguage}");
        ///TODO check internet
        //TODO change to http 
        DrivingAcademyDataModelList drivingAcademyDataModelList = DrivingAcademyDataModelList()..initialData();

        //String requestBody = await rootBundle.loadString(StringSource.academyRoot);
        //var json = await jsonDecode(requestBody);
        //HttpModel httpMode = HttpModel.fromJson(json);

        HttpSource httpSource = HttpSource();
        HttpModel  httpModel = await httpSource.requestGet(
        HttpSource.getQcademyJsonData + eventCheckInternetThenGet.systemLanguage,
        );

        drivingAcademyDataModelList = DrivingAcademyDataModelList.fromJson(httpModel.data);
        await drivingAcademyDataModelList.setSharePAcademyDataList(eventCheckInternetThenGet.systemLanguage, drivingAcademyDataModelList);
        this.drivingAcademyDataModelList = drivingAcademyDataModelList;
        yield DrivingAcademyDataStateGot(drivingAcademyDataModelList: this.drivingAcademyDataModelList);

      }catch (e){
        yield DrivingAcademyDataStateError(e: e)..backError();
      }
  }

}