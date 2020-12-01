
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:PPM/bloc/systemLanguage/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:PPM/bloc/drivingAcademyDataBloc/drivingAcademyDataEvent.dart';
import 'package:PPM/bloc/drivingAcademyDataBloc/drivingAcademyDataState.dart';
import 'package:PPM/bloc/internetCheckBloc/internetCheckBloc.dart';
import 'package:PPM/bloc/internetCheckBloc/internetCheckEvent.dart';
import 'package:PPM/bloc/internetCheckBloc/internetCheckState.dart';
import 'package:PPM/dataModel/drivingAcademyDataModel.dart';
import 'package:PPM/dataModel/httpModel.dart';
import 'package:PPM/httpSource.dart';

class DrivingAcademyDataBloc extends Bloc<DrivingAcademyDataEvent,DrivingAcademyDataState>{
  DrivingAcademyDataBloc(this.internetCheckBloc, this.systemLanguageBloc):super(DrivingAcademyDataStateGetting()){
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
        yield DrivingAcademyDataStateGot(drivingAcademyDataModelList: this.drivingAcademyDataModelList);

      }catch (e){
        yield DrivingAcademyDataStateError(e: e)..backError();
      }
  }

}