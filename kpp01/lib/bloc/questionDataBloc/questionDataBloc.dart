
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:kpp01/bloc/questionDataBloc/bloc.dart';
import 'package:kpp01/dataModel/httpModel.dart';
import 'package:kpp01/dataModel/questionDataModel.dart';

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
        questionDataModel = await questionDataModel.getSharePQuestionDataModel(questionDataModel);
        if(questionDataModel == null){
          add(QuestionDataEventGetQuestionDataFromInternet());
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
      ///TODO check internet
        //TODO change to http
      print("get from internet");
      QuestionDataModel questionDataModel = QuestionDataModel();
      String requestBody = await rootBundle.loadString('assets/json/questionJson.json');

      var json = await jsonDecode(requestBody);
      HttpModel httpMode = HttpModel.fromJson(json);
      questionDataModel = QuestionDataModel.fromJson(httpMode.data);
      await questionDataModel.setSharePQuestionDataModel(questionDataModel);
      this.questionDataModel = questionDataModel;
      yield QuestionDataStateGotQuestionData(questionDataModel: this.questionDataModel);

    }catch(e){
      yield QuestionDataStateError(e: e);
    }
  }

}