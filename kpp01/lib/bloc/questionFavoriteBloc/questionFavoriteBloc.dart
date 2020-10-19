
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:kpp01/bloc/questionFavoriteBloc/bloc.dart';
import 'package:kpp01/dataModel/accountDataModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionFavoriteBloc extends Bloc<QuestionFavoriteEvent,QuestionFavoriteState>{
  QuestionFavoriteBloc(this.accountDataModel):
        super(QuestionFavoriteStateOnPressedFinished(accountDataModel));

  final AccountDataModel accountDataModel ;


  @override
  Stream<QuestionFavoriteState> mapEventToState(QuestionFavoriteEvent event) async*{
    if(event is QuestionFavoriteEventOnPressed){
      yield* _mapEventToStartLike(event);
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }

  Stream<QuestionFavoriteState> _mapEventToStartLike(QuestionFavoriteEventOnPressed eventOnPressed)async*{
    yield QuestionFavoriteStateOnPressedProcessing();
    int index1 = this.accountDataModel.myFavoriteListPartList.myFavoriteListPart1.myFavoriteListPart1.indexOf(eventOnPressed.questionIndex);
    int index2 = this.accountDataModel.myFavoriteListPartList.myFavoriteListPart2.myFavoriteListPart2.indexOf(eventOnPressed.questionIndex);
    int index3 = this.accountDataModel.myFavoriteListPartList.myFavoriteListPart3.myFavoriteListPart3.indexOf(eventOnPressed.questionIndex);
    try{
      switch(eventOnPressed.questionPartId){
        case 1:
          if(accountDataModel.myFavoriteListPartList.myFavoriteListPart1.myFavoriteListPart1.contains(eventOnPressed.questionIndex) == false){
            accountDataModel.myFavoriteListPartList.myFavoriteListPart1.myFavoriteListPart1.add(eventOnPressed.questionIndex);
          }else{
            accountDataModel.myFavoriteListPartList.myFavoriteListPart1.myFavoriteListPart1.removeAt(index1);
          }
          break;
        case 2:
          if(accountDataModel.myFavoriteListPartList.myFavoriteListPart2.myFavoriteListPart2.contains(eventOnPressed.questionIndex) == false){
            accountDataModel.myFavoriteListPartList.myFavoriteListPart2.myFavoriteListPart2.add(eventOnPressed.questionIndex);
          }else{
            accountDataModel.myFavoriteListPartList.myFavoriteListPart2.myFavoriteListPart2.removeAt(index2);
          }
          break;
        case 3:
          if(accountDataModel.myFavoriteListPartList.myFavoriteListPart3.myFavoriteListPart3.contains(eventOnPressed.questionIndex) == false){
            accountDataModel.myFavoriteListPartList.myFavoriteListPart3.myFavoriteListPart3.add(eventOnPressed.questionIndex);
          }else{
            accountDataModel.myFavoriteListPartList.myFavoriteListPart3.myFavoriteListPart3.removeAt(index3);
          }
          break;
      }
      await accountDataModel.setSharePFavorite();
      yield QuestionFavoriteStateOnPressedFinished(accountDataModel);
    }catch(e){
      yield QuestionFavoriteStateError(e: e,)..backError();
    }
  }

}