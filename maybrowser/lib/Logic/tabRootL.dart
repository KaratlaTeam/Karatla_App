import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:maybrowser/Model/tabRootM.dart';
import 'package:maybrowser/Model/userM.dart';
import 'package:maybrowser/State/tabRootS.dart';
import 'package:maybrowser/State/userS.dart';
import 'package:maybrowser/View/tabV.dart';
import 'package:maybrowser/main.dart';
import 'package:maybrowser/stringSources.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabRootL extends GetxController with StateMixin<TabRootS>{
  TabRootS? tabS;
  UserS? userS;
  SS? ss;

  @override
  Future<void> onInit() async{
    printInfo(info: 'onInit');
    var his = await loadHistory();
    var coll = await loadCollect();
    this.ss = SS();
    this.tabS = TabRootS(
      tabRootM: TabRootM(tabVList: [], showIndex: 0, tabVMod: []),
      rootIndex: 2,
      url: [ss?.googleN, ss?.googleU, ss?.googleS],
      history: his,
      collect: coll,
    );
    this.userS = UserS(userM: await getUserM());
    super.onInit();
  }

  @override
  void onReady() {
    printInfo(info: 'onReady');
    Get.offNamed(RN.tabRoot);
    super.onReady();
  }

  @override
  void onClose() {
    printInfo(info: 'onClose');

    super.onClose();
  }

  changeDefaultEngine(String engine){
    if(engine == 'Google'){
      tabS?.url = [ss?.googleN, ss?.googleU, ss?.googleS];

    }else if(engine == 'Baidu'){
      tabS?.url = [ss?.baiN, ss?.baiU, ss?.baiS];

    }else if(engine == 'Bing'){
      tabS?.url = [ss?.bingN, ss?.bingU, ss?.bingS];

    }else if(engine == 'YaHoo'){
      tabS?.url = [ss?.yaN, ss?.yaU, ss?.yaS];

    }
    update();
  }

  addTabView(String url){
    var l = tabS?.url[1];
    url == "null" ? url = l.toString() : url = url;
    this.tabS!.tabRootM.showIndex = this.tabS!.tabRootM.tabVList.length;
    TabM tabM = TabM(url: Uri.parse(url),tabIndex: tabS!.tabRootM.tabVMod.length);
    this.tabS!.tabRootM.tabVList.add(TabV(
        key: GlobalKey(),
        tabM: tabM,
    ));
    this.tabS!.tabRootM.tabVMod.add(tabM);

    showWeb();
    update();
  }

  removeTabView(){
    tabS?.tabRootM.tabVMod.removeAt(getShowIndex());
    tabS?.tabRootM.tabVList.removeAt(getShowIndex());
    update();
  }

  updateWebTitle(String title){
    var m = getTabM();
    m.title = title;
    //print(m.title);
    update();
  }

  String getWebTitle(){
    var m = getTabM().title;
    update();
    if(m != null){
    return m;
    }else{
      return '';
    }
  }

  showWeb(){
    this.tabS!.rootIndex = 0 ;
    update();
  }

  showTabs(){
    this.tabS!.rootIndex = 1 ;
    update();
  }

  showHome(){
    this.tabS!.rootIndex = 2 ;
    update();
  }

  changeShowIndex(int index){
    this.tabS!.tabRootM.showIndex = index;
    update();
  }


  ///
  updateWebMode(TabM tabM){
    tabS!.tabRootM.tabVMod[getShowIndex()] = tabM;
  }

  webScreenShot()async{
    getTabM().screenshot  = await getTabM()
        .webViewController!
        .takeScreenshot(screenshotConfiguration: ScreenshotConfiguration(compressFormat: CompressFormat.JPEG,quality: 20))
        .timeout(Duration(milliseconds: 500), onTimeout: () => null,);
    update();
  }

  TabM getTabM(){
    update();
    return tabS!.tabRootM.tabVMod[getShowIndex()];
  }

  TabV getTabV(){
    update();
    return tabS!.tabRootM.tabVList[getShowIndex()];
  }

  int getShowIndex(){
    update();
    return tabS!.tabRootM.showIndex;
  }

  Future<void> createAccount(String account, String password)async{
    ///FirebaseDatabase fireBaseDatabase = FirebaseDatabase.instance;
    ///await fireBaseDatabase.goOnline();
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/$account");
    await ref.set(
      {
        "account": account,
        "password": password,
        "state": 'OFF'
      },
    );
    Get.back();
    Get.showSnackbar(GetSnackBar(title: 'Successful', message: "Create Account Successful!",duration: Duration(seconds: 1),));

    ///await fireBaseDatabase.goOffline();
    update();
  }

  Future<void> loginAccount(String account, String password)async{
    ///FirebaseDatabase fireBaseDatabase = FirebaseDatabase.instance;
    ///await fireBaseDatabase.goOnline();
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/$account");
    DataSnapshot event = await ref.get();
    if(event.value == null){
      Get.showSnackbar(GetSnackBar(title: 'Error', message: "Account does not exit!",duration: Duration(seconds: 1),));
    }else{
      var value = event.value as Map;
      if(value['password'] == password){
        ref.update({
          "account": account,
          "password": password,
          "state": 'ON'
        });

        userS?.userM = UserM(password: password, account: account, state: "ON");

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('user', json.encode(userS?.userM.toJson()));

        Get.back();
        Get.showSnackbar(GetSnackBar(title: 'Successful', message: "Login Account Successful!",duration: Duration(seconds: 1),));
      }else{
        Get.showSnackbar(GetSnackBar(title: 'Error', message: "Password different!",duration: Duration(seconds: 1),));
      }
    }
    ///await fireBaseDatabase.goOffline();
    update();
  }

  Future<UserM> getUserM()async{
    UserM userM;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var jsonBody = prefs.get('user');
    //printInfo(info: 'check user: ${jsonBody.toString()}');
    if(jsonBody == null){
      userM = UserM(password: 'null', account: 'null', state: "OFF");
    }else{
      var decodeJsonBody = await json.decode(jsonBody.toString());
      userM = UserM.fromJson(decodeJsonBody);
    }
    update();
    return userM;
  }

  Future<void> logOut()async{
    ///FirebaseDatabase fireBaseDatabase = FirebaseDatabase.instance;
    ///await fireBaseDatabase.goOnline();
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/${userS?.userM.account}");
    ref.update({
      "account": userS?.userM.account,
      "password": userS?.userM.password,
      "state": 'OFF'
    });

    userS?.userM.state = 'OFF';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', json.encode(userS?.userM.toJson()));
    ///await fireBaseDatabase.goOffline();
    Get.showSnackbar(GetSnackBar(title: 'Message', message: "Account LogOut!",duration: Duration(seconds: 1),));
    update();
  }

  bool checkLogin(){
    if(userS?.userM.state == "ON"){
      return true;
    }else{
      Get.showSnackbar(GetSnackBar(title: 'Message', message: "Please login first",duration: Duration(seconds: 1),));
      return false;
    }
  }

  Future<void> saveHistory()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic>? his = tabS?.history;
    Map<String, dynamic> value = Map<String, dynamic>();
    value['history'] = his;
    prefs.setString('history', json.encode(value));
    update();
  }

  Future<List> loadHistory()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List back;
    var value = prefs.getString('history');
    if(value == null){
      back = [];
    }else{
      Map<String, dynamic> decode = json.decode(value);
      back = decode['history'];
    }
    update();
    return back;
  }

  Future<void> addHistory(List value)async{
    tabS?.history.add(value);
    await saveHistory();
    update();
  }

  Future<void> removeHistory(int index)async{
    tabS?.history.removeAt(index);
    await saveHistory();
    Get.showSnackbar(GetSnackBar(title: 'Message', message: "Remove successful",duration: Duration(seconds: 1),));
    update();
  }




  Future<void> saveCollect()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic>? coll = tabS?.collect;
    Map<String, dynamic> value = Map<String, dynamic>();
    value['collect'] = coll;
    prefs.setString('collect', json.encode(value));
    update();
  }

  Future<List> loadCollect()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List back;
    var value = prefs.getString('collect');
    if(value == null){
      back = [];
    }else{
      Map<String, dynamic> decode = json.decode(value);
      back = decode['collect'];
    }
    update();
    return back;
  }

  Future<void> addCollect(List value)async{
    tabS?.collect.add(value);
    await saveCollect();
    Get.showSnackbar(GetSnackBar(title: 'Message', message: "Add successful",duration: Duration(seconds: 1),));
    update();
  }

  Future<void> removeCollect(int index)async{
    tabS?.collect.removeAt(index);
    await saveCollect();
    Get.showSnackbar(GetSnackBar(title: 'Message', message: "Remove successful",duration: Duration(seconds: 1),));
    update();
  }

}