import 'dart:io';

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
}