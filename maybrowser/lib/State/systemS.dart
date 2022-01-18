import 'dart:io';

import 'package:maybrowser/Model/fileM.dart';
import 'package:maybrowser/Model/packageInfoM.dart';

class SystemS{
  SystemS({
    required this.tempPath,
    required this.appDocPath,
    required this.filePath,
    required this.picturePath,
    required this.videoPath,
    required this.musicPath,

    required this.tempDir,
    required this.appDocDir ,
    required this.fileDir ,
    required this.pictureDir ,
    required this.videoDir,
    required this.musicDir,

    required this.packageInfo,

    required this.fileMList,
    required this.pictureMList,
    required this.videoMList,
    required this.musicMList,

});
  String tempPath ;
  String? appDocPath ;

  String filePath ;
  String picturePath ;
  String videoPath ;
  String musicPath ;

  Directory tempDir ;
  Directory? appDocDir ;

  Directory fileDir ;
  Directory pictureDir ;
  Directory videoDir ;
  Directory musicDir ;

  MyPackageInfo packageInfo;
  List<FileM> fileMList;
  List<FileM> pictureMList;
  List<FileM> videoMList;
  List<FileM> musicMList;
}