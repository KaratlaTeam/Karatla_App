import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:PPM/bloc/appDataBloc/appDataBloc.dart';
import 'package:PPM/bloc/appDataBloc/appDataState.dart';
import 'package:PPM/bloc/loginBloc/bloc.dart';
import 'package:PPM/bloc/accountDataBloc/bloc.dart';
import 'package:PPM/bloc/systemLanguage/systemLanguage_bloc.dart';
import 'package:PPM/bloc/systemLanguage/systemLanguage_event.dart';
import 'package:PPM/dataModel/appDataModel.dart';
import 'package:PPM/dataModel/accountDataModel.dart';
import 'package:PPM/dataModel/systemLanguageModel.dart';
import 'package:PPM/statePage.dart';
import 'package:PPM/typedef.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppDataBloc, AppDataState>(
      builder: (context, appDataState) {
        AppDataModel appDataModel = _getAppDataModel(appDataState);
        AccountDataModel accountDataModel =
            BlocProvider.of<AccountDataBloc>(context).accountDataModel;
        SystemLanguageBloc systemLanguageBloc = BlocProvider.of<SystemLanguageBloc>(context);

        return Scaffold(
          appBar: AppBar(),
          body: ListView(
            children: <Widget>[
              //ProfileListCard(
              //  indent: appDataModel.dataAppSizePlugin.scaleW*15,
              //  endIndent: appDataModel.dataAppSizePlugin.scaleW*15,
              //  text1: Text("Photo"),
              //  onTap: (){},
              //),
              ProfileListCard(
                indent: appDataModel.dataAppSizePlugin.scaleW * 15,
                endIndent: appDataModel.dataAppSizePlugin.scaleW * 15,
                text1: Text(systemLanguageBloc.systemLanguageModel.settingPageName),
                text2: Text(accountDataModel.myName),
                iconData: null,
                onTap: null,
                //    (){
                //  Navigator.push(context, MaterialPageRoute(builder: (context) => TextFieldPage(
                //    hintText: "New Name",
                //    profileDataEnum: AccountDataEnum.NAME,
                //  )));
                //},
              ),
              ProfileListCard(
                indent: appDataModel.dataAppSizePlugin.scaleW * 15,
                endIndent: appDataModel.dataAppSizePlugin.scaleW * 15,
                height: appDataModel.dataAppSizePlugin.scaleH * 20,
                text1: Text(systemLanguageBloc.systemLanguageModel.settingPagePhone),
                text2: Text(accountDataModel.myPhone),
                iconData: null,
                onTap: null,
                //     (){
                //   Navigator.push(context, MaterialPageRoute(builder: (context) => TextFieldPage(
                //     hintText: "New Phone",
                //     profileDataEnum: AccountDataEnum.PONE,
                //   )));
                // },
              ),
              //ProfileListCard(
              //  indent: appDataModel.dataAppSizePlugin.scaleW*15,
              //  endIndent: appDataModel.dataAppSizePlugin.scaleW*15,
              //  text1: Text("Email"),
              //  text2: Text(accountDataModel.myEmail),
              //  height: appDataModel.dataAppSizePlugin.scaleH*20,
              //  color: Colors.transparent,
              //  onTap: (){
              //    Navigator.push(context, MaterialPageRoute(builder: (context) => TextFieldPage(
              //      hintText: "New email",
              //      profileDataEnum: AccountDataEnum.EMAIL,
              //    )));
              //  },
              //),

              ProfileListCard(
                indent: appDataModel.dataAppSizePlugin.scaleW * 15,
                endIndent: appDataModel.dataAppSizePlugin.scaleW * 15,
                height: appDataModel.dataAppSizePlugin.scaleH * 20,
                text1: Text(systemLanguageBloc.systemLanguageModel.settingPageLanguage),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (build) {
                        return SimpleDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            //title: Text("Please Select Your Language"),
                            children: <Widget>[
                              FlatButton(
                                onPressed: systemLanguageBloc.systemLanguageModel.systemLanguageCode != SystemLanguageCode.EN ?(){
                                systemLanguageBloc.add(SystemLanguageEventChange(systemLanguageCode:SystemLanguageCode.EN));
                                Navigator.pop(context);
                              } : null, 
                              child: Text("Evglish"),
                              ),
                              FlatButton(
                                onPressed: systemLanguageBloc.systemLanguageModel.systemLanguageCode != SystemLanguageCode.CN ?(){
                                systemLanguageBloc.add(SystemLanguageEventChange(systemLanguageCode:SystemLanguageCode.CN));
                                Navigator.pop(context);
                              } : null, 
                              child: Text("简体中文"),
                              ),
                              FlatButton(
                                onPressed: systemLanguageBloc.systemLanguageModel.systemLanguageCode != SystemLanguageCode.MALAY ?(){
                                systemLanguageBloc.add(SystemLanguageEventChange(systemLanguageCode:SystemLanguageCode.MALAY));
                                Navigator.pop(context);
                              } : null, 
                              child: Text("Melayu"),
                              ),
                            ],
                          );
                      });
                },
              ),

              ProfileListCard(
                indent: appDataModel.dataAppSizePlugin.scaleW * 15,
                endIndent: appDataModel.dataAppSizePlugin.scaleW * 15,
                text1: Text(systemLanguageBloc.systemLanguageModel.settingPageAbout),
                onTap: () {},
              ),

              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: appDataModel.dataAppSizePlugin.scaleW * 150,
                    vertical: appDataModel.dataAppSizePlugin.scaleH * 20),
                child: RaisedButton(
                  highlightElevation: 2,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.white,
                  onPressed: () {
                    BlocProvider.of<LoginBloc>(context)
                      ..add(LoginEventSignOut());
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    systemLanguageBloc.systemLanguageModel.settingPageLogOut,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  AppDataModel _getAppDataModel(AppDataState appDataState) {
    if (appDataState is AppDataStateGotData) {
      return appDataState.appDataModel;
    } else {
      return null;
    }
  }
}

class ProfileListCard extends StatelessWidget {
  const ProfileListCard({
    Key key,
    this.text1: const Text("-"),
    this.text2,
    this.indent,

    ///15
    this.endIndent,

    ///15
    this.onTap,
    this.height: 1.0,
    this.color,
    this.iconData: Icons.arrow_right,
  }) : super(key: key);

  final Text text1;
  final Text text2;
  final double indent;
  final double endIndent;
  final GestureTapCallback onTap;
  final double height;
  final Color color;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: ListTile(
              title: text1,
              subtitle: text2,
              trailing: Icon(iconData),
            ),
          ),
          Divider(
            height: height,
            indent: indent,
            endIndent: endIndent,
            color: color,
          ),
        ],
      ),
    );
  }
}

class TextFieldPage extends StatefulWidget {
  TextFieldPage({
    Key key,
    this.hintText,
    this.profileDataEnum,
  }) : super(key: key);

  final String hintText;
  final AccountDataEnum profileDataEnum;

  @override
  _TextFieldPageState createState() => _TextFieldPageState();
}

class _TextFieldPageState extends State<TextFieldPage> {
  TextEditingController textEditingController1;
  AccountDataModel profileDataModel;

  @override
  void initState() {
    textEditingController1 = TextEditingController(text: "");
    profileDataModel = AccountDataModel();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController1.dispose();
    profileDataModel.initialData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppDataBloc, AppDataState>(
      builder: (context, appDataState) {
        AppDataModel appDataModel = _getAppDataModel(appDataState);

        return Scaffold(
          appBar: AppBar(),
          body: ListView(
            padding: EdgeInsets.symmetric(
                horizontal: appDataModel.dataAppSizePlugin.scaleW * 20),
            children: <Widget>[
              _textFiledModel(),
              Container(
                margin: EdgeInsets.symmetric(
                    horizontal: appDataModel.dataAppSizePlugin.scaleW * 140,
                    vertical: appDataModel.dataAppSizePlugin.scaleH * 20),
                child: RaisedButton(
                  highlightElevation: 2,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.white,
                  onPressed: () {
                    print(textEditingController1.text);
                    _getText();
                    //BlocProvider.of<AccountDataBloc>(context).add(AccountDataEventChangeData(accountDataModel: profileDataModel, accountDataModelChangeEnum: widget.profileDataEnum));
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Save",
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  AppDataModel _getAppDataModel(AppDataState appDataState) {
    if (appDataState is AppDataStateGotData) {
      return appDataState.appDataModel;
    } else {
      return null;
    }
  }

  _getText() {
    if (widget.profileDataEnum == AccountDataEnum.EMAIL) {
      profileDataModel.myEmail = textEditingController1.text;
    } else if (widget.profileDataEnum == AccountDataEnum.NAME) {
      profileDataModel.myName = textEditingController1.text;
    } else if (widget.profileDataEnum == AccountDataEnum.PONE) {
      profileDataModel.myPhone = textEditingController1.text;
    }
  }

  _textFiledModel() {
    if (widget.profileDataEnum == AccountDataEnum.EMAIL) {
      return TextField(
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9@.]"))
        ],
        controller: textEditingController1,
        cursorColor: Colors.black,
        keyboardType: TextInputType.emailAddress,
        maxLength: 30,
        maxLines: 1,
        decoration: InputDecoration(
          border: UnderlineInputBorder(),
          hintText: widget.hintText,
        ),
      );
    } else if (widget.profileDataEnum == AccountDataEnum.NAME) {
      return TextField(
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]"))
        ],
        controller: textEditingController1,
        cursorColor: Colors.black,
        keyboardType: TextInputType.text,
        maxLength: 15,
        maxLines: 1,
        decoration: InputDecoration(
            border: UnderlineInputBorder(), hintText: widget.hintText),
      );
    } else if (widget.profileDataEnum == AccountDataEnum.PONE) {
      return TextField(
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        controller: textEditingController1,
        cursorColor: Colors.black,
        keyboardType: TextInputType.phone,
        maxLength: 15,
        maxLines: 1,
        decoration: InputDecoration(
            border: UnderlineInputBorder(), hintText: widget.hintText),
      );
    } else {
      return StatePageError();
    }
  }
}
