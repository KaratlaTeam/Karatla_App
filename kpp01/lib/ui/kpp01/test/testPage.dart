import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpp01/bloc/appDataBloc/appDataBloc.dart';
import 'package:kpp01/bloc/appDataBloc/appDataState.dart';
import 'package:kpp01/bloc/accountDataBloc/bloc.dart';
import 'package:kpp01/bloc/questionDataBloc/bloc.dart';
import 'package:kpp01/bloc/questionFavoriteBloc/bloc.dart';
import 'package:kpp01/bloc/questionPageBloc/bloc.dart';
import 'package:kpp01/dataModel/appDataModel.dart';
import 'package:kpp01/dataModel/finishTestModel.dart';
import 'package:kpp01/dataModel/questionDataModel.dart';
import 'package:kpp01/dataModel/questionPageModel.dart';
import 'package:kpp01/bloc/questionTestBloc/bloc.dart';
import 'package:kpp01/bloc/questionTestIndexBloc/bloc.dart';
import 'package:kpp01/dataModel/testDataModel.dart';
import 'package:kpp01/myPlugin/MyThemeData.dart';
import 'package:kpp01/myPlugin/dataAppSizePlugin.dart';
import 'package:kpp01/myPlugin/timerPluginWithBloc/bloc/bloc.dart';
import 'package:kpp01/myPlugin/timerPluginWithBloc/ticker.dart';
import 'package:flutter/material.dart';
import 'package:kpp01/statePage.dart';
import 'package:kpp01/ui/kpp01/test/testResult.dart';
import 'package:kpp01/uiPlugin/myWillPopScope.dart';
import 'package:kpp01/uiPlugin/questionPage/questionBody.dart';
import 'package:kpp01/uiPlugin/questionPage/questionBottom.dart';

class TestPage extends StatefulWidget {
  const TestPage({
    Key key,
    this.questionPageBloc,
    this.questionDataBloc,
    this.questionTestBloc,
    this.partId,
    this.questionFavoriteBloc,
  }) :super(key: key);

  final QuestionPageBloc questionPageBloc;
  final QuestionDataBloc questionDataBloc;
  final QuestionTestBloc questionTestBloc;
  final int partId;
  final QuestionFavoriteBloc questionFavoriteBloc;

  @override
  _TestPageState createState() => _TestPageState();
}
class _TestPageState extends State<TestPage>{

  @override
  void initState() {
    widget.questionTestBloc.add(QuestionTestEventStartTest());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: BlocProvider(
        create: (BuildContext context) => QuestionTestIndexBloc()..add(QuestionTestIndexEventGetIndex()),
        child: BlocBuilder<QuestionTestIndexBloc,QuestionTestIndexState>(
          builder: (context,questionTestIndexState){
            if(questionTestIndexState is QuestionTestIndexStateGettingIndex){
              return Center(
                child: CircularProgressIndicator(),
              );
            }else if(questionTestIndexState is QuestionTestIndexStateGotIndex){
              List<TestQuestionIndexListPart> testList = questionTestIndexState.testQuestionIndexList;
              return TestPageDetail(
                questionPageBloc: widget.questionPageBloc,
                questionDataBloc: widget.questionDataBloc,
                questionTestBloc: widget.questionTestBloc,
                partId: widget.partId,
                testList: testList,
                questionFavoriteBloc: widget.questionFavoriteBloc,
              );
            }else if(questionTestIndexState is QuestionTestIndexStateError){
              return StatePageError();
            } else{
              return StatePageError();
            }
          },
        )
      ),
    );
  }


}

class TestPageDetail extends StatelessWidget{

  const TestPageDetail({
    Key key,
    this.questionPageBloc,
    this.questionDataBloc,
    this.questionTestBloc,
    this.partId,
    this.testList,
    this.questionFavoriteBloc,
  }):super(key:key);

  final QuestionPageBloc questionPageBloc;
  final QuestionDataBloc questionDataBloc;
  final QuestionTestBloc questionTestBloc;
  final int partId;
  final List<TestQuestionIndexListPart> testList ;
  final QuestionFavoriteBloc questionFavoriteBloc;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) => TimerBloc(Ticker(),3000)..add(Start(duration: 3000)),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<QuestionTestBloc,QuestionTestState>(
            cubit: questionTestBloc,
            listener: (context,questionTestState){
            },
          ),
          BlocListener<TimerBloc,TimerState>(
            /// times out
            listener: (context,timerState){
              if(timerState.duration == 0){
                questionPageBloc.add(QuestionPageEventChangePagePartNumber(pageIndex: 0, partID: 4));
                questionTestBloc.add(QuestionTestEventFinishTest(
                  finishTestModel: FinishTestModel(timeSpendSecond: timerState.duration,testQuestionIndexList: testList),
                ));
              }
            },
          ),
        ],
        child: BlocBuilder<AppDataBloc,AppDataState>(
          builder: (context,appDataState){
            AppDataModel appDataModel = _getAppDataModel(appDataState);

            return BlocBuilder<QuestionPageBloc,QuestionPageState>(
              cubit: questionPageBloc,
              builder: (context,questionPageState){

                QuestionPageModel questionPageModel = _getQuestionPageModel(questionPageState);
                PageController pageController = questionPageModel.pageControllerPartTest;
                int pageIndex = questionPageModel.pageIndexPartTest;

                return BlocBuilder<QuestionDataBloc,QuestionDataState>(
                  cubit: questionDataBloc,
                  builder: (context,questionDataState){

                    QuestionDataModel questionDataModel = QuestionDataModel();
                    if(questionDataState is QuestionDataStateGotQuestionData){
                       questionDataModel = questionDataState.questionDataModel;
                       }

                    return BlocBuilder<QuestionTestBloc,QuestionTestState>(
                      cubit: questionTestBloc,
                      builder: (context,questionTestState){
                        //int testAnswerDataAllLength = questionTestState.testDataModel.testAnswerDataAll.length;

                        if(questionTestState is QuestionTestStateFinishTestFinished ){
                          return TestResult(
                            questionDataModel: questionDataModel,
                            testQuestionIndexList: testList,
                            testAnswerModelList: questionTestState.accountDataModel.myTestAnswerAllModelList.testAnswerAllModel.last.testAnswerModelList,
                          );
                        }else if(questionTestState is QuestionTestStateFinishTestProcessing){
                          return Scaffold(
                            body: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }else if(questionTestState is QuestionTestStateError){
                          return StatePageError();
                        }else{
                          return BlocBuilder<TimerBloc, TimerState>(
                            builder: (context, timerState) {
                              /// stop test
                              return MyWillPopScope(
                                pause: true,
                                flatButtonL: FlatButton(
                                  onPressed: () {
                                    questionPageBloc.add(QuestionPageEventChangePagePartNumber(pageIndex: 0, partID: 4));
                                    questionTestBloc.add(QuestionTestEventStopTest());
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Yes"),
                                ),
                                flatButtonR: FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    BlocProvider.of<TimerBloc>(context).add(Resume());
                                  },
                                  child: Text("No"),
                                ),
                                child: Scaffold(
                                  //backgroundColor: Colors.white,
                                  appBar: AppBar(
                                    title: Text('Test'),
                                    centerTitle: false,
                                    elevation: 0,
                                    actions: <Widget>[
                                      Container(
                                        margin: EdgeInsets.symmetric(horizontal: 30),
                                        child: Text(_getTime(timerState.duration)),
                                      ),
                                    ],
                                  ),

                                  body: PageView.builder(
                                    controller: pageController,
                                    itemCount: 50,
                                    onPageChanged: (int page) {
                                      questionPageBloc.add(QuestionPageEventChangePagePartNumber(pageIndex: page, partID: partId));
                                    },
                                    itemBuilder: (BuildContext context, int index) {
                                      List dataAndIndex = _getDataAndQuestionIndex(questionTestState, questionDataModel, index, testList);
                                      QuestionData data = dataAndIndex[0];
                                      int questionIndex = dataAndIndex[1];

                                      return QuestionBody(
                                        dataQuestionDetail: data.question.questionDetail,
                                        dataQuestionChoices: data.question.questionDetailChoice,
                                        dataQuestionImage: data.question.questionDetailImages,
                                        dataChoicesDetail: data.choices.choiceDetail,
                                        dataChoiceImage: data.choices.choiceImage,
                                        answerLetter: questionDataModel.questionDataModelDetail.answerLetter,
                                        choicesLetter: questionDataModel.questionDataModelDetail.choicesLetter,
                                        getLetterColors: (int key) {
                                          return _getLetterColors(index, key, questionDataModel.questionDataModelDetail.answerLetter, appDataModel.myThemeData);
                                        },
                                        onTap: (int key) {
                                          _onSelected(index, key, questionDataModel.questionDataModelDetail.answerLetter, questionIndex, data);
                                        },
                                      );
                                    },
                                  ),

                                  bottomSheet: BlocBuilder<QuestionFavoriteBloc,QuestionFavoriteState>(
                                    cubit: questionFavoriteBloc,
                                    builder: (context,questionFavoriteState){
                                      return QuestionBottom(
                                        dataLength: 50,
                                        pageIndex: pageIndex,
                                        bottomSheetOnTap: (int key){
                                          pageController.jumpToPage(key);
                                          questionPageBloc.add(QuestionPageEventChangePagePartNumber(pageIndex: key, partID: 4));
                                        },
                                        iconButton: IconButton(
                                          icon: _getBottomIcon(questionFavoriteState, pageIndex),
                                          onPressed: (){
                                            questionFavoriteBloc.add(QuestionFavoriteEventOnPressed(
                                              questionIndex: _getPartIdAndQuestionIndex(pageIndex)[1],
                                              questionPartId: _getPartIdAndQuestionIndex(pageIndex)[0],
                                            ));
                                          },
                                        ),
                                        getLetterColors: (int key) {
                                          return _getBottomLetterColors(pageIndex, key,appDataModel.myThemeData);
                                        },
                                      );
                                    },
                                  ),

                                  floatingActionButton: FloatingActionButton.extended(
                                    label: Text('Finish',style: TextStyle(color: Colors.white),),
                                    elevation: 2,
                                    backgroundColor: Colors.redAccent,
                                    onPressed: () {
                                      BlocProvider.of<TimerBloc>(context).add(Pause());
                                      showDialog(context: context, builder: (build) {
                                        return WillPopScope(
                                          onWillPop: () async {
                                            return false;
                                          },
                                          /// finish test
                                          child: SimpleDialog(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                            title: Text("Do you want to finish this test ?"),
                                            children: <Widget>[
                                              FlatButton(
                                                onPressed: () {
                                                  questionPageBloc.add(QuestionPageEventChangePagePartNumber(pageIndex: 0, partID: 4));
                                                  questionTestBloc.add(QuestionTestEventFinishTest(
                                                    finishTestModel: FinishTestModel(timeSpendSecond: timerState.duration,testQuestionIndexList: testList),
                                                  ));
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Yes"),
                                              ),
                                              FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  BlocProvider.of<TimerBloc>(context).add(Resume());
                                                },
                                                child: Text("No"),
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                    },
                                  ),
                                  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                                ),
                              );
                            },
                          );
                        }
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),

    );
  }

  AppDataModel _getAppDataModel(AppDataState appDataState){
    if(appDataState is AppDataStateGotData){
      return appDataState.appDataModel;
    }else{
      return null;
    }
  }

  String _getTime(int duration){
    final String hoursStr = ((duration / 60) / 60).floor().toString().padLeft(2, '0');
    final String minutesStr = ((duration / 60)%60).floor().toString().padLeft(2, '0');
    final String secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
    return "$hoursStr:$minutesStr:$secondsStr";
  }

  QuestionPageModel _getQuestionPageModel(QuestionPageState questionPageState){
    if(questionPageState is QuestionPageStatePageChanged){
      return questionPageState.questionPageModel;
    }else{
      return null;
    }
  }


  List _getDataAndQuestionIndex(QuestionTestState questionTestState,QuestionDataModel questionDataModel,int index,List<TestQuestionIndexListPart> testList ){
    QuestionData data;
    int questionIndex;/// from 0 to ~

    if (index < 15 && index >= 0) {
      questionIndex = testList[0].testQuestionIndexListPartList[index];
      data = questionDataModel.questionDataModelDetail.questionPart1.questionData[questionIndex];
    } else if (index >= 15 && index < 40) {
    questionIndex = testList[1].testQuestionIndexListPartList[index - 15];
    data = questionDataModel.questionDataModelDetail.questionPart2.questionData[questionIndex];
    } else if (index >= 40 && index < 50) {
    questionIndex = testList[2].testQuestionIndexListPartList[index - 40];
    data = questionDataModel.questionDataModelDetail.questionPart3.questionData[questionIndex];
    }
    return [data,questionIndex];
  }

  List<Color> _getLetterColors(int pageIndex,int letterIndex,List answerLetter,MyThemeData myThemeData){
    if(questionTestBloc.testAnswerModelList[pageIndex]!= null){
      if(questionTestBloc.testAnswerModelList[pageIndex].selectedAnswer != answerLetter[letterIndex]){
        return [Colors.black,myThemeData.myWhiteBlue];
      }else{
        return [Colors.white,myThemeData.myThemeColor];
      }
    }else{
      return [Colors.black,myThemeData.myWhiteBlue];
    }
  }

  _onSelected(int pageIndex,int letterIndex,List answerLetter,int questionIndex,QuestionData data){
    TestAnswerModel testAnswerModel = TestAnswerModel(
      pageIndex: pageIndex,
      questionIndex: questionIndex,
      selectedAnswer: answerLetter[letterIndex],
      correctAnswer:  data.answer,
    );
    questionTestBloc.add(QuestionTestEventChangeTestAnswerData(testAnswerModel: testAnswerModel),);
    print(answerLetter[letterIndex]);
    if(answerLetter[letterIndex]==data.answer){
      print('true');
    }else{
      print("false");
    }
  }

  _getBottomLetterColors(int pageIndex,int gridIndex,MyThemeData myThemeData){
    if(pageIndex == gridIndex){
      return [Colors.white,myThemeData.myThemeColor];
    }else {
      if(questionTestBloc.testAnswerModelList[gridIndex] != null){
        return [Colors.white,myThemeData.unSelectColor];
      }else{
        return [Colors.black,myThemeData.myWhiteBlue];
      }
    }
  }

  Icon _getBottomIcon(QuestionFavoriteState questionFavoriteState,int pageIndex){
    int partId = _getPartIdAndQuestionIndex(pageIndex)[0];
    int questionIndex = _getPartIdAndQuestionIndex(pageIndex)[1];
    if(questionFavoriteState is QuestionFavoriteStateOnPressedFinished){
      if(partId == 1){
        if(questionFavoriteState.accountDataModel.myFavoriteListPartList.myFavoriteListPart1.myFavoriteListPart1.contains(questionIndex)==true){
          return Icon(Icons.star);
        }else{
          return Icon(Icons.star_border);
        }
      }else if(partId == 2){
        if(questionFavoriteState.accountDataModel.myFavoriteListPartList.myFavoriteListPart2.myFavoriteListPart2.contains(questionIndex)==true){
          return Icon(Icons.star);
        }else{
          return Icon(Icons.star_border);
        }
      }else if(partId == 3){
        if(questionFavoriteState.accountDataModel.myFavoriteListPartList.myFavoriteListPart3.myFavoriteListPart3.contains(questionIndex)==true){
          return Icon(Icons.star);
        }else{
          return Icon(Icons.star_border);
        }
      }else{
        return null;
      }
    }
    else{
      return Icon(Icons.star_border);
    }
  }

  List<int> _getPartIdAndQuestionIndex(int pageIndex){
    if (pageIndex < 15 && pageIndex >= 0) {
      return [1,testList[0].testQuestionIndexListPartList[pageIndex]];
    } else if (pageIndex >= 15 && pageIndex < 40) {
      return [2,testList[1].testQuestionIndexListPartList[pageIndex-15]];
    } else if (pageIndex >= 40 && pageIndex < 50) {
      return [3,testList[2].testQuestionIndexListPartList[pageIndex-40]];
    }else{
      return null;
    }
  }

}
