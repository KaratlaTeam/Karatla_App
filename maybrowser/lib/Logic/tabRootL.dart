import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:maybrowser/Model/fileM.dart';
import 'package:maybrowser/Model/packageInfoM.dart';
import 'package:maybrowser/State/systemS.dart';
import 'package:package_info_plus/package_info_plus.dart';
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
    await initializeSystem();
    this.ss = SS();
    this.tabS = TabRootS(
      tabRootM: TabRootM(tabVList: [], showIndex: 0),
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

  List<FileM> getFilesDataList(Directory dir){
    List<FileM> data = [];
    dir.listSync().forEach((e) {
      var name = getDirname(e.path);
      var value = e.statSync();
      data.add(FileM(name: name, path: e.path, fileStat: value,));
    });
    return data;
  }

  getAllFilesDataList() {
    print("update file list");
    systemS!.fileMList = getFilesDataList(systemS!.fileDir);

    systemS!.pictureMList = getFilesDataList(systemS!.pictureDir);

    systemS!.videoMList = getFilesDataList(systemS!.videoDir);

    systemS!.musicMList = getFilesDataList(systemS!.musicDir);

    update();
  }

  sortFiles(List<FileM> data){
    data.sort((a,b){
      DateTime dateTime = a.fileStat.modified;
      DateTime dateTime2 = b.fileStat.modified;
      return dateTime2.compareTo(dateTime);
    });

  }

  Future<void> initializeSystem()async{

    /// ios only supports save files in NSDocumentDirectory--getApplicationDocumentsDirectory

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    print('tempPath'+tempPath);

    Directory? appDocDir = GetPlatform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
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

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

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
      packageInfo: MyPackageInfo(
        appName: appName,
        packageName: packageName,
        version: version,
        buildNumber: buildNumber,
      ),
      fileMList: getFilesDataList(fileDir),
      pictureMList: getFilesDataList(pictureDir),
      videoMList: getFilesDataList(videoDir),
      musicMList: getFilesDataList(musicDir),
    );

    update();
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

    }else if(engine == 'Wikipedia'){
      tabS?.url = [ss?.wikiN, ss?.wikiU, ss?.wikiS];

    }else if(engine == 'CountryReport'){
      tabS?.url = [ss?.countryN, ss?.countryU, ss?.countryS];

    }else if(engine == 'Eol'){
      tabS?.url = [ss?.eolN, ss?.eolU, ss?.eolS];

    }else if(engine == 'Dictionary'){
      tabS?.url = [ss?.dictionaryN, ss?.dictionaryU, ss?.dictionaryS];

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
    int? id = newTabId();
    int? showIndex = this.tabS?.tabRootM.tabVList.length;
    this.tabS!.tabRootM.showIndex = showIndex!;
    TabM tabM = TabM(url: Uri.parse(url),windowId: id, title: '');
    this.tabS!.tabRootM.tabVList.add(TabV(
      key: GlobalKey(),
      tabM: tabM,
    ));
    showWeb();
    update();
  }

  int newTabId(){
    if(tabS!.tabRootM.tabVList.length == 0){
      return 0;
    }else{
      return tabS!.tabRootM.tabVList.last.tabM.windowId+1;
    }
  }

  updateTabW(){
    update();
  }

  removeTabView(){
    int showIndex = getShowIndex();
    int? l = tabS?.tabRootM.tabVList.length;
    tabS?.tabRootM.tabVList.removeAt(showIndex);
    if(showIndex == l! - 1 && l != 1){
      tabS?.tabRootM.showIndex = showIndex - 1;
    }
    update();
  }

  int getShowIndex(){
    return tabS!.tabRootM.showIndex;
  }

  updateShowIndex(int index){
    tabS?.tabRootM.showIndex = index;
    update();
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


  TabV getTabV(){
    return tabS!.tabRootM.tabVList[getShowIndex()];
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
    var api = 'http://api.weatherstack.com/current?access_key=03ef8e911f6f03ffbf4effc1741bbaac&query=Kuala%20Lumpur';
    try{
      dio = await Dio().get(api);
      print('temperature: '+dio.data['current']['temperature'].toString());
      return dio.data['current']['temperature'].toString();
    }catch(e){
      print(e);
      return '0';
    }

  }

}