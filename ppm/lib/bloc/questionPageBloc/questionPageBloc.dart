
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:PPM/dataModel/questionPageModel.dart';
import 'package:PPM/bloc/questionPageBloc/bloc.dart';

class QuestionPageBloc extends Bloc<QuestionPageEvent,QuestionPageState>{
  QuestionPageBloc(this.questionPageModel):
        assert(questionPageModel != null),
        super(QuestionPageStatePageChanged(questionPageModel: questionPageModel..initialPage()));

  final QuestionPageModel questionPageModel;


  @override
  Stream<QuestionPageState> mapEventToState(QuestionPageEvent event) async* {
    if(event is QuestionPageEventChangePagePartNumber){
      yield* _mapStartToChangePageNumber(event);
    }
  }

  Stream<QuestionPageState> _mapStartToChangePageNumber(QuestionPageEventChangePagePartNumber changePagePartNumber)async*{
    yield QuestionPageStatePageChanging();
    try{
      _changePagePartNumber(changePagePartNumber.pageIndex, changePagePartNumber.partID);
      yield QuestionPageStatePageChanged(questionPageModel: questionPageModel);
    }catch(e){
      yield QuestionPageStateError(e: e);
    }
  }

  @override
  Future<void> close(){
    questionPageModel.dispose();
    return super.close();
  }

  _changePagePartNumber(int pageIndex,int partId) {
    switch (partId) {
      case 1:
        questionPageModel.pageIndexPart1 = pageIndex ;
        questionPageModel.pageControllerPart1 = PageController(initialPage: pageIndex);
        break;
      case 2:
        questionPageModel.pageIndexPart2 = pageIndex ;
        questionPageModel.pageControllerPart2 = PageController(initialPage: pageIndex);
        break;
      case 3:
        questionPageModel.pageIndexPart3 = pageIndex ;
        questionPageModel.pageControllerPart3 = PageController(initialPage: pageIndex);
        break;
      case 4:
        questionPageModel.pageIndexPartTest = pageIndex ;
        break;
      case 5:
        questionPageModel.pageIndexPartFavorite = pageIndex ;
        questionPageModel.pageControllerPartFavorite = PageController(initialPage: pageIndex);
        break;
    }
  }

}