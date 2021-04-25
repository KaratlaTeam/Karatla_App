import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:share/share.dart';

class BackupListV extends StatefulWidget{
  @override
  _BackupListVState createState() => _BackupListVState();
}
class _BackupListVState extends State<BackupListV>{

  List<FileSystemEntity> files = Get.find<HouseL>().getRestoreDataList().reversed.toList();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text("数据恢复"),
          ),
          body: Container(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 15),
              itemCount: files.length,
              itemBuilder: (BuildContext context, int index){
                return Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    onTap: (){
                      Get.defaultDialog(
                        middleText: '确认要从 "${_getTitle(files[index].path)}中恢复数据" ？现有数据将丢失。',
                        onConfirm: (){
                          Get.back();
                          Get.find<HouseL>().restoreData(files[index]);
                        },
                        onCancel: (){
                        },
                      );
                    },
                    title: Text(_getTitle(files[index].path)),
                    subtitle: Text(File(files[index].path).lastModifiedSync().toString()),
                    leading: IconButton(
                      onPressed: (){
                        Share.shareFiles([files[index].path]);
                      },
                      icon: Icon(Icons.share),color: Colors.blue,),
                    trailing: IconButton(
                      onPressed: (){
                        Get.defaultDialog(
                          middleText: '确认要删除 "${_getTitle(files[index].path)}" 这条备份？',
                          onConfirm: (){
                            Get.back();
                            File file = File(files[index].path);
                            file.deleteSync();
                            this.files = Get.find<HouseL>().getRestoreDataList().reversed.toList();
                            Get.snackbar('提示', '删除成功',snackPosition: SnackPosition.BOTTOM);
                            setState(() {});
                          },
                          onCancel: (){
                          },
                        );
                      },
                      icon: Icon(Icons.delete),color: Colors.red,),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
  String _getTitle(String title){
    for(int i = title.length; i > 0; i--){
      int a = i-1;
      if(title[a] == '/'){
        return title.substring(i);
      }
    }
    return '';
  }
}