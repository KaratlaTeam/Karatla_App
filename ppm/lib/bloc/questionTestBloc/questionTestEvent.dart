
import 'package:PPM/dataModel/finishTestModel.dart';
import 'package:PPM/dataModel/testDataModel.dart';

class QuestionTestEvent{
  const QuestionTestEvent();
}

class QuestionTestEventChangeTestAnswerData extends QuestionTestEvent{
  const QuestionTestEventChangeTestAnswerData({this.testAnswerModel});
  final TestAnswerModel testAnswerModel;
}

class QuestionTestEventFinishTest extends QuestionTestEvent{
  const QuestionTestEventFinishTest({this.finishTestModel});
  final FinishTestModel finishTestModel;
}

class QuestionTestEventStartTest extends QuestionTestEvent{

}

class QuestionTestEventStopTest extends QuestionTestEvent{

}
