
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:kpp01/bloc/questionDataBloc/bloc.dart';
import 'package:kpp01/dataModel/httpModel.dart';
import 'package:kpp01/dataModel/questionDataModel.dart';
import 'package:kpp01/httpSource.dart';

class QuestionDataBloc extends Bloc<QuestionDataEvent,QuestionDataState>{
  QuestionDataBloc():super(QuestionDataStateGettingQuestionData());

  QuestionDataModel questionDataModel = QuestionDataModel();

  @override
  Stream<QuestionDataState> mapEventToState(QuestionDataEvent event) async*{
    if(event is QuestionDataEventGetQuestionData){
      yield QuestionDataStateGettingQuestionData();
      try{
        print("get from share");
        QuestionDataModel questionDataModel = QuestionDataModel();
        questionDataModel = await questionDataModel.getSharePQuestionDataModel(questionDataModel, event.systemLanguage);
        if(questionDataModel == null){
          add(QuestionDataEventGetQuestionDataFromInternet(systemLanguage: event.systemLanguage));
        }else{
          ///TODO check internet
          ///TODO check questionData version
          this.questionDataModel = questionDataModel;
          yield QuestionDataStateGotQuestionData(questionDataModel: this.questionDataModel);
        }

      }catch(e){
        yield QuestionDataStateError(e: e)..backError();

      }
      
    }else if(event is QuestionDataEventGetQuestionDataFromInternet){
      yield* _mapStartToGetDataFromInternet(event);
    }
  }

  Stream<QuestionDataState> _mapStartToGetDataFromInternet(QuestionDataEventGetQuestionDataFromInternet getQuestionData)async*{
    yield QuestionDataStateGettingQuestionData();
    try{
        //TODO check internet
        //TODO change to http and filter by language
      print("get from internet");
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