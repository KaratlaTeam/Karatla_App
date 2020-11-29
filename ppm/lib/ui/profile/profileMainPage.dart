import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:PPM/bloc/appDataBloc/appDataBloc.dart';
import 'package:PPM/bloc/appDataBloc/appDataState.dart';
import 'package:PPM/bloc/accountDataBloc/bloc.dart';
import 'package:PPM/bloc/schedeluBloc/schedeluBloc.dart';
import 'package:PPM/bloc/schedeluBloc/schedeluEvent.dart';
import 'package:PPM/bloc/schedeluBloc/schedeluState.dart';
import 'package:PPM/dataModel/appDataModel.dart';
import 'package:PPM/dataModel/accountDataModel.dart';
import 'package:PPM/dataModel/scheduleModel.dart';
import 'package:PPM/dataModel/testDataModel.dart';
import 'package:PPM/ui/profile/setting/settingPage.dart';
import 'package:PPM/uiPlugin/myStepper/myStepper.dart';
import 'package:PPM/uiPlugin/myTextField/myTextFaild.dart';

class ProfileMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SchedeluBloc(
          accountDataModel:
              BlocProvider.of<AccountDataBloc>(context).accountDataModel),
      child: BlocBuilder<AppDataBloc, AppDataState>(
        builder: (context, appDataState) {
          AppDataModel appDataModel = _getAppDataModel(appDataState);
          AccountDataModel accountDataModel =
              BlocProvider.of<AccountDataBloc>(context).accountDataModel;
          return Scaffold(
            body: Stack(
              children: <Widget>[
                Container(
                  height: appDataModel.dataAppSizePlugin.height / 3,
                  width: appDataModel.dataAppSizePlugin.width,
                  color: appDataModel.myThemeData.myThemeColor,
                ),
                Column(
                  //padding: EdgeInsets.all(appDataModel.dataAppSizePlugin.scaleW*10),
                  children: <Widget>[
                    Card(
                      margin: EdgeInsets.only(
                          top: appDataModel.dataAppSizePlugin.height / 3 -
                              appDataModel.dataAppSizePlugin.scaleW * 50,
                          left: appDataModel.dataAppSizePlugin.scaleW * 50,
                          right: appDataModel.dataAppSizePlugin.scaleW * 50),
                      elevation: 2,
                      //color: Colors.deepPurpleAccent,
                      child: Container(
                        padding: EdgeInsets.all(
                            appDataModel.dataAppSizePlugin.scaleW * 12),
                        width: appDataModel.dataAppSizePlugin.scaleW * 270,
                        height: appDataModel.dataAppSizePlugin.scaleW * 100,
                        child: Row(
                          children: <Widget>[
                            //GestureDetector(
                            //  onTap: (){
                            //    Navigator.push(context, MaterialPageRoute(builder: (context) {
                            //      return Scaffold(
                            //        backgroundColor: Colors.black,
                            //        appBar: AppBar(
                            //          iconTheme: IconThemeData(color: Colors.white),
                            //          //actionsIconTheme: IconThemeData(color: Colors.white),
                            //          backgroundColor: Colors.black,
                            //        ),
                            //        body: Center(
                            //          child: Image.asset(profileDataState.profileDataModel.photo,fit: BoxFit.cover,width: appDataModel.dataAppSizePlugin.width,),
                            //        ),
                            //      );
                            //    }));
                            //  },
                            //  child: Container(
                            //    //color: Colors.deepPurpleAccent,
                            //    child: ClipRect(
                            //      //borderRadius: BorderRadius.circular(10),
                            //      child: Image.asset(profileDataState.profileDataModel.photo,fit: BoxFit.cover,width: appDataModel.dataAppSizePlugin.scaleW*50,),
                            //    ),
                            //  ),
                            //),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        appDataModel.dataAppSizePlugin.scaleW *
                                            15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(
                                          bottom: appDataModel
                                                  .dataAppSizePlugin.scaleH *
                                              10),
                                      alignment: Alignment.centerLeft,
                                      //color: Colors.deepPurpleAccent,
                                      child: Text(
                                        accountDataModel.myName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: appDataModel
                                                    .dataAppSizePlugin
                                                    .scaleFortSize *
                                                20),
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Text("quiz"),
                                              Text(accountDataModel
                                                  .myTestAnswerAllModelList
                                                  .testAnswerAllModel
                                                  .length
                                                  .toString()),
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Text("Pass"),
                                              Text(_getPassAmount(
                                                  accountDataModel
                                                      .myTestAnswerAllModelList
                                                      .testAnswerAllModel)),
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              Text("Fail"),
                                              Text(_getFailAmount(
                                                  accountDataModel
                                                      .myTestAnswerAllModelList
                                                      .testAnswerAllModel)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      //color: Colors.red,
                      //height: appDataModel.dataAppSizePlugin.height*0.5,
                      child: BlocBuilder<SchedeluBloc, SchedeluState>(
                        builder: (context, schedeluState) {
                          SchedeluModel schedeluModel = SchedeluModel()
                            ..initialData();
                          if (schedeluState is SchedeluStateChanged) {
                            schedeluModel = schedeluState.schedeluModel;
                          }

                          return MyNewStepper(
                            index: schedeluModel.index,
                            date: schedeluModel.date,
                            time: schedeluModel.time,
                            content: schedeluModel.content,
                            isActive: schedeluModel.isActive,
                            onStepTapped: (int index) {
                              stepperEeditIndex(schedeluModel, context, index);
                            },
                            onStepContinue: () {
                              stepperEeditState(schedeluModel, context);
                            },
                            onStepCancel: () async {
                              await stepperEeditTime(schedeluModel, context);
                            },
                            onPressedMark: (TextEditingController
                                textEditingController) async {
                              await stepperEditMark(schedeluModel, context,
                                  textEditingController);
                            },
                          );
                        },
                      ),
                      //margin: EdgeInsets.symmetric(horizontal: appDataModel.dataAppSizePlugin.scaleW*70),
                    ),
                  ],
                ),
                Container(
                  //color: Colors.deepPurpleAccent,
                  width: appDataModel.dataAppSizePlugin.width,
                  height: 100,
                  margin: EdgeInsets.only(
                      top: appDataModel.dataAppSizePlugin.scaleH * 50,
                      right: appDataModel.dataAppSizePlugin.scaleW * 10),
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    onPressed: () {
                       Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingPage()));
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  AppDataModel _getAppDataModel(AppDataState appDataState) {
    if (appDataState is AppDataStateGotData) {
      return appDataState.appDataModel;
    } else {
      return null;
    }
  }

  String _getPassAmount(List<TestAnswerAllModel> testAnswerAllModelList) {
    int i = 0;
    for (TestAnswerAllModel testAnswerAllModel in testAnswerAllModelList) {
      testAnswerAllModel.correctAmount >= 42 ? i++ : i = i;
    }
    return i.toString();
  }

  String _getFailAmount(List<TestAnswerAllModel> testAnswerAllModelList) {
    int i = 0;
    for (TestAnswerAllModel testAnswerAllModel in testAnswerAllModelList) {
      testAnswerAllModel.correctAmount >= 42 ? i = i : i++;
    }
    return i.toString();
  }

  stepperEeditIndex(SchedeluModel schedeluModel, BuildContext context, int index) {
    schedeluModel.index = index;
    BlocProvider.of<SchedeluBloc>(context)
        .add(SchedeluEventChange(schedeluModel));
  }

  stepperEeditState(SchedeluModel schedeluModel, BuildContext context) {
    if (schedeluModel.isActive[schedeluModel.index] == false) {
      schedeluModel.isActive[schedeluModel.index] = true;
    } else {
      schedeluModel.isActive[schedeluModel.index] = false;
    }
    BlocProvider.of<SchedeluBloc>(context)
        .add(SchedeluEventChange(schedeluModel));
  }

  Future stepperEeditTime(SchedeluModel schedeluModel, BuildContext context) async {
    DateTime dateTime;
    DateTime dateTime2;

    var date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 2),
    );

    if (date != null) {
      var time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        helpText: "SELECT START TIME",
      );
      if (time != null) {
        var time2 = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          helpText: "SELECT FINISH TIME",
        );
        if (time2 != null) {
          dateTime =
              DateTime(date.year, date.month, date.day, time.hour, time.minute);

          dateTime2 = DateTime(
              date.year, date.month, date.day, time2.hour, time2.minute);

          print("$dateTime - $dateTime2");

          schedeluModel.date[schedeluModel.index] =
              "${date.month} - ${date.day} - ${date.year}";

          schedeluModel.time[schedeluModel.index] =
              "${time.hour} : ${time.minute} ~ ${time2.hour} : ${time2.minute}";

          BlocProvider.of<SchedeluBloc>(context)
              .add(SchedeluEventChange(schedeluModel));
        }
      }
    }
  }

  Future stepperEditMark(SchedeluModel schedeluModel, BuildContext context,
      TextEditingController textEditingController) async {
    showDialog(
        context: context,
        builder: (build) {
          return SimpleDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text("Mark Schedule"),
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: 50,
                width: 300,
                child: MyTextField(
                  lengthLimiting: 30,
                  filterPattern: RegExp("[a-zA-Z0-9!,.?\\s]"),
                  textEditingController: textEditingController,
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: FlatButton(
                  onPressed: () {
                    schedeluModel.content[schedeluModel.index] =
                        textEditingController.text;
                    BlocProvider.of<SchedeluBloc>(context)
                        .add(SchedeluEventChange(schedeluModel));
                    textEditingController.clear();
                    Navigator.pop(context);
                  },
                  child: Text("Ok"),
                ),
              ),
            ],
          );
        });
  }
}
