
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:kpp01/bloc/questionDataBloc/bloc.dart';
import 'package:kpp01/dataModel/questionPartModel.dart';
import 'package:kpp01/dataModel/testDataModel.dart';

class QuestionDataBloc extends Bloc<QuestionDataEvent,QuestionDataState>{
  QuestionDataBloc():super(QuestionDataStateGettingQuestionData());


  @override
  Stream<QuestionDataState> mapEventToState(QuestionDataEvent event) async*{
    if(event is QuestionDataEventGetQuestionData){
      yield* _mapStartToGetDataToState(event);
    }
  }

  Stream<QuestionDataState> _mapStartToGetDataToState(QuestionDataEventGetQuestionData getQuestionData)async*{
    yield QuestionDataStateGettingQuestionData();
    try{
      QuestionDataList questionData = await _getQuestionData();
      yield QuestionDataStateGotQuestionData(questionDataList: questionData);
    }catch(e){
      yield QuestionDataStateError(e: e);
    }
  }

  Future<QuestionDataList> _getQuestionData()async{
    String jsonStringPart1 = await rootBundle.loadString('assets/json/questionJsonPartOne');
    String jsonStringPart2 = await rootBundle.loadString('assets/json/questionJsonPartTwo');
    String jsonStringPart3 = await rootBundle.loadString('assets/json/questionJsonPartThree');

    final jsonResponsePart1 = await json.decode(jsonStringPart1);
    final jsonResponsePart2 = await json.decode(jsonStringPart2);
    final jsonResponsePart3 = await json.decode(jsonStringPart3);

    QuestionPart1 questionPart1 = QuestionPart1.fromJson(jsonResponsePart1);
    QuestionPart2 questionPart2 = QuestionPart2.fromJson(jsonResponsePart2);
    QuestionPart3 questionPart3 = QuestionPart3.fromJson(jsonResponsePart3);

    List partOneList = questionPart1.questionData;
    List partTwoList = questionPart2.questionData;
    List partThreeList = questionPart3.questionData;
    
    QuestionDataList questionData = QuestionDataList(partOneList, partTwoList, partThreeList, [["A","B","C"],["I","II","III","IV"]]);

    return questionData;
  }
}