
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:PPM/bloc/appDataBloc/appDataBloc.dart';
import 'package:PPM/bloc/checkLoginBloc/bloc.dart';
import 'package:PPM/bloc/loginBloc/bloc.dart';
import 'package:PPM/dataModel/appDataModel.dart';

import 'package:PPM/ui/register/registerCodeCheck.dart';


class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}
class _SignInPageState extends State<SignInPage>{

  TextEditingController _textEditingController1;
  TextEditingController _textEditingController2;
  String _loginType ;
  String _countryCode;


  @override
  void initState() {
    _textEditingController1 = TextEditingController(text: "");
    _textEditingController2 = TextEditingController(text: "");
    _loginType = "PHONE";
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
    //  
    return Scaffold(
      backgroundColor: BlocProvider.of<AppDataBloc>(context).appDataModel.myThemeData.mySkyBlue,
      body: BlocConsumer<LoginBloc,LoginState>(
        listener: (context,loginState){
          if(loginState is LoginStateSignProcess){
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
          }else if(loginState is LoginStateSignFail){
            Navigator.pop(context);
            Scaffold.of(context).showSnackBar(SnackBar(content: Text(loginState.text)));

          }else if(loginState is LoginStateSignError){
            Navigator.pop(context);
            Scaffold.of(context).showSnackBar(SnackBar(content: Text("Login account error, please check and try again")));

          }else if(loginState is LoginStateSignSuccessful){
            BlocProvider.of<CheckLoginBloc>(context).add(CheckLoginEventChangeToGood());
            Navigator.of(context).pop();

          }
        },
        builder: (context,loginState){
          AppDataModel appDataModel = BlocProvider.of<AppDataBloc>(context).appDataModel;
          return ListView(
            children: <Widget>[

              Container(
                height: appDataModel.dataAppSizePlugin.height,
                child: Column(
                  children: [
                    Container(
                      //color: Colors.red,
                      child: Image.asset("assets/images/logo/logo2.jpg",fit: BoxFit.contain, height: appDataModel.dataAppSizePlugin.scaleW*200,),
                      margin: EdgeInsets.symmetric(vertical: appDataModel.dataAppSizePlugin.scaleH*20,),
                      //alignment: Alignment.bottomCenter,
                    ),

                    Card(
                      margin: EdgeInsets.only(left: appDataModel.dataAppSizePlugin.scaleW*30, right: appDataModel.dataAppSizePlugin.scaleW*30,),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: Container(
                        margin: EdgeInsets.all(appDataModel.dataAppSizePlugin.scaleW*30),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                FlatButton(
                                  onPressed: (){
                                    setState(() {
                                      _loginType = "PHONE";
                                      _textEditingController1.text = '';
                                    });
                                  } ,
                                  child: Text("Phone"),
                                  textColor: _loginType == "PHONE" ? Colors.black : Colors.grey,
                                  splashColor: Colors.white,
                                  highlightColor: Colors.white,
                                ),
                                FlatButton(
                                  onPressed: (){
                                    setState(() {
                                      _loginType = "EMAIL";
                                      _textEditingController1.text = '';
                                    });
                                  },
                                  child: Text("Email",),
                                  textColor: _loginType == "EMAIL" ? Colors.black : Colors.grey,
                                  splashColor: Colors.white,
                                  highlightColor: Colors.white,
                                )
                              ],
                            ),
                            TextField(
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(_loginType == "PHONE" ? "[0-9]" : "[a-zA-Z0-9@.]")),
                                LengthLimitingTextInputFormatter(20),
                              ],
                              controller: _textEditingController1,
                              //cursorColor: Colors.black,
                              keyboardType: TextInputType.emailAddress,
                              maxLines: 1,
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: _loginType == "PHONE" ? "Phone" : "Email",
                                hintText: _loginType == "PHONE" ? "1732*****": "ppm@gmail.com",
                                prefixText: _loginType == "PHONE" ? "60-" : null,
                              ),
                              onChanged: (text){
                                print("Account: $text");
                              },
                            ),

                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 6,
                                  child: TextField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
                                      LengthLimitingTextInputFormatter(15),
                                    ],
                                    obscureText: true,
                                    controller: _textEditingController2,
                                    //cursorColor: Colors.black,
                                    keyboardType: TextInputType.text,
                                    //maxLength: 30,
                                    maxLines: 1,
                                    onChanged: (text){
                                      print("Password: $text");
                                      //_textEditingController2.text = text;
                                    },
                                    decoration: InputDecoration(
                                      border: UnderlineInputBorder(),
                                      labelText: "Password",
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
                      margin: EdgeInsets.symmetric(vertical: appDataModel.dataAppSizePlugin.scaleH*40, horizontal: appDataModel.dataAppSizePlugin.scaleW*150),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        color: appDataModel.myThemeData.myWhiteBlue,
                        child: Text("Login"),
                        onPressed: ()async{
                          BlocProvider.of<LoginBloc>(context).add(LoginEventSignIn(
                            loginType: _loginType,
                            loginAccount: _loginType == "PHONE" ? _countryCode + _textEditingController1.text : _textEditingController1.text,
                            password: _textEditingController2.text,
                            myDeviceIdNow: appDataModel.myDeviceData.deviceId,
                          ));
                          Future.delayed(Duration(seconds: 2));
                        },
                      ),
                      //margin: EdgeInsets.only(top: appDataModel.dataAppSizePlugin.scaleH*50),
                    ),
                    Expanded(
                      child: Container(
                        //color: Colors.red,
                        padding: EdgeInsets.only(right: appDataModel.dataAppSizePlugin.scaleW*20, bottom: appDataModel.dataAppSizePlugin.scaleH*50.0,),
                        alignment: Alignment.bottomRight,
                        child: FlatButton(
                          child: Text("Register",style: TextStyle(color: Colors.white),),
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterCodeCheck()));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}