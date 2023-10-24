import 'dart:io';

class MDir {
  MDir({
    required this.tempPath,
    required this.appDocPath,
    required this.filePath,
    required this.picturePath,

    required this.tempDir,
    required this.appDocDir ,
    required this.fileDir ,
    required this.pictureDir ,
  });
  String tempPath ;
  String? appDocPath ;
  String filePath ;
  String picturePath ;

  Directory tempDir ;
  Directory? appDocDir ;
  Directory fileDir ;
  Directory pictureDir ;

  factory MDir.newOne(){
    return MDir(
      tempPath: 'tempPath',
      appDocPath: 'appDocPath',
      filePath: 'filePath',
      picturePath: 'picturePath',
      tempDir: Directory(''),
      appDocDir: Directory(''),
      fileDir: Directory(''),
      pictureDir: Directory(''),
    );
  }

  String getDirAndFileName(String path){
    int index = path.lastIndexOf('/');
    return path.substring(index+1);
  }

  String getFileTypeName(String path){
    int index = path.lastIndexOf('.');
    return path.substring(index);
  }

}