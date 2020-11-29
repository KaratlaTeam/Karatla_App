
import 'package:bloc/bloc.dart';
import 'package:PPM/bloc/questionTestBloc/bloc.dart';
import 'package:PPM/dataModel/finishTestModel.dart';
import 'package:PPM/dataModel/accountDataModel.dart';
import 'package:PPM/dataModel/testDataModel.dart';

class QuestionTestBloc extends Bloc<QuestionTestEvent,QuestionTestState>{
  QuestionTestBloc(this.testAnswerModelList, this.accountDataModel):
        super(QuestionTestStateFinishTestFinished(accountDataModel: accountDataModel));

  //final TestDataModel testDataModel ;
  List<TestAnswerModel> testAnswerModelList;
  final AccountDataModel accountDataModel ;


  @override
  Stream<QuestionTestState> mapEventToState(QuestionTestEvent event) async* {
    if(event is QuestionTestEventChangeTestAnswerData){
      yield* _mapStartToChangeTestAnswerData(event);
    }else if( event is QuestionTestEventFinishTest){
      yield* _mapStartToFinishTest(event);
    }else if(event is QuestionTestEventStartTest){
      yield QuestionTestStateTestStartStarting();
      yield QuestionTestStateTestStartStarted();
    }else if(event is QuestionTestEventStopTest){
      yield QuestionTestStateTestStopStarting();
      _initialData();
      yield QuestionTestStateTestStopStopped();
    }
  }

  @override
  Future<void> close() {
    _initialData();
    return super.close();
  }

  Stream<QuestionTestState> _mapStartToChangeTestAnswerData(QuestionTestEventChangeTestAnswerData changeTestAnswerData)async*{
    yield QuestionTestStateTestAnswerDataChanging();
    TestAnswerModel testAnswerModel;
    try{
      testAnswerModel = changeTestAnswerData.testAnswerModel;
      testAnswerModelList[testAnswerModel.pageIndex] = testAnswerModel;

      yield QuestionTestStateTestAnswerDataChanged();
    }catch(e){
      yield QuestionTestStateError(e: e);
    }
  }

  Stream<QuestionTestState> _mapStartToFinishTest(QuestionTestEventFinishTest finishTest)async*{
    FinishTestModel finishTestModel = finishTest.finishTestModel;
    TestAnswerAllModel testAnswerAllModel;
    yield QuestionTestStateFinishTestProcessing();
    try{
      testAnswerAllModel = _addTestAnswerAllModel(finishTestModel.testQuestionIndexList, finishTestModel.timeSpendSecond);
      this.accountDataModel.myTestAnswerAllModelList.testAnswerAllModel.add(testAnswerAllModel);

      await accountDataModel.setSharePTest();


      _initialData();
      yield QuestionTestStateFinishTestFinished(accountDataModel: this.accountDataModel);
    }catch(e){
      yield QuestionTestStateError(e: e)..backError();
    }

  }

    TestAnswerAllModel _addTestAnswerAllModel(List<TestQuestionIndexListPart> testQuestionIndexList,int timeSpendSecond){
    TestAnswerAllModel testAnswerAllModel;
    timeSpendSecond = 3000 - timeSpendSecond;
    int _correctAmount = 0;
    for(TestAnswerModel i in this.testAnswerModelList){
      if(i != null){
        if(i.selectedAnswer == i.correctAnswer){
          _correctAmount++;
        }
      }
    }
    DateTime dateTime = DateTime.now();
    List<int> time = [dateTime.year,dateTime.month,dateTime.day,dateTime.hour,dateTime.minute,dateTime.second];
    testAnswerAllModel = TestAnswerAllModel(
      testAnswerModelList: testAnswerModelList,
      testQuestionIndexList: testQuestionIndexList,
      timeSpendSecond: timeSpendSecond,
      time: time,
      correctAmount: _correctAmount,
    );
    return testAnswerAllModel;
  }

  _initialData(){
    this.testAnswerModelList = List<TestAnswerModel>(50);
  }

}