
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpp01/bloc/appDataBloc/bloc.dart';
import 'package:kpp01/bloc/accountDataBloc/bloc.dart';
import 'package:kpp01/bloc/questionDataBloc/bloc.dart';
import 'package:kpp01/bloc/questionFavoriteBloc/bloc.dart';
import 'package:kpp01/bloc/questionPageBloc/bloc.dart';
import 'package:kpp01/dataModel/appDataModel.dart';
import 'package:kpp01/dataModel/questionPageModel.dart';
import 'package:kpp01/dataModel/questionPartModel.dart';
import 'package:flutter/material.dart';
import 'package:kpp01/myPlugin/MyThemeData.dart';
import 'package:kpp01/myPlugin/dataAppSizePlugin.dart';
import 'package:kpp01/uiPlugin/questionPage/questionBody.dart';
import 'package:kpp01/uiPlugin/questionPage/questionBottom.dart';

class LearningPartPage extends StatelessWidget{

  const LearningPartPage({
    Key key,
    this.partId,
    this.questionPageBloc,
    this.questionDataBloc,
    this.questionFavoriteBloc,
    this.partListNumber,
  }):super(key:key);

  final int partId;
  final QuestionPageBloc questionPageBloc;
  final QuestionDataBloc questionDataBloc;
  final String partListNumber;
  final QuestionFavoriteBloc questionFavoriteBloc;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<AppDataBloc,AppDataState>(
      builder: (context,appDataState){
        AppDataModel appDataModel = _getAppDataModel(appDataState);

        return BlocBuilder<QuestionPageBloc,QuestionPageState>(
          cubit: questionPageBloc,
          builder: (context,questionPageState){

            List pageDataList = _getQuestionPageDataList(partId , questionPageState);
            PageController pageController = pageDataList[0];
            int pageIndex = pageDataList[1];

            return BlocBuilder<QuestionDataBloc,QuestionDataState>(
              cubit: questionDataBloc,
              builder: (context,questionDataState){

                List questionData = _getQuestionData(questionDataState);
                List<QuestionData> questionList = questionData[0];
                List<List<String>> answerLetterList = questionData[1];

                return Scaffold(
                  appBar: AppBar(
                    title: Text('Part ${partId.toString()}'),
                    centerTitle: false,
                  ),
                  body: PageView.builder(
                    controller: pageController,
                    itemCount: questionList.length,
                    onPageChanged: (int page){
                      questionPageBloc.add(QuestionPageEventChangePagePartNumber(pageIndex: page, partID: partId));
                    },
                    itemBuilder: (BuildContext context,int index){
                      return QuestionBody(
                        onTap: null,
                        dataQuestionDetail: questionList[index].question.questionDetail,
                        dataQuestionChoices: questionList[index].question.questionDetailChoice,
                        dataQuestionImage: questionList[index].question.questionDetailImages,
                        dataChoicesDetail: questionList[index].choices.choiceDetail,
                        dataChoiceImage: questionList[index].choices.choiceImage,
                        answerLetterList: answerLetterList,
                        getLetterColors: (int key){
                          return  _getLetterColors(key,answerLetterList,questionList[index].answer,appDataModel.myThemeData);
                        },
                      );
                    },
                  ),
                  bottomSheet: BlocBuilder<QuestionFavoriteBloc,QuestionFavoriteState>(
                    cubit: questionFavoriteBloc,
                    builder: (context,questionFavoriteState){
                      return QuestionBottom(
                        dataLength: questionList.length,
                        pageIndex: pageIndex,
                        bottomSheetOnTap: (int key){
                          pageController.jumpToPage(key);
                          questionPageBloc.add(QuestionPageEventChangePagePartNumber(pageIndex: key, partID: partId));
                        },
                        iconButton: IconButton(
                          icon:  _getBottomIcon(partId, questionFavoriteState, pageIndex),
                          onPressed: (){
                            questionFavoriteBloc.add(QuestionFavoriteEventOnPressed(questionIndex: pageIndex, questionPartId: partId,));
                          },
                        ),
                        getLetterColors: (int key){
                          return _getBottomLetterColors(pageIndex, key,appDataModel.myThemeData);
                        },
                      );
                    },
                  ),
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

  List<Color> _getLetterColors(int index,List answerLetterList, String dataAnswer,MyThemeData myThemeData){
    if(dataAnswer != answerLetterList[0][index]){
      return [Colors.black,myThemeData.myWhiteBlue];
    }else{
      return [Colors.white,Color(0xFF87CEFA)];
    }
  }

  List _getQuestionPageDataList(int partId, QuestionPageState questionPageState){

    QuestionPageModel questionPageModel;
    PageController pageController ;
    int pageIndex ;

    if(questionPageState is QuestionPageStatePageChanged){
      questionPageModel =  questionPageState.questionPageModel;
    }
    switch(partId){
      case 1:
        pageController = questionPageModel.pageControllerPart1;
        pageIndex = questionPageModel.pageIndexPart1;
        break;
      case 2:
        pageController = questionPageModel.pageControllerPart2;
        pageIndex = questionPageModel.pageIndexPart2;
        break;
      case 3:
        pageController = questionPageModel.pageControllerPart3;
        pageIndex = questionPageModel.pageIndexPart3;
        break;
    }

    return [pageController,pageIndex,questionPageModel];
  }

  List _getQuestionData(QuestionDataState questionDataState){
    List<QuestionData> questionList;
    List<List<String>> answerLetterList;
    if(questionDataState is QuestionDataStateGotQuestionData){
      if(partListNumber == "One"){
        questionList = questionDataState.questionDataList.partOneList;
      }else if(partListNumber == "Two"){
        questionList = questionDataState.questionDataList.partTwoList;
      }else if(partListNumber == "Three"){
        questionList = questionDataState.questionDataList.partThreeList;
      }
      answerLetterList = questionDataState.questionDataList.answerLetterList;
      return [questionList,answerLetterList];
    }else{
      return null;
    }
  }

  _getBottomLetterColors(int pageIndex,int gridIndex,MyThemeData myThemeData){
    if(pageIndex == gridIndex){
      return [Colors.white,Color(0xFF87CEFA)];
    }else {
      return [Colors.black,myThemeData.myWhiteBlue];
    }
  }

  Icon _getBottomIcon(int partId,QuestionFavoriteState questionFavoriteState,int pageIndex){
    if(questionFavoriteState is QuestionFavoriteStateOnPressedFinished){
      if(partId == 1){
        if(questionFavoriteState.accountDataModel.myFavoriteListPartList.myFavoriteListPart1.myFavoriteListPart1.contains(pageIndex)==true){
          return Icon(Icons.star);
        }else{
          return Icon(Icons.star_border);
        }
      }else if(partId == 2){
        if(questionFavoriteState.accountDataModel.myFavoriteListPartList.myFavoriteListPart2.myFavoriteListPart2.contains(pageIndex)==true){
          return Icon(Icons.star);
        }else{
          return Icon(Icons.star_border);
        }
      }else if(partId == 3){
        if(questionFavoriteState.accountDataModel.myFavoriteListPartList.myFavoriteListPart3.myFavoriteListPart3.contains(pageIndex)==true){
          return Icon(Icons.star);
        }else{
          return Icon(Icons.star_border);
        }
      }else{
        return null;
      }
    }else{
      return Icon(Icons.star_border);
    }

  }
}

