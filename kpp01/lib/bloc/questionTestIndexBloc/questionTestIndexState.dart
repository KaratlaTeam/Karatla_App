
import 'package:flutter/cupertino.dart';
import 'package:kpp01/dataModel/testDataModel.dart';

abstract class QuestionTestIndexState{
  const QuestionTestIndexState();
}

class QuestionTestIndexStateGettingIndex extends QuestionTestIndexState{

}

class QuestionTestIndexStateGotIndex extends QuestionTestIndexState{
  const QuestionTestIndexStateGotIndex({@required this.testQuestionIndexList});
  final List<TestQuestionIndexListPart> testQuestionIndexList ;
}

class QuestionTestIndexStateError extends QuestionTestIndexState{
  const QuestionTestIndexStateError({@required this.e});
  final e;
  backError(){
    return print("QuestionTestIndexStateError: \n"+e.toString());
  }
}