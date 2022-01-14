import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:maybrowser/State/systemS.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
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
  SystemS? systemS;

  @override
  Future<void> onInit() async{
    printInfo(info: 'onInit');
    var his = await loadHistory();
    var coll = await loadCollect();
    await initializePath();
    this.ss = SS();
    this.tabS = TabRootS(
      tabRootM: TabRootM(tabVList: [], showIndex: 0, tabVMod: []),
      rootIndex: 2,
      url: [ss?.googleN, ss?.googleU, ss?.googleS],
      history: his,
      collect: coll,
      incognito: false,
      temperature: await getTemperature(),
    );
    this.userS = UserS(userM: await getUserM());
    Get.offNamed(RN.tabRoot);
    super.onInit();
  }

  @override
  void onReady() {
    printInfo(info: 'onReady');
    super.onReady();
  }

  @override
  void onClose() {
    printInfo(info: 'onClose');

    super.onClose();
  }

  Future<void> initializePath()async{

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    print('tempPath'+tempPath);
    Directory? appDocDir = await getExternalStorageDirectory();
    String? appDocPath = appDocDir?.path;
    print('appDocPath'+appDocPath.toString());

    Directory fileDir = await Directory(appDocPath!+'/File').create();
    String filePath = fileDir.path;
    print(filePath);

    Directory pictureDir = await Directory(appDocPath+'/Picture').create();
    String picturePath = pictureDir.path;
    print(picturePath);

    Directory videoDir = await Directory(appDocPath+'/Video').create();
    String videoPath = videoDir.path;
    print(videoPath);

    Directory musicDir = await Directory(appDocPath+'/Music').create();
    String musicPath = musicDir.path;
    print(musicPath);

    this.systemS = SystemS(
      tempPath: tempPath,
      appDocPath: appDocPath,
      filePath: filePath,
      picturePath: picturePath,
      videoPath: videoPath,
      musicPath: musicPath,

      tempDir: tempDir,
      appDocDir: appDocDir,
      fileDir: fileDir,
      pictureDir: pictureDir,
      videoDir: videoDir,
      musicDir: musicDir,
    );
    print('');
    appDocDir?.listSync().forEach((element) async{
      var value = getDirname(element.path);
      print(value);
    });
  }

  String getDirname(String path){
    int index = path.lastIndexOf('/');
    return path.substring(index+1);
  }

  String? getPath(String value){
    if(value == 'File'){
      return systemS?.filePath;
    }else if(value == 'Picture'){
      return systemS?.picturePath;
    }else if(value == 'Video'){
      return systemS?.videoPath;
    }else if(value == 'Music'){
      return systemS?.musicPath;
    }else{
      return '';
    }
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

  getBackAndOpenTab(String url)async{
    Get.back();
    Get.back();
    Future.delayed(Duration(seconds: 1),(){
      addTabView(url);
    });

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

    update();
  }

  Future<void> loginAccount(String account, String password)async{
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
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/${userS?.userM.account}");
    ref.update({
      "account": userS?.userM.account,
      "password": userS?.userM.password,
      "state": 'OFF'
    });

    userS?.userM.state = 'OFF';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', json.encode(userS?.userM.toJson()));
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
    if(this.tabS!.incognito == false){
      tabS?.history.add(value);
      await saveHistory();
      update();
    }
  }

  Future<void> removeHistory(int index)async{
    int? a = tabS?.history.length;
    tabS?.history.removeAt(a!-1-index);
    await saveHistory();
    Get.showSnackbar(GetSnackBar(title: 'Message', message: "Remove successful",duration: Duration(seconds: 1),));
    update();
  }

  void changeIncognito(){
    if(this.tabS!.incognito == true){
      this.tabS!.incognito = false;
      print('incognito false');
    }else{
      this.tabS!.incognito = true;
      print('incognito true');
    }

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
    int? a = tabS?.history.length;
    tabS?.collect.removeAt(a!-1-index);
    await saveCollect();
    Get.showSnackbar(GetSnackBar(title: 'Message', message: "Remove successful",duration: Duration(seconds: 1),));
    update();
  }


  Future<String> getTemperature()async{
    var dio;
    var api = 'http://api.weatherstack.com/current?access_key=3f95cff0594a00f62a0bff6eda231c18&query=Kuala%20Lumpur';
    try{
      dio = await Dio().get(api);
      print('temperature: '+dio.data['current']['temperature'].toString());
      return dio.data['current']['temperature'].toString();
    }catch(e){
      print(e);
    }
    print('temperature: '+dio.data['current']['temperature'].toString());
    return '0';
  }

}