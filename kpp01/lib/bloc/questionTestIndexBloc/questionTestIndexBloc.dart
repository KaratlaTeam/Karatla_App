
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpp01/bloc/questionTestIndexBloc/bloc.dart';
import 'package:kpp01/dataModel/testDataModel.dart';
import 'package:kpp01/myPlugin/mathFunction.dart';

class QuestionTestIndexBloc extends Bloc<QuestionTestIndexEvent,QuestionTestIndexState>{
  QuestionTestIndexBloc():super(QuestionTestIndexStateGettingIndex());


  @override
  Stream<QuestionTestIndexState> mapEventToState(QuestionTestIndexEvent event) async*{
    if(event is QuestionTestIndexEventGetIndex){
      yield* _mapStartToGetTestIndex(event);
    }
  }


  Stream<QuestionTestIndexState> _mapStartToGetTestIndex(QuestionTestIndexEventGetIndex getIndex)async*{
    yield QuestionTestIndexStateGettingIndex();
    List<TestQuestionIndexListPart> testQuestionIndexList ;
    try{
      testQuestionIndexList = _getTestIndexList();
      yield QuestionTestIndexStateGotIndex(testQuestionIndexList: testQuestionIndexList);
    }catch(e){
      yield QuestionTestIndexStateError(e: e);
    }
  }

  List<TestQuestionIndexListPart> _getTestIndexList(){
    MathFunction mathFunction = MathFunction();
    List<int> partOneIndex = mathFunction.getRandom(15, 150);
    List<int> partTwoIndex = mathFunction.getRandom(25, 250);
    List<int> partThreeIndex = mathFunction.getRandom(10, 100);
    return [
      TestQuestionIndexListPart(testQuestionIndexListPartList: partOneIndex),
      TestQuestionIndexListPart(testQuestionIndexListPartList: partTwoIndex),
      TestQuestionIndexListPart(testQuestionIndexListPartList: partThreeIndex),
    ];
  }
}