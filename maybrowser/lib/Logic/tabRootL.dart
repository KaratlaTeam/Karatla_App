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
import 'package:shared_preferences/shared_preferences.dart';

class TabRootL extends GetxController with StateMixin<TabRootS>{
  TabRootS? tabS;
  UserS? userS;

  @override
  Future<void> onInit() async{
    printInfo(info: 'onInit');
    this.tabS = TabRootS(tabRootM: TabRootM(tabVList: [], showIndex: 0, tabVMod: []), rootIndex: 2, url: "https://www.google.com");
    this.userS = UserS(userM: await getUserM());
    super.onInit();
  }

  @override
  void onReady() {
    printInfo(info: 'onReady');
    //Get.offNamed(RN.home);
    super.onReady();
  }

  @override
  void onClose() {
    printInfo(info: 'onClose');

    super.onClose();
  }

  addTabView(String url){
    url == "null" ? url = "https://www.google.com" : url = url;
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
    Get.showSnackbar(GetSnackBar(title: 'Tip', message: "Account LogOut!",duration: Duration(seconds: 1),));
    update();
  }

}