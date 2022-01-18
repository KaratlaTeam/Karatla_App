import 'dart:io';

class FileM{
  FileM({
    required this.name,
    required this.path,
    required this.fileStat,
});
  String name;
  String path;
  FileStat fileStat;
}