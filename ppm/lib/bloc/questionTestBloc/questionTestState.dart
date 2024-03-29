
import 'package:PPM/dataModel/accountDataModel.dart';

abstract class QuestionTestState{

}

class QuestionTestStateTestAnswerDataChanging extends QuestionTestState{
}

class QuestionTestStateTestAnswerDataChanged extends QuestionTestState{
  //QuestionTestStateTestAnswerDataChanged({this.testDataModel});
  //final TestDataModel testDataModel;
}

class QuestionTestStateFinishTestProcessing extends QuestionTestState{

}
class QuestionTestStateFinishTestFinished extends QuestionTestState{
  QuestionTestStateFinishTestFinished({this.accountDataModel});
  //final TestDataModel testDataModel;
  final AccountDataModel accountDataModel ;
}

class QuestionTestStateTestStartStarting extends QuestionTestState{
}

class QuestionTestStateTestStartStarted extends QuestionTestState{
}

class QuestionTestStateTestStopStarting extends QuestionTestState{
}

class QuestionTestStateTestStopStopped extends QuestionTestState{
}

class QuestionTestStateError extends QuestionTestState{
  QuestionTestStateError({this.e});
  final e;
  backError(){
    return print("QuestionTestStateError: \n"+e.toString());
  }
}