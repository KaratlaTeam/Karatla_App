
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:PPM/bloc/appDataBloc/appDataBloc.dart';
import 'package:PPM/bloc/getCodeBloc/bloc.dart';
import 'package:PPM/bloc/getCodeBloc/getCodeBloc.dart';
import 'package:PPM/bloc/internetCheckBloc/bloc.dart';
import 'package:PPM/bloc/registerBloc/registerBloc.dart';
import 'package:PPM/bloc/registerBloc/registerEvent.dart';
import 'package:PPM/bloc/registerBloc/registerState.dart';
import 'package:PPM/dataModel/appDataModel.dart';

import 'package:PPM/myPlugin/timerPluginWithBloc/bloc/bloc.dart';
import 'package:PPM/myPlugin/timerPluginWithBloc/ticker.dart';
import 'package:PPM/ui/register/registerAccountCreate.dart';

class RegisterCodeCheck extends StatefulWidget {
  @override
  _RegisterCodeCheckState createState() => _RegisterCodeCheckState();
}
class _RegisterCodeCheckState extends State<RegisterCodeCheck>{

  TextEditingController _textEditingController1;
  TextEditingController _textEditingController2;
  String _countryCode;


  @override
  void initState() {
    _textEditingController1 = TextEditingController(text: "");
    _textEditingController2 = TextEditingController(text: "");
    _countryCode = "60";
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController1.dispose();
    _textEditingController2.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    
    return BlocProvider(
      create: (context) => RegisterBloc(internetCheckBloc: BlocProvider.of<InternetCheckBloc>(context)),
      child: Scaffold(
        backgroundColor: BlocProvider.of<AppDataBloc>(context).appDataModel.myThemeData.mySkyBlue,
        appBar: AppBar(backgroundColor: BlocProvider.of<AppDataBloc>(context).appDataModel.myThemeData.mySkyBlue,iconTheme: IconThemeData(color: Colors.white),),
        body: BlocConsumer<RegisterBloc,RegisterState>(
          listener: (context,registerState){
            if(registerState is RegisterStateRegisterStart){
              showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return WillPopScope(
                      onWillPop: ()async{
                        return false;
                      },
                      child: Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }
              );
            }else if(registerState is RegisterStateRegisterFail){
              Navigator.pop(context);
              Scaffold.of(context).showSnackBar(SnackBar(content: Text(registerState.text)));
            }else if(registerState is RegisterStateError){
              Navigator.pop(context);
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("Code error, please check and try again")));
            } else if(registerState is RegisterStateRegisterSuccessful){
              Navigator.pop(context);
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("Successful")));
              Future.delayed(Duration(milliseconds: 500)).then((value) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => RegisterAccountCreate(phoneN: _countryCode + _textEditingController1.text,)));
              });

            }
          },
          builder: (context,registerState){
            AppDataModel appDataModel = BlocProvider.of<AppDataBloc>(context).appDataModel;
            return ListView(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Card(
                  //color: Colors.red,
                  margin: EdgeInsets.only(left: appDataModel.dataAppSizePlugin.scaleW*30,right: appDataModel.dataAppSizePlugin.scaleW*30,top: appDataModel.dataAppSizePlugin.scaleH*200),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    margin: EdgeInsets.all(appDataModel.dataAppSizePlugin.scaleW*30),
                    child: Column(
                      children: <Widget>[

                        TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                            LengthLimitingTextInputFormatter(12),
                          ],
                          controller: _textEditingController1,
                          //cursorColor: Colors.black,
                          keyboardType: TextInputType.phone,
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: "173242***",
                            labelText: "Phone",
                            prefixText: "$_countryCode-",
                          ),
                          onChanged: (text){
                            print("Phone: $text");
                          },

                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: appDataModel.dataAppSizePlugin.scaleW*180,
                              child: TextField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                controller: _textEditingController2,
                                //cursorColor: Colors.black,
                                keyboardType: TextInputType.phone,
                                //maxLength: 30,
                                maxLines: 1,
                                onChanged: (text){
                                  print("Code: $text");
                                  //_textEditingController2.text = text;
                                },
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: "Code",
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              width: appDataModel.dataAppSizePlugin.scaleW*100,
                              child: BlocProvider(
                                create: (BuildContext context) => TimerBloc(Ticker(),30),
                                child: BlocProvider(
                                  create:  (BuildContext context) => GetCodeBloc(internetCheckBloc: BlocProvider.of<InternetCheckBloc>(context), timerBloc: BlocProvider.of<TimerBloc>(context)),
                                  child: BlocBuilder<TimerBloc,TimerState>(
                                    builder: (context,timerState){
                                      return BlocListener<GetCodeBloc, GetCodeState>(
                                        listener: (context,getCodeState){
                                          if(getCodeState is GetCodeStateError){
                                            Scaffold.of(context).showSnackBar(SnackBar(content: Text("Get code fail, please check and try later!")));

                                          }else if(getCodeState is GetCodeStateFail){
                                            Scaffold.of(context).showSnackBar(SnackBar(content: Text(getCodeState.text)));

                                          }

                                        },
                                        child: _getCodeTime(BlocProvider.of<TimerBloc>(context), timerState, context),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),

                      ],
                    ),
                  ),
                ),

                Container(
                  //color: Colors.deepPurpleAccent,
                  margin: EdgeInsets.symmetric(vertical: appDataModel.dataAppSizePlugin.scaleH*40,horizontal: appDataModel.dataAppSizePlugin.scaleW*150),
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    color: appDataModel.myThemeData.myWhiteBlue,
                    child: Text("Submit"),
                    onPressed: (){
                      BlocProvider.of<RegisterBloc>(context).add(RegisterEventCodeRegister(
                        phone: _countryCode + _textEditingController1.text,
                        code: _textEditingController2.text,
                      ));
                    },
                  ),
                  //margin: EdgeInsets.only(top: appDataModel.dataAppSizePlugin.scaleH*50),
                ),

              ],
            );
          },
        ),
      ),
    );
  }

  _getCodeTime(TimerBloc timerBloc,TimerState timerState, BuildContext context) {
    if (timerState is Running) {
      return FlatButton(
        child: Text("${timerState.duration} S"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onPressed: null,
      );
    } else {
      return FlatButton(
        child: Text("Get Code"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onPressed: () async{

          BlocProvider.of<GetCodeBloc>(context).add(GetCodeEventStart(text: _textEditingController1.text, countryCode: _countryCode));
        },
      );
    }
  }

}