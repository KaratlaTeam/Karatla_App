
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:kpp01/bloc/internetCheckBloc/bloc.dart';
import 'package:kpp01/bloc/questionDataBloc/bloc.dart';
import 'package:kpp01/dataModel/httpModel.dart';
import 'package:kpp01/dataModel/questionDataModel.dart';
import 'package:kpp01/httpSource.dart';

class QuestionDataBloc extends Bloc<QuestionDataEvent,QuestionDataState>{
  QuestionDataBloc({this.internetCheckBloc}):super(QuestionDataStateGettingQuestionData()){
    streamSubscription = internetCheckBloc.listen((InternetCheckState internetCheckState) {
      if(internetCheckState is InternetCheckStateGod && questionDataEvent is QuestionDataEventCheckInternetThenGet){
        add(QuestionDataEventGetQuestionDataFromInternet());
      }
     });
  }

  StreamSubscription streamSubscription; 
  QuestionDataModel questionDataModel = QuestionDataModel();
  InternetCheckBloc internetCheckBloc;
  QuestionDataEvent questionDataEvent;

  @override
  Future<void> close() {
    streamSubscription.cancel();
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
        if(questionDataModel == null){
          add(QuestionDataEventCheckInternetThenGet(systemLanguage: event.systemLanguage));
        }else{
          ///TODO check internet
          ///TODO check questionData version
          this.questionDataModel = questionDataModel;
          yield QuestionDataStateGotQuestionData(questionDataModel: this.questionDataModel);
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