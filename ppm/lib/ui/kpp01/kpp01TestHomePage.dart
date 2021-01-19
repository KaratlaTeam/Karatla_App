import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:PPM/bloc/appDataBloc/appDataBloc.dart';
import 'package:PPM/bloc/appDataBloc/appDataState.dart';
import 'package:PPM/bloc/accountDataBloc/bloc.dart';
import 'package:PPM/bloc/internetCheckBloc/bloc.dart';
import 'package:PPM/bloc/questionDataBloc/bloc.dart';
import 'package:PPM/bloc/questionFavoriteBloc/bloc.dart';
import 'package:PPM/bloc/questionPageBloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:PPM/bloc/questionTestBloc/bloc.dart';
import 'package:PPM/bloc/systemLanguage/systemLanguage_bloc.dart';
import 'package:PPM/dataModel/appDataModel.dart';
import 'package:PPM/dataModel/questionPageModel.dart';
import 'package:PPM/dataModel/systemLanguageModel.dart';
import 'package:PPM/dataModel/testDataModel.dart';
import 'package:PPM/statePage.dart';
import 'package:PPM/ui/kpp01/favorite/favorite.dart';
import 'package:PPM/ui/kpp01/history/testHistory.dart';
import 'package:PPM/ui/kpp01/learning/learning.dart';
import 'package:PPM/ui/kpp01/quiz/testPage.dart';
import 'package:PPM/uiPlugin/myCircleButton.dart';
import 'package:provider/provider.dart';

class Kpp01TestHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: MultiProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => QuestionDataBloc(
            internetCheckBloc: BlocProvider.of<InternetCheckBloc>(context),
            systemLanguageBloc: BlocProvider.of<SystemLanguageBloc>(context),
          )..add(QuestionDataEventGetQuestionData(systemLanguage: BlocProvider.of<SystemLanguageBloc>(context).systemLanguageModel.codeString())),
        ),
        BlocProvider(
          create: (BuildContext context) => QuestionPageBloc(QuestionPageModel()),
        ),
        BlocProvider(
          create: (BuildContext context) => QuestionTestBloc(List<TestAnswerModel>(50),BlocProvider.of<AccountDataBloc>(context).accountDataModel),
        ),
        BlocProvider(
          create: (BuildContext context) => QuestionFavoriteBloc(BlocProvider.of<AccountDataBloc>(context).accountDataModel),
        ),
      ],
      child: Scaffold(
        body: BlocBuilder<QuestionDataBloc,QuestionDataState>(
          builder: (context,state){
            if(state is QuestionDataStateGettingQuestionData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }else if(state is QuestionDataStateGotQuestionData){
              return Kpp01TestHomePageDetail();
            }else if(state is QuestionDataStateError){
              return Center(
            child: RaisedButton(
              onPressed: (){
                BlocProvider.of<QuestionDataBloc>(context)
                            .add(QuestionDataEventCheckInternetThenGet(systemLanguage: BlocProvider.of<SystemLanguageBloc>(context).systemLanguageModel.codeString()));
              }, 
            child: Text("Refresh"),),
          );
            }else{
              return Container();
            }
          },
        ),
      ),
    ),
    );
  }
}

class Kpp01TestHomePageDetail extends StatefulWidget{
  @override
  _Kpp01TestHomePageDetailState createState() => _Kpp01TestHomePageDetailState();
}

class _Kpp01TestHomePageDetailState extends State<Kpp01TestHomePageDetail>{

  // ignore: close_sinks
  QuestionPageBloc _questionPageBloc;
  // ignore: close_sinks
  QuestionDataBloc _questionDataBloc;
  // ignore: close_sinks
  QuestionTestBloc _questionTestBloc;
  // ignore: close_sinks
  QuestionFavoriteBloc _questionFavoriteBloc;

  @override
  void initState() {
    _questionPageBloc = BlocProvider.of<QuestionPageBloc>(context);
    _questionDataBloc = BlocProvider.of<QuestionDataBloc>(context);
    _questionTestBloc = BlocProvider.of<QuestionTestBloc>(context);
    _questionFavoriteBloc = BlocProvider.of<QuestionFavoriteBloc>(context);
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return BlocBuilder<AppDataBloc,AppDataState>(
      builder: (context,appDataState){
        AppDataModel appDataModel = _getAppDataModel(appDataState);
        SystemLanguageModel sl = BlocProvider.of<SystemLanguageBloc>(context).systemLanguageModel;
        return Scaffold(
          body: Container(
            //color: Colors.amber,
            child: Column(
              children: <Widget>[
                Flexible(
                  fit: FlexFit.tight,
                  flex: 1,
                  child: Container(
                    //color: Colors.blue,
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.only(left: appDataModel.dataAppSizePlugin.scaleW*50),
                    child: RichText(
                      text: TextSpan(
                        text: sl.kpp01TestHomePageKPP01,
                        style: TextStyle(fontSize: appDataModel.dataAppSizePlugin.scaleFortSize*30,fontWeight: FontWeight.w500, color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(text: 'v${_questionDataBloc.questionDataModel.questionDataModelDetail.version}', style: TextStyle(fontSize: appDataModel.dataAppSizePlugin.scaleFortSize*15, color: Colors.grey),)
                        ]
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 5,
                  fit: FlexFit.tight,
                  child: GridView(
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: appDataModel.dataAppSizePlugin.scaleH*100,horizontal: appDataModel.dataAppSizePlugin.scaleW*40),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: appDataModel.dataAppSizePlugin.scaleH*30,
                      crossAxisSpacing: appDataModel.dataAppSizePlugin.scaleW*30,
                      childAspectRatio: 0.9,
                    ),
                    children: <Widget>[
                      MyOpenContainer(
                         // margin: EdgeInsets.symmetric(horizontal: 10,vertical: 50),
                         closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          closedColor: Colors.white,
                          openColor: Colors.white,
                          height: appDataModel.dataAppSizePlugin.scaleW*100,
                          width: appDataModel.dataAppSizePlugin.scaleW*100,
                          closedBuilder: (BuildContext context,VoidCallback openContainer){
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: appDataModel.dataAppSizePlugin.scaleW*15,vertical: appDataModel.dataAppSizePlugin.scaleH*5),
                                  child: Image.asset("assets/images/kpp01Main/quiz.png",fit: BoxFit.cover,),
                                ),
                                Text(sl.kpp01TestHomePageQuiz),
                              ],
                            );
                          },
                          openContainerBuilder: (BuildContext context,VoidCallback _) {
                            return TestPage(
                              questionDataBloc: _questionDataBloc,
                              questionPageBloc: _questionPageBloc,
                              questionTestBloc: _questionTestBloc,
                              questionFavoriteBloc: _questionFavoriteBloc,
                              partId: 4,
                            );
                          }
                      ),
                      MyOpenContainer(
                          //margin: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                          closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          closedColor: Colors.white,
                          openColor: Colors.white,
                          height: appDataModel.dataAppSizePlugin.scaleW*100,
                          width: appDataModel.dataAppSizePlugin.scaleW*100,
                          closedBuilder: (BuildContext context,VoidCallback openContainer){
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: appDataModel.dataAppSizePlugin.scaleW*15,vertical: appDataModel.dataAppSizePlugin.scaleH*5),
                                  child: Image.asset("assets/images/kpp01Main/open-book.png",fit: BoxFit.cover),
                                ),
                                Text(sl.kpp01TestHomePagePractice),
                              ],
                            );
                          },
                          openContainerBuilder: (BuildContext context,VoidCallback _) {
                            return LearningPage(
                              questionPageBloc: _questionPageBloc,
                              questionDataBloc: _questionDataBloc,
                              questionFavoriteBloc: _questionFavoriteBloc,
                            );
                          }
                      ),
                      MyOpenContainer(
                       // margin: EdgeInsets.symmetric(horizontal: 40,vertical: 30),
                        closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        closedColor: Colors.white,
                        openColor: Colors.white,
                        height: appDataModel.dataAppSizePlugin.scaleW*100,
                        width: appDataModel.dataAppSizePlugin.scaleW*100,
                        closedBuilder: (BuildContext context,VoidCallback openContainer){
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: appDataModel.dataAppSizePlugin.scaleW*15,vertical: appDataModel.dataAppSizePlugin.scaleH*5),
                                child: Image.asset("assets/images/kpp01Main/history.png",fit: BoxFit.cover,),
                              ),
                              Text(sl.kpp01TestHomePageHistory),
                            ],
                          );
                        },
                        openContainerBuilder: (BuildContext context,VoidCallback _) => TestHistory(
                          questionTestBloc: _questionTestBloc,
                          questionDataBloc: _questionDataBloc,
                        ),
                      ),
                      MyOpenContainer(
                        //margin: EdgeInsets.symmetric(horizontal: 40,vertical: 30),
                        closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        closedColor: Colors.white,
                        openColor: Colors.white,
                        height: appDataModel.dataAppSizePlugin.scaleW*100,
                        width: appDataModel.dataAppSizePlugin.scaleW*100,
                        closedBuilder: (BuildContext context,VoidCallback openContainer){
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: appDataModel.dataAppSizePlugin.scaleW*15,vertical: appDataModel.dataAppSizePlugin.scaleH*5),
                                child: Image.asset("assets/images/kpp01Main/star.png",fit: BoxFit.cover,width: appDataModel.dataAppSizePlugin.scaleW*120,),
                              ),
                              Text(sl.kpp01TestHomePageFavorite),
                            ],
                          );
                        },
                        openContainerBuilder: (BuildContext context,VoidCallback _) {
                          return FavoritePage(
                            partId: 5,
                            questionFavoriteBloc: _questionFavoriteBloc,
                            questionDataBloc: _questionDataBloc,
                            questionPageBloc: _questionPageBloc,
                          );
                        },
                      ),
                    ],
                  ),
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
