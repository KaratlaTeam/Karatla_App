
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maybrowser/Logic/tabRootL.dart';
import 'package:maybrowser/Model/userM.dart';
import 'package:maybrowser/State/userS.dart';

class SettingV extends StatefulWidget {

  @override
  _SettingVState createState() => _SettingVState();
}
class _SettingVState extends State<SettingV>{

  //int argument = 2;
  String dropdownValue = Get.find<TabRootL>().tabS?.url[0];

@override
void initState() {
    //Get.arguments == 0 ? argument = 0 : argument = 2;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GetBuilder<TabRootL>(
      builder: (_){
        return Scaffold(
          appBar: AppBar(
            title: Text("Setting"),
            centerTitle: true,
          ),
          body: ListView(
            padding: EdgeInsets.only(top: 15),
            children: stateWidget(_),
          ),
        );
        },
    );
  }

  List<Widget> stateWidget(TabRootL tabRootL){
  List<Widget> widgets = [
    ListTile(
      title: Text("Default Search Engine"),
      subtitle: DropdownButton<String>(
        value: dropdownValue,
        //icon: const Icon(Icons.arrow_downward),
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(
            color: Colors.black
        ),
        underline: Container(
          height: 0,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String? newValue) {
          setState(() {
            dropdownValue = newValue!;
            tabRootL.changeDefaultEngine(newValue);
          });
        },
        items: <String>[tabRootL.ss?.googleN, tabRootL.ss?.baiN, tabRootL.ss?.bingN, tabRootL.ss?.yaN]
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
      onTap: (){},
    ),
    Divider(),
    ListTile(
      title: Text("History"),
      onTap: (){
        if(Get.find<TabRootL>().checkLogin()==true){
          Get.to(HistoryV());
        }
        },
    ),
    Divider(),
    ListTile(
      title: Text("Collect"),
      onTap: (){
        if(Get.find<TabRootL>().checkLogin()==true){
          Get.to(CollectV());
        }
        },
    ),
    Divider(),
    ListTile(title: Text("About"),subtitle: Text("Version 1.2.3")  , onTap: (){Get.to(About());}),
    Divider(),
  ];

  UserM? userM = Get.find<TabRootL>().userS?.userM;
  if(userM?.state == 'OFF'){
    widgets.add(TextButton(
      onPressed: (){
        Get.to(LoginV());
      },
      child: Text('Login'),
    ));
  }else{
    widgets.add(TextButton(
      onPressed: null,
      child: Text('${userM?.account}'),
    ));
    widgets.add(TextButton(
      onPressed: (){
        Get.find<TabRootL>().logOut();
      },
      child: Text('LogOut'),
    ),);
  }
  return widgets;

  }
}

class LoginV extends StatefulWidget{
  @override
  _LoginVState createState() => _LoginVState();
}
class _LoginVState extends State<LoginV>{

  String dropdownValue = 'English';
  String password = '';
  String account =  '';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Login"),centerTitle: true,),

      body: Center(
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 100, left: 50,right: 250),
              child: DropdownButton<String>(
                value: dropdownValue,
                //icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(
                    color: Colors.black
                ),
                underline: Container(
                  height: 0,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownValue = newValue!;
                  });
                },
                items: <String>['English', 'Melayu', 'Chinese']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20,left: 50,right: 50),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Account"
                ),
                onChanged: (text){
                  setState(() {
                    account = text;
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20,left: 50,right: 50),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                    hintText: "Password"
                ),
                onChanged: (text){
                  setState(() {
                    password = text;
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20,left: 100,right: 100),
              child: ElevatedButton(
                child: Text("Login"),
                onPressed: ()async{
                  await Get.find<TabRootL>().loginAccount(account, password);
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20,left: 100,right: 100),
              child: ElevatedButton(
                child: Text("Register"),
                onPressed: (){
                  Get.to(RegisterV());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterV extends StatefulWidget {
  @override
  _RegisterVState createState() => _RegisterVState();
}
class _RegisterVState extends State<RegisterV>{

  String account = '';
  String password = '';
  String repeatPassword = '';
  bool showError = true;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Create Account"),centerTitle: true,),

      body: Center(
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 150,left: 50,right: 50),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Account"
                ),
                onChanged: (text){
                  setState(() {
                    account = text;
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20,left: 50,right: 50),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Password"
                ),
                onChanged: (text){
                  password = text;
                  if(repeatPassword != password){
                    showError = true;
                  }else{
                    showError = false;
                  }
                  setState(() {});
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20,left: 50,right: 50),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Repeat Password",
                    errorText: repeatPassword == '' ? 'Repeat Password empty' : (showError == true ? 'Password different!' : null),
                ),
                onChanged: (text){
                  repeatPassword = text;
                  if(repeatPassword != password){
                    showError = true;
                  }else{
                    showError = false;
                  }
                  setState(() {});
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20,left: 100,right: 100),
              child: ElevatedButton(
                child: Text("Submit"),
                onPressed: () async {
                  if(showError == true || password == ''){
                    Get.showSnackbar(GetSnackBar(title: 'Error', message: "Password different!",duration: Duration(seconds: 1),));
                  }else{
                    await Get.find<TabRootL>().createAccount(account, password);
                  }

                },
              ),
            ),
            //Container(
            //  margin: EdgeInsets.only(top: 20,left: 100,right: 100),
            //  child: ElevatedButton(
            //    child: Text("Test data"),
            //    onPressed: () async {
            //      await Get.find<TabRootL>().loginAccount(account, password);
            //    },
            //  ),
            //),
          ],
        ),
      ),
    );
  }
}

class HistoryV extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("History"),centerTitle: true,),

      body: Center(
        child: GetBuilder<TabRootL>(
          builder: (_){
            return ListView(
                children: listWidget(_),
            );
          },
        ),
      ),
    );
  }
  listWidget(TabRootL _){
    var his = _.tabS?.history;
    if(his == null){
      return [Container()];
    }else{
      return his.reversed.toList().asMap().map((key, value) {
        var widget = ListTile(
          title: Text(value[0],maxLines: 1,),
          subtitle: Text(value[1],maxLines: 1,),
          onTap: (){
            _.getBackAndOpenTab(value[1]);
          },
          onLongPress: (){
            _.removeHistory(key);
          },
        );
        return MapEntry(key, widget);
      }).values.toList();
    }
  }
}

class CollectV extends StatelessWidget{
  CollectV({
    Key? key,
    this.showBottom: false,
  }):super(key: key);

  final bool showBottom;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: showBottom == true ? null : AppBar(title: Text("Collect"),centerTitle: true,),

      body: Center(
        child: GetBuilder<TabRootL>(
          builder: (_){

            return ListView(
              children: listWidget(_),
            );
          },
        ),
      ),
    );
  }

  listWidget(TabRootL _){
    var his = _.tabS?.collect;
    if(his == null){
      return [Container()];
    }else{
      return his.reversed.toList().asMap().map((key, value) {
        var widget = ListTile(
          title: Text(value[0],maxLines: 1,),
          subtitle: Text(value[1],maxLines: 1,),
          onTap: (){
            _.getBackAndOpenTab(value[1]);
          },
          onLongPress: (){
            _.removeCollect(key);
          },
        );
        return MapEntry(key, widget);
      }).values.toList();
    }
  }
}

class About extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("About"),centerTitle: true,),

      body: Center(
        child: Card(
          elevation: 7,
          child: Container(
            margin: EdgeInsets.all(10),
            height: 200,width: 300,
            child: Text(
                "May browser can help users to add multiple different search engines on a page, search results in all search engine tags, switch directly from one tag to another, and view search results for all search engines at the same time. According to different countries, visit people's habits, set the search engine to customize the browser for users.",
              style: TextStyle(fontSize: 17),
            ),
          ),
        )
      ),
    );
  }
}
