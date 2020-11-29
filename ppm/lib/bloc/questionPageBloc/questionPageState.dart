import 'package:flutter/cupertino.dart';
import 'package:PPM/dataModel/questionPageModel.dart';

abstract class QuestionPageState{
  const QuestionPageState();
}

class QuestionPageStatePageChanging extends QuestionPageState{
}

class QuestionPageStatePageChanged extends QuestionPageState{
  const QuestionPageStatePageChanged({@required this.questionPageModel}):assert(questionPageModel != null, );
  final QuestionPageModel questionPageModel;
}

class QuestionPageStateError extends QuestionPageState{
  final e;
  const QuestionPageStateError({@required this.e}):assert(e != null);
  backError(){
    return print("QuestionPageStateError: \n"+e.toString());
  }
}

