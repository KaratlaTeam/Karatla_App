
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm/enumData.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/logic/roomL.dart';
import 'package:hm/model/houseM.dart';
import 'package:hm/model/myTimeM.dart';
import 'package:hm/model/roomM.dart';
import 'package:image_picker/image_picker.dart';

class AddCheckTimeV extends StatefulWidget{
  @override
  _AddCheckTimeVState createState() => _AddCheckTimeVState();
}
class _AddCheckTimeVState extends State<AddCheckTimeV>{
  String _mark = "";
  RoomState _roomState = RoomState.OFF;
  MyTimeM _myTimeM ;

  List<File> _checkTimePhotoList = [];
  final picker = ImagePicker();
  List<String> _photoPathList = [];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("状态记录"),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "状态备注",
              ),
              onChanged: (String text){
                this._mark = text;
              },
            ),
            ListTile(
              title: Text("空房"),
              leading: Radio(
                value: RoomState.OFF,
                groupValue: _roomState,
                onChanged: (roomState){
                  setState(() {
                    _roomState = roomState;
                  });
                },
              ),
            ),
            ListTile(
              title: Text("暂离"),
              leading: Radio(
                value: RoomState.OUT,
                groupValue: _roomState,
                onChanged: (roomState){
                  setState(() {
                    _roomState = roomState;
                  });
                },
              ),
            ),
            ListTile(
              title: Text("入住"),
              leading: Radio(
                value: RoomState.IN,
                groupValue: _roomState,
                onChanged: (roomState){
                  setState(() {
                    _roomState = roomState;
                  });
                },
              ),
            ),
            ListTile(
              leading: Text("时间"),
              title: Text(_myTimeM == null ? '' : _myTimeM.toString()),
              trailing: ElevatedButton(
                onPressed: ()async{
                  var date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year - 1),
                    lastDate: DateTime(DateTime.now().year + 2),
                  );
                  var time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    helpText: "SELECT START TIME",
                  );
                  if(time != null && date!=null){
                    _myTimeM = MyTimeM()..initialize(date.year, date.month, date.day, time.hour, time.minute, 0);
                    setState(() {});
                  }

                },
                child: Text("添加"),
              ),
            ),
            _checkTimePhotoList == null || _checkTimePhotoList.length < 1
                ? Text('')
                : Wrap(
              spacing: 5,
              runSpacing: 5,
              children: _checkTimePhotoList.asMap().map((i, e) => MapEntry(i,InkWell(
                onTap: (){
                  Get.to(()=>Scaffold(
                    backgroundColor: Colors.black,
                    appBar: AppBar(backgroundColor: Colors.black,title: Text('图片${i+1}'),),
                    body: Container(
                      child: Center(
                        child: Image.file(e),
                      ),
                    ),
                  ));
                },
                onLongPress: (){
                  _checkTimePhotoList.removeAt(i);
                  setState(() {});
                },
                child: Container(
                  color: Colors.grey,
                  child: Image.file(e,width: 92, height: 92,fit: BoxFit.cover,),
                ),
              ),)).values.toList(),
            ),

            ElevatedButton(child: Text("记录"),onPressed: ()async{
              if(_myTimeM != null){
                if(_checkTimePhotoList.length>0){
                  for(var a in _checkTimePhotoList){
                    _photoPathList.add(a.path);
                  }
                }
                var a = await Get.find<HouseL>().addCheckTime(Get.find<RoomL>().roomS.roomLevel, Get.find<RoomL>().roomS.roomIndex, _roomState, _myTimeM,_photoPathList, _mark);
                if(a == 'ok'){
                  Get.back();
                  Get.snackbar("提示", "记录成功", snackPosition: SnackPosition.BOTTOM);
                }else{
                  Get.snackbar("提示", "记录失败", snackPosition: SnackPosition.BOTTOM);
                }
              }else{
                Get.snackbar("提示", "请添加时间", snackPosition: SnackPosition.BOTTOM);
              }
              },
            ),
            ElevatedButton(child: Text("添加照片"),onPressed: ()async{
              Get.bottomSheet(
                Container(
                  child: Wrap(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.camera_alt, color: Colors.blue,),
                        title: Text('相机'),
                        onTap: () async{
                          Get.back();
                          final pickedFile = await picker.getImage(source: ImageSource.camera);
                          if (pickedFile != null) {
                            this._checkTimePhotoList.add(File(pickedFile.path));
                          } else {
                            print('No image selected.');
                          }
                          setState(() {});
                        },
                      ),
                      ListTile(
                          leading: Icon(CupertinoIcons.folder_fill,color: Colors.blue,),
                          title: Text('文件'),
                          onTap: () async{
                            Get.back();
                            final pickedFile = await picker.getImage(source: ImageSource.gallery);
                            if (pickedFile != null) {
                              this._checkTimePhotoList.add(File(pickedFile.path));
                            } else {
                              print('No image selected.');
                            }
                            setState(() {});
                          }
                      ),
                    ],
                  ),
                ),
                backgroundColor: Colors.white,
              );
            },),
          ],
        ),
      ),
    );
  }
}