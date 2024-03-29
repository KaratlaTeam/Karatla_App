import 'package:flutter/cupertino.dart';
import 'package:PPM/dataModel/questionDataModel.dart';

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