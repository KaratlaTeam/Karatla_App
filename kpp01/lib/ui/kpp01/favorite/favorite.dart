
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpp01/bloc/appDataBloc/appDataBloc.dart';
import 'package:kpp01/bloc/appDataBloc/appDataState.dart';
import 'package:kpp01/bloc/accountDataBloc/bloc.dart';
import 'package:kpp01/bloc/questionDataBloc/bloc.dart';
import 'package:kpp01/bloc/questionFavoriteBloc/bloc.dart';
import 'package:kpp01/bloc/questionPageBloc/bloc.dart';
import 'package:kpp01/dataModel/appDataModel.dart';
import 'package:kpp01/dataModel/accountDataModel.dart';
import 'package:kpp01/dataModel/questionPageModel.dart';
import 'package:kpp01/dataModel/questionPartModel.dart';
import 'package:kpp01/dataModel/testDataModel.dart';
import 'package:kpp01/myPlugin/MyThemeData.dart';
import 'package:kpp01/myPlugin/timerPluginWithBloc/bloc/bloc.dart';
import 'package:kpp01/myPlugin/timerPluginWithBloc/ticker.dart';
import 'package:flutter/material.dart';
import 'package:kpp01/uiPlugin/questionPage/questionBody.dart';
import 'package:kpp01/uiPlugin/questionPage/questionBottom.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({
    Key key,
    this.questionPageBloc,
    this.questionDataBloc,
    this.partId,
    this.questionFavoriteBloc,
  }) :super(key: key);

  final QuestionPageBloc questionPageBloc;
  final QuestionDataBloc questionDataBloc;
  final int partId;
  final QuestionFavoriteBloc questionFavoriteBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppDataBloc,AppDataState>(
      builder: (context,appDataState){
        AppDataModel appDataModel = _getAppDataModel(appDataState);

        return BlocBuilder<QuestionPageBloc,QuestionPageState>(
          cubit: questionPageBloc,
          builder: (context,questionPageState){

            QuestionPageModel questionPageModel = _getQuestionPageModel(questionPageState);
            PageController pageController = questionPageModel.pageControllerPartFavorite;
            int pageIndex = questionPageModel.pageIndexPartFavorite;

            return BlocBuilder<QuestionDataBloc,QuestionDataState>(
              cubit: questionDataBloc,
              builder: (context,questionDataState){

                QuestionDataList questionDataList = _getQuestionDataList(questionDataState);
                List<List<String>> answerLetterList  = questionDataList.answerLetterList;

                return BlocBuilder<QuestionFavoriteBloc,QuestionFavoriteState>(
                  cubit: questionFavoriteBloc,
                  builder: (context, questionFavoriteState){
                    AccountDataModel accountDataModel;
                    if(questionFavoriteState is QuestionFavoriteStateOnPressedFinished){
                          //accountDataModel = accountDataState.accountDataModel;
                          accountDataModel = questionFavoriteState.accountDataModel;
                        }
                        
                      List<int> favoritePart1 = accountDataModel.myFavoriteListPartList.myFavoriteListPart1.myFavoriteListPart1;
                        List<int> favoritePart2 = accountDataModel.myFavoriteListPartList.myFavoriteListPart2.myFavoriteListPart2;
                        List<int> favoritePart3 = accountDataModel.myFavoriteListPartList.myFavoriteListPart3.myFavoriteListPart3;
                        List<List<int>> favoriteList = [favoritePart1,favoritePart2,favoritePart3];
                        int favoriteAmount = favoritePart1.length+favoritePart2.length+favoritePart3.length;

                        if(favoriteAmount == 0){
                          return Scaffold(
                            appBar: AppBar(),
                            body: Center(child: Text("No favorite question!"),),
                          );
                        }else{
                          return Scaffold(
                            appBar: AppBar(
                              title: Text('Favorite'),
                              centerTitle: false,
                            ),

                            body: PageView.builder(
                              controller: pageController,
                              itemCount: favoriteAmount,
                              onPageChanged: (int page) {
                                questionPageBloc.add(QuestionPageEventChangePagePartNumber(pageIndex: page, partID: partId));
                              },
                              itemBuilder: (BuildContext context, int index) {
                                List dataAndIndex = _getDataAndQuestionIndex(questionDataList, index, favoriteList);
                                QuestionData data = dataAndIndex[0];
                                int questionIndex = dataAndIndex[1];

                                return QuestionBody(
                                  dataQuestionDetail: data.question.questionDetail,
                                  dataQuestionChoices: data.question.questionDetailChoice,
                                  dataQuestionImage: data.question.questionDetailImages,
                                  dataChoicesDetail: data.choices.choiceDetail,
                                  dataChoiceImage: data.choices.choiceImage,
                                  answerLetterList: answerLetterList,
                                  getLetterColors: (int key) {
                                    return _getLetterColors(key, answerLetterList,data.answer,appDataModel.myThemeData);
                                  },
                                  onTap: null,
                                );
                              },
                            ),

                            bottomSheet: QuestionBottom(
                              dataLength: favoriteAmount,
                              pageIndex: pageIndex,
                              bottomSheetOnTap: (int key){
                                pageController.jumpToPage(key);
                                questionPageBloc.add(QuestionPageEventChangePagePartNumber(pageIndex: key, partID: _getPartIdAndQuestionIndex(key,favoriteList)[0]));
                              },
                              iconButton: IconButton(
                                icon: _getBottomIcon(accountDataModel, pageIndex,favoriteList),
                                onPressed: (){
                                  if(favoriteAmount > 1 && pageIndex != 0){
                                    pageController.jumpToPage(pageIndex-1);
                                    questionPageBloc.add(QuestionPageEventChangePagePartNumber(pageIndex: pageIndex-1, partID: _getPartIdAndQuestionIndex(pageIndex-1,favoriteList)[0]));
                                  }

                                  questionFavoriteBloc.add(QuestionFavoriteEventOnPressed(
                                    questionIndex: _getPartIdAndQuestionIndex(pageIndex,favoriteList)[1],
                                    questionPartId: _getPartIdAndQuestionIndex(pageIndex,favoriteList)[0],
                                  ));
                                },
                              ),
                              getLetterColors: (int key) {
                                return _getBottomLetterColors(pageIndex, key,appDataModel.myThemeData);
                              },
                            ),
                          );
                        }
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  AppDataModel _getAppDataModel(AppDataState appDataState){
    if(appDataState is AppDataStateGotData){
      return appDataState.appDataModel;
    }else{
      return null;
    }
  }

  QuestionPageModel _getQuestionPageModel(QuestionPageState questionPageState){
    if(questionPageState is QuestionPageStatePageChanged){
      return questionPageState.questionPageModel;
    }else{
      return null;
    }
  }

  QuestionDataList _getQuestionDataList(QuestionDataState questionDataState){
    if(questionDataState is QuestionDataStateGotQuestionData){
      return questionDataState.questionDataList;
    }else{
      return null;
    }
  }


  List _getDataAndQuestionIndex(QuestionDataList questionDataList,int index,List<List<int>> testList ){
    QuestionData data;
    int questionIndex;
    int part1Length = testList[0].length;
    int part2Length = testList[1].length;
    int part3Length = testList[2].length;

    if (index <part1Length&&index>=0) {
      questionIndex = testList[0][index];
      data = questionDataList.partOneList[questionIndex];
    } else if (index < part2Length+part1Length && index >= part1Length) {
      questionIndex = testList[1][index - part1Length];
      data = questionDataList.partTwoList[questionIndex];
    } else if (index < part1Length+part2Length+part3Length && index >= part1Length+part2Length) {
      questionIndex = testList[2][index - part1Length-part2Length];
      data = questionDataList.partThreeList[questionIndex];
    }
    return [data,questionIndex];
  }

  List<Color> _getLetterColors(int index,List answerLetterList, String dataAnswer,MyThemeData myThemeData){
    if(dataAnswer != answerLetterList[0][index]){
      return [Colors.black,myThemeData.myWhiteBlue];
    }else{
      return [Colors.white,myThemeData.myThemeColor];
    }
  }


  _getBottomLetterColors(int pageIndex,int gridIndex,MyThemeData myThemeData){
    if(pageIndex == gridIndex){
      return [Colors.white,myThemeData.myThemeColor];
    }else {
      return [Colors.black,myThemeData.myWhiteBlue];
    }
  }

  Icon _getBottomIcon(AccountDataModel accountDataModel,int pageIndex,List<List<int>> testList){
    List<int> partIdAndQuestionIndex = _getPartIdAndQuestionIndex(pageIndex,testList);
    int partId = partIdAndQuestionIndex[0];
    int questionIndex = partIdAndQuestionIndex[1];
    if(partId == 1){
      if(accountDataModel.myFavoriteListPartList.myFavoriteListPart1.myFavoriteListPart1.contains(questionIndex)==true){
        return Icon(Icons.star);
      }else{
        return Icon(Icons.star_border);
      }
    }else if(partId == 2){
      if(accountDataModel.myFavoriteListPartList.myFavoriteListPart2.myFavoriteListPart2.contains(questionIndex)==true){
        return Icon(Icons.star);
      }else{
        return Icon(Icons.star_border);
      }
    }else if(partId == 3){
      if(accountDataModel.myFavoriteListPartList.myFavoriteListPart3.myFavoriteListPart3.contains(questionIndex)==true){
        return Icon(Icons.star);
      }else{
        return Icon(Icons.star_border);
      }
    }else{
      return null;
    }

  }

  List<int> _getPartIdAndQuestionIndex(int pageIndex,List<List<int>> testList){
    int part1Length = testList[0].length;
    int part2Length = testList[1].length;
    int part3Length = testList[2].length;

    if (pageIndex <part1Length && pageIndex >= 0) {
      return [1,testList[0][pageIndex]];
    } else if (pageIndex < part2Length+part1Length && pageIndex >= part1Length) {
      return [2,testList[1][pageIndex-part1Length]];
    } else if (pageIndex < part1Length+part2Length+part3Length && pageIndex >= part1Length+part2Length) {
      return [3,testList[2][pageIndex-part2Length-part1Length]];
    }else{
      return null;
    }

  }

}
