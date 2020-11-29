
import 'package:flutter/cupertino.dart';
import 'package:PPM/dataModel/accountDataModel.dart';

abstract class QuestionFavoriteState{
  const QuestionFavoriteState();
}

class QuestionFavoriteStateOnPressedProcessing extends QuestionFavoriteState{
  const QuestionFavoriteStateOnPressedProcessing();
}

class QuestionFavoriteStateOnPressedFinished extends QuestionFavoriteState{
  const QuestionFavoriteStateOnPressedFinished(this.accountDataModel);
  final AccountDataModel accountDataModel;
}

class QuestionFavoriteStateError extends QuestionFavoriteState{
  final e;
  const QuestionFavoriteStateError({@required this.e});
  backError(){
    return print("QuestionFavoriteStateError: \n"+e.toString());
  }
}