import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpp01/bloc/appDataBloc/appDataBloc.dart';
import 'package:kpp01/bloc/appDataBloc/appDataState.dart';
import 'package:kpp01/bloc/accountDataBloc/bloc.dart';
import 'package:kpp01/dataModel/appDataModel.dart';
import 'package:kpp01/dataModel/accountDataModel.dart';
import 'package:kpp01/dataModel/testDataModel.dart';
import 'package:kpp01/statePage.dart';
import 'package:kpp01/ui/profile/setting/settingPage.dart';
import 'package:http/http.dart' as http;
import 'package:kpp01/uiPlugin/myStepper/myStepper.dart';

class ProfileMainPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<AppDataBloc,AppDataState>(
      builder: (context,appDataState){
        AppDataModel appDataModel = _getAppDataModel(appDataState);
        return BlocBuilder<AccountDataBloc,AccountDataState>(
          builder: (context,accountDataState){
            if(accountDataState is AccountDataStateFinish){

              AccountDataModel accountDataModel = accountDataState.accountDataModel;
              return Scaffold(
                body: Stack(
                  children: <Widget>[
                    Container(
                      height: appDataModel.dataAppSizePlugin.height/3,
                      width: appDataModel.dataAppSizePlugin.width,
                      color: appDataModel.myThemeData.myThemeColor,
                    ),

                    Column(
                      //padding: EdgeInsets.all(appDataModel.dataAppSizePlugin.scaleW*10),
                      children: <Widget>[
                        Card(
                          margin: EdgeInsets.only(top: appDataModel.dataAppSizePlugin.height/3-appDataModel.dataAppSizePlugin.scaleW*50,left: appDataModel.dataAppSizePlugin.scaleW*50,right: appDataModel.dataAppSizePlugin.scaleW*50),
                          elevation: 2,
                          //color: Colors.deepPurpleAccent,
                          child: Container(
                            padding: EdgeInsets.all(appDataModel.dataAppSizePlugin.scaleW*12),
                            width: appDataModel.dataAppSizePlugin.scaleW*270,
                            height: appDataModel.dataAppSizePlugin.scaleW*100,
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
                                    padding: EdgeInsets.symmetric(horizontal: appDataModel.dataAppSizePlugin.scaleW*15),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(bottom: appDataModel.dataAppSizePlugin.scaleH*10),
                                          alignment: Alignment.centerLeft,
                                          //color: Colors.deepPurpleAccent,
                                          child: Text(accountDataModel.myName,style: TextStyle(fontWeight: FontWeight.w600,fontSize: appDataModel.dataAppSizePlugin.scaleFortSize*20),),
                                        ),
                                        Container(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[
                                                  Text("Test"),
                                                  Text(accountDataState.accountDataModel.myTestAnswerAllModelList.testAnswerAllModel.length.toString()),
                                                ],
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  Text("Pass"),
                                                  Text(_getPassAmount(accountDataState.accountDataModel.myTestAnswerAllModelList.testAnswerAllModel)),
                                                ],
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  Text("Fail"),
                                                  Text(_getFailAmount(accountDataState.accountDataModel.myTestAnswerAllModelList.testAnswerAllModel)),
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
                          child: MyNewStepper(),
                          //margin: EdgeInsets.symmetric(horizontal: appDataModel.dataAppSizePlugin.scaleW*70),
                        ),

                      ],
                    ),
                    Container(
                      //color: Colors.deepPurpleAccent,
                      width: appDataModel.dataAppSizePlugin.width,
                      height: 100,
                      margin: EdgeInsets.only(top: appDataModel.dataAppSizePlugin.scaleH*50,right: appDataModel.dataAppSizePlugin.scaleW*10),
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.settings,color: Colors.white,),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage()));
                        },
                      ),
                    ),
                  ],
                ),
              );
            }else{return StatePageError();}
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
  String _getPassAmount(List<TestAnswerAllModel> testAnswerAllModelList){
    int i = 0;
    for(TestAnswerAllModel testAnswerAllModel in testAnswerAllModelList){
      testAnswerAllModel.correctAmount >= 42 ? i++ : i = i;
    }
    return i.toString();
  }
  String _getFailAmount(List<TestAnswerAllModel> testAnswerAllModelList){
    int i = 0;
    for(TestAnswerAllModel testAnswerAllModel in testAnswerAllModelList){
      testAnswerAllModel.correctAmount >= 42 ? i = i : i++;
    }
    return i.toString();
  }
}