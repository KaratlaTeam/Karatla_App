import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:PPM/bloc/appDataBloc/appDataBloc.dart';
import 'package:PPM/bloc/appDataBloc/appDataState.dart';
import 'package:PPM/dataModel/appDataModel.dart';
import 'package:PPM/dataModel/questionDataModel.dart';
import 'package:PPM/myPlugin/MyThemeData.dart';
import 'package:PPM/uiPlugin/questionPage/questionBody.dart';

class TestResultDetailPage extends StatelessWidget{

  TestResultDetailPage({
    Key key,
    this.questionData,
    this.selectedAnswer,
    this.answerLetter,
    this.choicesLetter,
}):super(key:key);

  final QuestionData questionData;
  final String selectedAnswer;
  //final List<List<String>> answerLetterList;
  final List<String> answerLetter;
  final List<String> choicesLetter;

  @override
  Widget build(BuildContext context) {
    //print("TestResultDetailPage rebuild");
    //  
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
            answerLetter: answerLetter,
            choicesLetter: choicesLetter,
            getLetterColors: (int key){
              return _getLetterColors(key, answerLetter, questionData.answer ,selectedAnswer,appDataModel.myThemeData);
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

  List<Color> _getLetterColors(int index,List answerLetter, String correctAnswer,String selectedAnswer,MyThemeData myThemeData){
    if(correctAnswer == answerLetter[index]){
      return [Colors.white,Colors.green];
    }else if(selectedAnswer != "No answer"){
      if(selectedAnswer != correctAnswer && selectedAnswer == answerLetter[index]){
        return [Colors.white,Colors.red];
      }else{
        return [Colors.black,myThemeData.myWhiteBlue];
      }
    }else{
      return [Colors.black,myThemeData.myWhiteBlue];
    }
  }

}