
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpp01/bloc/appDataBloc/appDataBloc.dart';
import 'package:kpp01/bloc/internetCheckBloc/bloc.dart';
import 'package:kpp01/bloc/registerBloc/registerBloc.dart';
import 'package:kpp01/bloc/registerBloc/registerEvent.dart';
import 'package:kpp01/bloc/registerBloc/registerState.dart';
import 'package:kpp01/dataModel/appDataModel.dart';


class RegisterAccountCreate extends StatefulWidget {
  RegisterAccountCreate({
    Key key,
    this.phoneN,
}):super(key:key);

  final String phoneN;

  @override
  _RegisterAccountCreateState createState() => _RegisterAccountCreateState();
}
class _RegisterAccountCreateState extends State<RegisterAccountCreate>{

  TextEditingController _textEditingController1;
  TextEditingController _textEditingController2;
  TextEditingController _textEditingController3;

  bool _errorShow1 = false;
  bool _errorShow2 = false;
  bool _errorShow3 = false;


  @override
  void initState() {
    _textEditingController1 = TextEditingController(text: "");
    _textEditingController2 = TextEditingController(text: "");
    _textEditingController3 = TextEditingController(text: "");
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController1.dispose();
    _textEditingController2.dispose();
    _textEditingController3.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocProvider(create: (context) => RegisterBloc(internetCheckBloc: BlocProvider.of<InternetCheckBloc>(context)),
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
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("Register information error, please check and try again")));
            } else if(registerState is RegisterStateRegisterSuccessful){
              Navigator.pop(context);
              Scaffold.of(context).showSnackBar(SnackBar(content: Text("Successful")));
              Future.delayed(Duration(seconds: 1)).then((value) {
                Navigator.pop(context);
              });

            }
          },
          builder: (context,registerState){
            AppDataModel appDataModel = BlocProvider.of<AppDataBloc>(context).appDataModel;
            return ListView(
              children: <Widget>[

                Card(
                  //color: Colors.red,
                  margin: EdgeInsets.only(left: appDataModel.dataAppSizePlugin.scaleW*30,right: appDataModel.dataAppSizePlugin.scaleW*30,top: appDataModel.dataAppSizePlugin.scaleH*150),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    margin: EdgeInsets.all(appDataModel.dataAppSizePlugin.scaleW*30),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
                            LengthLimitingTextInputFormatter(10),
                          ],
                          controller: _textEditingController1,
                          //cursorColor: Colors.black,
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: "Name",
                            errorText: _errorShow1 == true ? "Minimum of 2 characters." : null,
                          ),
                          onChanged: (text){
                            print("Name: $text");

                            if(_errorShow1 == false){
                              if(_textEditingController1.text == "" || _textEditingController1.text.length < 2){
                                setState(() {
                                  _errorShow1 = true;
                                });
                              }
                            }else{
                              if(_textEditingController1.text != "" && _textEditingController1.text.length >= 2){
                                setState(() {
                                  _errorShow1 = false;
                                });
                              }
                            }
                          },
                        ),

                        TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
                            LengthLimitingTextInputFormatter(20),
                          ],
                          obscureText: true,
                          controller: _textEditingController2,
                          //cursorColor: Colors.black,
                          keyboardType: TextInputType.text,
                          //maxLength: 30,
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: "Password",
                            errorText: _errorShow2 == true ? "Minimum of 8 characters." : null,
                          ),
                          onChanged: (text){
                            print("Password: $text");

                            if(_errorShow2 == false){
                              if(_textEditingController2.text == "" || _textEditingController2.text.length < 8){
                                setState(() {
                                  _errorShow2 = true;
                                });
                              }
                            }else{
                              if(_textEditingController2.text != "" && _textEditingController2.text.length >= 8){
                                setState(() {
                                  _errorShow2 = false;
                                });
                              }
                            }
                          },
                        ),
                        TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
                            LengthLimitingTextInputFormatter(20),
                          ],
                          obscureText: true,
                          controller: _textEditingController3,
                          //cursorColor: Colors.black,
                          keyboardType: TextInputType.text,
                          //maxLength: 30,
                          maxLines: 1,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: "Confirm Password",
                            errorText: _errorShow3 == true ? "Must same as password." : null,
                          ),
                          onChanged: (text){
                            print("Confirm Password: $text");

                            if(_errorShow3 == false){
                              if(_textEditingController3.text != _textEditingController2.text){
                                setState(() {
                                  _errorShow3 = true;
                                });
                              }
                            }else{
                              if(_textEditingController3.text == _textEditingController2.text){
                                setState(() {
                                  _errorShow3 = false;
                                });
                              }
                            }
                          },
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
                      BlocProvider.of<RegisterBloc>(context).add(RegisterEventAccountRegister(
                        userName: _textEditingController1.text,
                        phone: widget.phoneN,
                        passWord: _textEditingController2.text,
                        confirmPassWord: _textEditingController3.text,
                        context: context,
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
}