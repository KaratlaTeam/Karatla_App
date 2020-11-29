import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:PPM/bloc/appDataBloc/appDataBloc.dart';
import 'package:PPM/bloc/appDataBloc/bloc.dart';
import 'package:PPM/bloc/questionDataBloc/bloc.dart';
import 'package:PPM/bloc/questionFavoriteBloc/bloc.dart';
import 'package:PPM/bloc/questionPageBloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:PPM/dataModel/appDataModel.dart';
import 'package:PPM/ui/kpp01/learning/learningPartPage.dart';
import 'package:PPM/uiPlugin/myCircleButton.dart';

class LearningPage extends StatelessWidget{

  const LearningPage({
    Key key,
    @required this.questionPageBloc,
    @required this.questionDataBloc,
    @required this.questionFavoriteBloc,
  }):super(key:key);

  final QuestionPageBloc questionPageBloc;
  final QuestionDataBloc questionDataBloc;
  final QuestionFavoriteBloc questionFavoriteBloc;

  @override
  Widget build(BuildContext context) {
    //  
    return BlocBuilder<AppDataBloc,AppDataState>(
      builder: (context,appDataState){
        AppDataModel appDataModel = _getAppDataModel(appDataState);
        return Scaffold(
          //backgroundColor: Colors.blue,
          appBar: AppBar(),
          body: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MyOpenContainer(
                  closedElevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  closedColor: Color(0xFF87CEFA),
                  openColor: Colors.white,
                  height: appDataModel.dataAppSizePlugin.scaleW*100,
                  width: appDataModel.dataAppSizePlugin.scaleW*100,
                  closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  closedBuilder: (BuildContext context,VoidCallback openContainer){
                    return Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Icon(Icons.looks_3,size: appDataModel.dataAppSizePlugin.scaleW*40,color: Colors.white,),
                        Container(
                          height: appDataModel.dataAppSizePlugin.scaleW*70,
                          width: appDataModel.dataAppSizePlugin.scaleW*70,
                          child: CircularProgressIndicator(
                            //backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            value: 0,
                            strokeWidth: appDataModel.dataAppSizePlugin.scaleW*5,
                          ),
                        ),
                      ],
                    );
                  },
                  openContainerBuilder: (BuildContext context,VoidCallback _){
                    return LearningPartPage(
                      partId: 3,
                      partListNumber: "Three",
                      questionPageBloc: questionPageBloc,
                      questionDataBloc: questionDataBloc,
                      questionFavoriteBloc: questionFavoriteBloc,
                    );
                  },
                ),
                MyOpenContainer(
                  closedElevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  closedColor: Color(0xFF87CEFA),
                  openColor: Colors.white,
                  height: appDataModel.dataAppSizePlugin.scaleW*100,
                  width: appDataModel.dataAppSizePlugin.scaleW*100,
                  closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  closedBuilder: (BuildContext context,VoidCallback openContainer){
                    return Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Icon(Icons.looks_two,size: appDataModel.dataAppSizePlugin.scaleW*40,color: Colors.white,),
                        Container(
                          height: appDataModel.dataAppSizePlugin.scaleW*70,
                          width: appDataModel.dataAppSizePlugin.scaleW*70,
                          child: CircularProgressIndicator(
                            //backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            value: 0.0,
                            strokeWidth: appDataModel.dataAppSizePlugin.scaleW*5,
                          ),
                        ),
                      ],
                    );
                  },
                  openContainerBuilder: (BuildContext context,VoidCallback _){
                    return LearningPartPage(
                      partId: 2,
                      partListNumber: "Two",
                      questionPageBloc: questionPageBloc,
                      questionDataBloc: questionDataBloc,
                      questionFavoriteBloc: questionFavoriteBloc,
                    );
                  },
                ),
                MyOpenContainer(
                  closedElevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  closedColor: Color(0xFF87CEFA),
                  openColor: Colors.white,
                  height: appDataModel.dataAppSizePlugin.scaleW*100,
                  width: appDataModel.dataAppSizePlugin.scaleW*100,
                  closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  closedBuilder: (BuildContext context,VoidCallback openContainer){
                    return Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Icon(Icons.looks_one,size: appDataModel.dataAppSizePlugin.scaleW*40,color: Colors.white,),
                        Container(
                          height: appDataModel.dataAppSizePlugin.scaleW*70,
                          width: appDataModel.dataAppSizePlugin.scaleW*70,
                          child: CircularProgressIndicator(
                            //backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            value: 0,
                            strokeWidth: appDataModel.dataAppSizePlugin.scaleW*5,
                          ),
                        ),
                      ],
                    );
                  },
                  openContainerBuilder: (BuildContext context,VoidCallback _){
                    return LearningPartPage(
                      partId: 1,
                      partListNumber: "One",
                      questionPageBloc: questionPageBloc,
                      questionDataBloc: questionDataBloc,
                      questionFavoriteBloc: questionFavoriteBloc,
                    );
                  },
                ),
              ],
            ),
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