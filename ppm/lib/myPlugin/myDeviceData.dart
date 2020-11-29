import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDeviceData{
  bool firstOpen;
  PackageInfo packageInfo;
  String deviceId;

  String tempPath;
  String appDocPath;

  //String supPath;
  String libPath;
  String externPath;
  String academyPath;
  
  String questionPath;
  String questionPathPart1;
  String questionPathPart2;
  String questionPathPart3;

  initialData()async{
    this.firstOpen = await _getFirstOpen();

    this.packageInfo = await PackageInfo.fromPlatform();

    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    if(Platform.isAndroid){
      AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
      deviceId = androidDeviceInfo.androidId;
      print("device: ${androidDeviceInfo.version.sdkInt}");

    }else{
      IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
      deviceId = iosDeviceInfo.identifierForVendor;
      print("device: ${iosDeviceInfo.name} ${iosDeviceInfo.systemName} ${iosDeviceInfo.systemVersion}");

    }

    if(Platform.isAndroid){
      Directory externDir = await getExternalStorageDirectory();
      this.externPath = externDir.path;
      this.libPath = null;
      print("externPath: ${this.externPath}");
    }else if(Platform.isIOS){
      Directory libDir = await getLibraryDirectory();
      this.libPath = libDir.path;
      this.externPath = null;
      print("libPath: ${this.libPath}");
    }else{
      this.externPath = null;
      this.libPath = null;
    }

    Directory tempDir = await getTemporaryDirectory();
    this.tempPath = tempDir.path;
    print("tempPath: ${this.tempPath}");

    Directory appDocDir = await getApplicationDocumentsDirectory();
    this.appDocPath = appDocDir.path;
    print("appDocPath: ${this.appDocPath}");

    this.academyPath = await _getAcademyPath();
    print("academyPath: ${this.academyPath}");

    await _getQuestionPath();

    //Directory supDir = await getApplicationSupportDirectory();
    //this.supPath = supDir.path;
    //await supDir.create();
    //print("supPath: ${this.tempPath}");

  }

  Future<bool> _getFirstOpen()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var f = sharedPreferences.getBool("firstOpen");
    if(f == null){
      print("First open");
      sharedPreferences.setBool("firstOpen", false);
      return true;
    }else{
      print("Not first open");
      return false;
    }
  }

  Future<String> _getAcademyPath()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String academyPath = sharedPreferences.getString("academyPath");
    if(academyPath == null){
      academyPath = await _createAcademyPath();
    }
    return academyPath;
  }

  _getQuestionPath()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    this.questionPath = sharedPreferences.getString("questionPath");
    this.questionPathPart1 = sharedPreferences.getString("questionPathPart1");
    this.questionPathPart2 = sharedPreferences.getString("questionPathPart2");
    this.questionPathPart3 = sharedPreferences.getString("questionPathPart3");

    if(this.questionPath == null || this.questionPathPart1 == null || this.questionPathPart2 == null || this.questionPathPart3 == null){
      await _createQuestionPath();
    }else{
    print("questionPath: ${this.questionPath}");
    print("questionPathPart1: ${this.questionPathPart1}");
    print("questionPathPart2: ${this.questionPathPart2}");
    print("questionPathPart3: ${this.questionPathPart3}");
    }
  }

  Future<String> _createAcademyPath()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Directory appDocDir = await getApplicationDocumentsDirectory();
    var academyD = Directory("${appDocDir.path}/academy");
    if(!academyD.existsSync()){
      academyD.createSync();
    }
    await sharedPreferences.setString("academyPath", academyD.path);
    print("create academyPath: ${academyD.path}");
    return academyD.path;
  }
  
  _createQuestionPath()async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Directory appDocDir = await getApplicationDocumentsDirectory();

    var questionD = Directory("${appDocDir.path}/question/");
    var questionDPart1 = Directory("${appDocDir.path}/question/Part1/");
    var questionDPart2 = Directory("${appDocDir.path}/question/Part2/");
    var questionDPart3 = Directory("${appDocDir.path}/question/Part3/");

    if(!questionD.existsSync()){
      questionD.createSync();
      print("create questionPath: ${questionD.path}");
    }
    if(!questionDPart1.existsSync()){
      questionDPart1.createSync();
      print("create questionPathPart1: ${questionDPart1.path}");
    }
    if(!questionDPart2.existsSync()){
      questionDPart2.createSync();
      print("create questionPathPart2: ${questionDPart2.path}");
    }
    if(!questionDPart3.existsSync()){
      questionDPart3.createSync();
      print("create questionPathPart3: ${questionDPart3.path}");
    }

    await sharedPreferences.setString("questionPath", questionD.path);
    await sharedPreferences.setString("questionPathPart1", questionDPart1.path);
    await sharedPreferences.setString("questionPathPart2", questionDPart2.path);
    await sharedPreferences.setString("questionPathPart3", questionDPart3.path);

    this.questionPath = questionD.path;
    this.questionPathPart1 = questionDPart1.path;
    this.questionPathPart2 = questionDPart2.path;
    this.questionPathPart3 = questionDPart3.path;
  }

}