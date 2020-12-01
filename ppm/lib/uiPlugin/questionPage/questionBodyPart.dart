
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:PPM/bloc/appDataBloc/appDataBloc.dart';
import 'package:PPM/bloc/appDataBloc/appDataState.dart';
import 'package:PPM/dataModel/appDataModel.dart';
import 'package:PPM/httpSource.dart';
import 'package:PPM/typedef.dart';


class QuestionBodyPart extends StatelessWidget{

  const QuestionBodyPart({
    Key key,
    @required this.direction,
    @required this.answerLetterList,
    @required this.listData,
    @required this.getLetterColors,
    @required this.onTap,
    this.hasAnswerLetter:false,
  }):super(key:key);

  final Axis direction;
  final List<String> answerLetterList;
  final List listData;
  final ListColorsWithIndexCallback getLetterColors;
  final IndexCallback onTap;
  final bool hasAnswerLetter;

  @override
  Widget build(BuildContext context) {
    
    switch(direction){
      case Axis.horizontal:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _getList(),
        );
        break;
      case Axis.vertical:
        return Container(
          //color: Colors.red,
          child: Column(
            children: _getList(),
          ),
        );
        break;
      default:
        return Container();
        break;
    }
  }
  _getList() {
    List<Widget> listWidget = new List<Widget>();
    GestureDetector gestureDetector;
    listData.asMap().forEach((key, value) {
      gestureDetector = GestureDetector(
        onTap: (){
          if(onTap!= null){
            onTap(key);
          }
        },//onTap,
        child: SingleChoice(
          hasAnswerLetter: hasAnswerLetter,
          direction: direction,
          colors: getLetterColors(key),
          answerLetter: answerLetterList[key],
          value: value,
          listData: listData,
          single: listData.length == 1 ? true : false,
        ),
      );
      listWidget.add(gestureDetector);
    });
    return listWidget;
  }
}

class SingleChoice extends StatelessWidget{

  const SingleChoice({
    Key key,
    @required this.direction,
    @required this.colors,
    @required this.answerLetter,
    @required this.listData,
    @required this.value,
    @required this.single,
    this.hasAnswerLetter,
}):super(key:key);

  final Axis direction;
  final List<Color> colors;
  final String answerLetter;
  final List listData;
  final String value;
  final bool single;
  final bool hasAnswerLetter;
  
  @override
  Widget build(BuildContext context) {

    switch(direction){
      case Axis.horizontal:
        return BlocBuilder<AppDataBloc,AppDataState>(
          builder: (context,appDataState){
            AppDataModel appDataModel = _getAppDataModel(appDataState);
            return Container(
              margin: EdgeInsets.only(top: appDataModel.dataAppSizePlugin.scaleH*10),
              child: Column(
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: HttpSource.getQuestionImages+value,
                    width: single == false ? appDataModel.dataAppSizePlugin.scaleW*90 : appDataModel.dataAppSizePlugin.scaleW*300,
                    height: appDataModel.dataAppSizePlugin.scaleW*100,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.error),
                        //Text("Get image fail."),
                      ],
                    ),
                  ),
                  AnswerLetter(
                    colors:  colors,
                    answerLetter: answerLetter,
                  ),
                ],
              ),
            );
          },
        );
        break;
      case Axis.vertical:
        return BlocBuilder<AppDataBloc,AppDataState>(
          builder: (context,appDataState){
            AppDataModel appDataModel = _getAppDataModel(appDataState);
            return Container(
              //color: Colors.blue,
              margin: EdgeInsets.only(top: appDataModel.dataAppSizePlugin.scaleH*10,),
              child: Row(
                //mainAxisSize: MainAxisSize.max,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    //color: Colors.red,
                    child: AnswerLetter(
                      colors: colors,
                      answerLetter: answerLetter,
                    ),
                  ),
                  Flexible(
                    child: Container(
                      //color: Colors.yellow,
                      child: Text(value),
                    ),
                  ),
                ],
              ),
            );
          },
        );
        break;
      default:
        return Container();
        break;
    }
  }
  AppDataModel _getAppDataModel(AppDataState appDataState){
    if(appDataState is AppDataStateGotData){
      return appDataState.appDataModel;
    }else{
      return null;
    }
  }
}

class AnswerLetter extends StatelessWidget{

  const AnswerLetter({
    Key key,
    this.answerLetter,
    this.colors,
  }):super(key:key);

  final String answerLetter;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppDataBloc,AppDataState>(
      builder: (context,appDataState){
        AppDataModel appDataModel = _getAppDataModel(appDataState);
        return Container(
          alignment: Alignment.center,
          width: appDataModel.dataAppSizePlugin.scaleW*30,height: appDataModel.dataAppSizePlugin.scaleW*30,
          margin: EdgeInsets.only(right: appDataModel.dataAppSizePlugin.scaleW*10,left: appDataModel.dataAppSizePlugin.scaleW*10),
          child: Text(answerLetter,style: TextStyle(color: colors[0]),),
          decoration: BoxDecoration(color: colors[1],borderRadius: BorderRadius.circular(7)),
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
