import 'package:flutter/cupertino.dart';
import 'package:kpp01/dataModel/testDataModel.dart';

abstract class QuestionDataState{
  const QuestionDataState();
}

class QuestionDataStateGettingQuestionData extends QuestionDataState{
}

class QuestionDataStateGotQuestionData extends QuestionDataState{
  final QuestionDataList questionDataList;
  const QuestionDataStateGotQuestionData({@required this.questionDataList}):assert(questionDataList != null);
}

class QuestionDataStateError extends QuestionDataState{
  final e;
  const QuestionDataStateError({@required this.e}):assert(e != null);
  backError(){
    return print("QuestionDataStateError: \n"+e.toString());
  }
}