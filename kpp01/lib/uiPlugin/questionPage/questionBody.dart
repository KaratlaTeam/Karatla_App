
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpp01/bloc/appDataBloc/appDataBloc.dart';
import 'package:kpp01/bloc/appDataBloc/appDataState.dart';
import 'package:flutter/material.dart';
import 'package:kpp01/dataModel/appDataModel.dart';
import 'package:kpp01/typedef.dart';
import 'package:kpp01/uiPlugin/questionPage/questionBodyPart.dart';


class QuestionBody extends StatelessWidget{

  const QuestionBody({
    Key key,
    @required this.dataQuestionDetail,
    @required this.dataQuestionChoices,
    @required this.dataQuestionImage,
    @required this.dataChoicesDetail,
    @required this.dataChoiceImage,
    //@required this.answerLetterList,
    @required this.answerLetter,
    @required this.choicesLetter,
    @required this.getLetterColors,
    @required this.onTap,
  }):super(key:key);

  final String dataQuestionDetail;
  final List dataQuestionChoices;
  final List dataQuestionImage;
  final List dataChoicesDetail;
  final List dataChoiceImage;
  //final List<List<String>> answerLetterList;
  final List<String> answerLetter;
  final List<String> choicesLetter;
  final ListColorsWithIndexCallback getLetterColors;
  final IndexCallback onTap;

  @override
  Widget build(BuildContext context) {
    
    return BlocBuilder<AppDataBloc,AppDataState>(
      builder: (context,appDataState){
        AppDataModel appDataModel = _getAppDataModel(appDataState);
        return Container(
          //color: Colors.yellow,
          //padding: EdgeInsets.all(dataAppSizePlugin.scaleW*10),
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: appDataModel.dataAppSizePlugin.scaleW*10),
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: appDataModel.dataAppSizePlugin.scaleH*10),
                child: Text("  "+dataQuestionDetail, style: TextStyle(fontSize: appDataModel.dataAppSizePlugin.scaleFortSize*18,fontWeight: FontWeight.w500),),
              ),
              Container(
                //padding: EdgeInsets.symmetric(horizontal: dataAppSizePlugin.scaleW*10),
                child: QuestionBodyPart(
                  onTap: null,
                  direction: Axis.vertical,
                  answerLetterList: choicesLetter,
                  listData: dataQuestionChoices,
                  getLetterColors: (int index){
                    return [Colors.black,appDataModel.myThemeData.myWhiteBlue];
                  },
                ),
              ),
              Container(
                //padding: EdgeInsets.symmetric(horizontal: dataAppSizePlugin.scaleW*10),
                child:  QuestionBodyPart(
                  onTap: null,
                  direction: Axis.horizontal,
                  answerLetterList: choicesLetter,
                  listData: dataQuestionImage,
                  getLetterColors: (int index){
                    return [Colors.black,appDataModel.myThemeData.myWhiteBlue];
                  },
                ),
              ),
              Container(
                //padding: EdgeInsets.symmetric(horizontal: dataAppSizePlugin.scaleW*10),
                child: QuestionBodyPart(
                  onTap: onTap,
                  direction: Axis.vertical,
                  answerLetterList: answerLetter,
                  listData: dataChoicesDetail,
                  getLetterColors: getLetterColors,
                  hasAnswerLetter: true,
                ),
              ),
              Container(
                //padding: EdgeInsets.symmetric(horizontal: dataAppSizePlugin.scaleW*10),
                child: QuestionBodyPart(
                  onTap: onTap,
                  direction: Axis.horizontal,
                  answerLetterList: answerLetter,
                  listData: dataChoiceImage,
                  getLetterColors: getLetterColors,
                ),
              ),
            ],
          ),
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
}