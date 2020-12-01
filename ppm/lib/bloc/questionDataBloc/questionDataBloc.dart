
import 'dart:async';

import 'package:PPM/bloc/systemLanguage/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:PPM/bloc/internetCheckBloc/bloc.dart';
import 'package:PPM/bloc/questionDataBloc/bloc.dart';
import 'package:PPM/dataModel/httpModel.dart';
import 'package:PPM/dataModel/questionDataModel.dart';
import 'package:PPM/httpSource.dart';

class QuestionDataBloc extends Bloc<QuestionDataEvent,QuestionDataState>{
  QuestionDataBloc({this.internetCheckBloc, this.systemLanguageBloc}):super(QuestionDataStateGettingQuestionData()){
    streamSubscription = internetCheckBloc.listen((InternetCheckState internetCheckState) {
      if(internetCheckState is InternetCheckStateGod && questionDataEvent is QuestionDataEventCheckInternetThenGet){
        add(QuestionDataEventGetQuestionDataFromInternet());
      }else if(internetCheckState is InternetCheckStateError && questionDataEvent is QuestionDataEventCheckInternetThenGet){
        if(questionDataModel == null){
          add(QuestionDataEventInternetErrorWithoutData());
        }
      }
     });

     streamSubscription2 = systemLanguageBloc.listen((SystemLanguageState systemLanguageState) {
       if(systemLanguageState is SystemLanguageStateJustChanged){
         add(QuestionDataEventGetQuestionData(systemLanguage: systemLanguageState.systemLanguageModel.codeString()));
       }
     });
  }

  StreamSubscription streamSubscription; 
  StreamSubscription streamSubscription2; 
  QuestionDataModel questionDataModel = QuestionDataModel();
  InternetCheckBloc internetCheckBloc;
  QuestionDataEvent questionDataEvent;
  SystemLanguageBloc systemLanguageBloc;

  @override
  Future<void> close() {
    streamSubscription.cancel();
    streamSubscription2.cancel();
    return super.close();
  }

  @override
  Stream<QuestionDataState> mapEventToState(QuestionDataEvent event) async*{
    if(event is QuestionDataEventGetQuestionData){
      yield QuestionDataStateGettingQuestionData();
      try{
        print("get from share");
        QuestionDataModel questionDataModel = QuestionDataModel();
        questionDataModel = await questionDataModel.getSharePQuestionDataModel(questionDataModel, event.systemLanguage);
        this.questionDataModel = questionDataModel;
        if(questionDataModel == null){
          add(QuestionDataEventCheckInternetThenGet(systemLanguage: event.systemLanguage));
        }else{
          try{
          HttpSource httpSource = HttpSource();
          HttpModel httpModel = await httpSource.requestGet(HttpSource.checkQuestionVersion);
          double newVersion = httpModel.data["version"];
          double dataVersion = questionDataModel.questionDataModelDetail.version;
          print("new version: $newVersion");
          if(newVersion != dataVersion){
            print("version old");
            add(QuestionDataEventCheckInternetThenGet(systemLanguage: event.systemLanguage));
          }else{
            print("version new");
            yield QuestionDataStateGotQuestionData(questionDataModel: this.questionDataModel);
          }
          }catch(e){
            print("check question version error");
            yield QuestionDataStateGotQuestionData(questionDataModel: this.questionDataModel);
          }
          
        }

      }catch(e){
        yield QuestionDataStateError(e: e)..backError();

      }
      
    }else if(event is QuestionDataEventCheckInternetThenGet){
      questionDataEvent = event;
      internetCheckBloc.add(InternetCheckEventCheck());
      
    }else if(event is QuestionDataEventGetQuestionDataFromInternet){
      yield* _mapStartToGetDataFromInternet(questionDataEvent);
      questionDataEvent = null;
    }else if(event is QuestionDataEventInternetErrorWithoutData){
      yield QuestionDataStateError(e: "Get data fail")..backError();
    }
  }

  Stream<QuestionDataState> _mapStartToGetDataFromInternet(QuestionDataEventCheckInternetThenGet getQuestionData)async*{
    yield QuestionDataStateGettingQuestionData();
    try{
        
      print("get questiondata from internet");
      print("system language: ${getQuestionData.systemLanguage}");
      QuestionDataModel questionDataModel = QuestionDataModel();

      HttpSource httpSource = HttpSource();
      HttpModel  httpModel = await httpSource.requestGet(
        HttpSource.getQuestionJsonData + getQuestionData.systemLanguage,
      );

      questionDataModel = QuestionDataModel.fromJson(httpModel.data);
      await questionDataModel.setSharePQuestionDataModel(questionDataModel, getQuestionData.systemLanguage);
      this.questionDataModel = questionDataModel;
      yield QuestionDataStateGotQuestionData(questionDataModel: this.questionDataModel);

    }catch(e){
      yield QuestionDataStateError(e: e)..backError();
    }
  }

}