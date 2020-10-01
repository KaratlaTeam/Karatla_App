import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpp01/bloc/appDataBloc/appDataBloc.dart';
import 'package:kpp01/bloc/appDataBloc/appDataState.dart';
import 'package:kpp01/dataModel/appDataModel.dart';
import 'package:kpp01/dataModel/questionPartModel.dart';
import 'package:kpp01/myPlugin/MyThemeData.dart';
import 'package:kpp01/myPlugin/dataAppSizePlugin.dart';
import 'package:kpp01/uiPlugin/questionPage/questionBody.dart';

class TestResultDetailPage extends StatelessWidget{

  TestResultDetailPage({
    Key key,
    this.questionData,
    this.selectedAnswer,
    this.answerLetterList,
}):super(key:key);

  final QuestionData questionData;
  final String selectedAnswer;
  final List<List<String>> answerLetterList;

  @override
  Widget build(BuildContext context) {
    //print("TestResultDetailPage rebuild");
    // TODO: implement build
    return BlocBuilder<AppDataBloc,AppDataState>(
      builder: (context,appDataState){
        AppDataModel appDataModel = _getAppDataModel(appDataState);

        return Scaffold(
          appBar: AppBar(),
          body: QuestionBody(
            dataQuestionDetail: questionData.question.questionDetail,
            dataQuestionChoices: questionData.question.questionDetailChoice,
            dataQuestionImage: questionData.question.questionDetailImages,
            dataChoicesDetail: questionData.choices.choiceDetail,
            dataChoiceImage: questionData.choices.choiceImage,
            answerLetterList: answerLetterList,
            getLetterColors: (int key){
              return _getLetterColors(key, answerLetterList, questionData.answer ,selectedAnswer,appDataModel.myThemeData);
            },
            onTap: null,
          ),
          ///bottomSheet: QuestionBottom(
          ///  dataLength: null,
          ///  pageController: null,
          ///  pageNumber: null,
          ///),
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

  List<Color> _getLetterColors(int index,List answerLetterList, String correctAnswer,String selectedAnswer,MyThemeData myThemeData){
    if(correctAnswer == answerLetterList[0][index]){
      return [Colors.white,Colors.green];
    }else if(selectedAnswer != "No answer"){
      if(selectedAnswer != correctAnswer && selectedAnswer == answerLetterList[0][index]){
        return [Colors.white,Colors.red];
      }else{
        return [Colors.black,myThemeData.myWhiteBlue];
      }
    }else{
      return [Colors.black,myThemeData.myWhiteBlue];
    }
  }

}