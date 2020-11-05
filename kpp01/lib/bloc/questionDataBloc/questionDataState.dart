import 'package:flutter/cupertino.dart';
import 'package:kpp01/dataModel/questionDataModel.dart';
import 'package:kpp01/dataModel/testDataModel.dart';

abstract class QuestionDataState{
  const QuestionDataState();
}

class QuestionDataStateGettingQuestionData extends QuestionDataState{
}

class QuestionDataStateGotQuestionData extends QuestionDataState{
  final QuestionDataModel questionDataModel;
  const QuestionDataStateGotQuestionData({@required this.questionDataModel}):assert(questionDataModel != null);
}

class QuestionDataStateError extends QuestionDataState{
  final e;
  const QuestionDataStateError({@required this.e}):assert(e != null);
  backError(){
    return print("QuestionDataStateError: \n"+e.toString());
  }
}