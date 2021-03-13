import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tencent_ocr/IDCardOCR.dart';
import 'package:flutter_tencent_ocr/flutter_tencent_ocr.dart';
import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/logic/roomL.dart';
import 'package:hm/model/myTimeM.dart';
import 'package:hm/model/roomM.dart';
import 'package:image_picker/image_picker.dart';

class AddHouseHolderV extends StatefulWidget{
  @override
  _AddHouseHolderVState createState() => _AddHouseHolderVState();
}
class _AddHouseHolderVState extends State<AddHouseHolderV>{

  final RoomM _roomM = Get.find<HouseL>().houseState.housesM.houseList[Get.find<HouseL>().houseState.houseIndex].roomList[Get.find<RoomL>().roomS.roomIndex];
  File _image;
  File _temporaryIdPhoto;
  final picker = ImagePicker();

  String _scanMessage = '';
  String _name ;
  String _sex ;
  String _idNum ;
  String _nation = "";
  String _birth = "";
  String _address = "";
  String _mark = "";
  MyTimeM _checkInDate;
  MyTimeM _checkOutDate;
  String _photoPath;

  MyTimeM _temporaryIdStart;
  MyTimeM _temporaryIdEnd;
  String _temporaryIdPhotoPath;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("添加住户"),
      ),
      body: Container(

        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            TextField(
              controller: TextEditingController(text: _name ?? ''),
              decoration: InputDecoration(
                labelText: "*姓名",
              ),
              onChanged: (String text){
                this._name = text;
              },
            ),
            TextField(
              controller: TextEditingController(text: _sex ?? ''),
              decoration: InputDecoration(
                labelText: "*性别",
              ),
              onChanged: (String text){
                this._sex = text;
              },
            ),
            TextField(
              controller: TextEditingController(text: _idNum ?? ''),
              decoration: InputDecoration(
                labelText: "*身份证号",
              ),
              onChanged: (String text){
                this._idNum = text;
              },
            ),
            TextField(
              controller: TextEditingController(text: _nation ?? ''),
              decoration: InputDecoration(
                labelText: "族别",
              ),
              onChanged: (String text){
                this._nation = text;
              },
            ),
            TextField(
              controller: TextEditingController(text: _birth ?? ''),
              decoration: InputDecoration(
                labelText: "出生日期",
              ),
              onChanged: (String text){
                this._birth = text;
              },
            ),
            TextField(
              controller: TextEditingController(text: _address ?? ''),
              decoration: InputDecoration(
                labelText: "住址",
              ),
              onChanged: (String text){
                this._address = text;
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "备注",
              ),
              onChanged: (String text){
                this._mark = text;
              },
            ),
            ListTile(
              leading: Text("*入住日期"),
              title: Text(_checkInDate == null ? '' : _checkInDate.toString()),
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
                    _checkInDate = MyTimeM()..initialize(date.year, date.month, date.day, time.hour, time.minute, 0);
                    setState(() {});
                  }

                },
                child: Text("添加"),
              ),
            ),
            ListTile(
              leading: Text("退房日期"),
              title: Text(_checkOutDate == null ? '' : _checkOutDate.toString()),
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
                    _checkOutDate = MyTimeM()..initialize(date.year, date.month, date.day, time.hour, time.minute, 0);
                    setState(() {});
                  }
                },
                child: Text("添加"),
              ),
            ),
            ListTile(
              leading: Text("*暂住证签发日"),
              title: Text(_temporaryIdStart == null ? '' : _temporaryIdStart.toString()),
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
                    _temporaryIdStart = MyTimeM()..initialize(date.year, date.month, date.day, time.hour, time.minute, 0);
                    setState(() {});
                  }

                },
                child: Text("添加"),
              ),
            ),
            ListTile(
              leading: Text("*暂住证到期日"),
              title: Text(_temporaryIdEnd == null ? '' : _temporaryIdEnd.toString()),
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
                    _temporaryIdEnd = MyTimeM()..initialize(date.year, date.month, date.day, time.hour, time.minute, 0);
                    setState(() {});
                  }

                },
                child: Text("添加"),
              ),
            ),
            
            _image == null
                ? _photoPath == null
                ? Text('未扫描身份证')
                : Image.file(File(_photoPath))
                : Image.file(_image),
            
            _temporaryIdPhoto == null
                ? _temporaryIdPhotoPath == null
                ? Text('未扫描暂住证')
                : Image.file(File(_temporaryIdPhotoPath))
                : Image.file(_temporaryIdPhoto),
            
            ElevatedButton(child: Text("创建"),onPressed: ()async{
              if(_checkInDate != null && _temporaryIdStart != null && _temporaryIdEnd != null && _name != null && _idNum != null && _sex != null ){
                Get.find<HouseL>().addHouseHolder(Get.find<RoomL>().roomS.roomIndex, _checkInDate, _temporaryIdStart, _temporaryIdEnd, _name, _idNum, _sex, _roomM.roomLevel, _roomM.roomNumber, _checkOutDate, _nation, _birth, _address, _mark, _photoPath, _temporaryIdPhotoPath);
                Get.back();
                Get.snackbar("提示", "添加成功。",snackPosition: SnackPosition.BOTTOM);
              }else{
                Get.snackbar("提示", "信息不完整，添加失败。* 为必填项",snackPosition: SnackPosition.BOTTOM);
              }
            },
            ),
            ElevatedButton(child: Text("扫描身份证"),onPressed: ()async{
              Get.bottomSheet(
                Container(
                  child: Wrap(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.camera_alt, color: Colors.blue,),
                        title: Text('相机'),
                        onTap: () async{
                          Get.back();
                          await _getImageByOpenCamera();
                        },
                      ),
                      ListTile(
                          leading: Icon(CupertinoIcons.folder_fill,color: Colors.blue,),
                          title: Text('文件'),
                          onTap: () async{
                            Get.back();
                            await _getImageByOpenFile();
                          }
                      ),
                    ],
                  ),
                ),
                backgroundColor: Colors.white,
              );
            },),
            ElevatedButton(child: Text("扫描暂住证"),onPressed: ()async{
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
                            this._temporaryIdPhotoPath = pickedFile.path;
                            this._temporaryIdPhoto = File(pickedFile.path);
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
                              this._temporaryIdPhotoPath = pickedFile.path;
                              this._temporaryIdPhoto = File(pickedFile.path);
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

  Future _getImageByOpenCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      this._photoPath = pickedFile.path;
      _image = File(pickedFile.path);
      Uint8List uint8list = await _image.readAsBytes();
      await _idCardOCR(uint8list);
    } else {
      print('No image selected.');
    }
    setState(() {});
  }

  Future _getImageByOpenFile() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      this._photoPath = pickedFile.path;
      _image = File(pickedFile.path);
      Uint8List uint8list = await _image.readAsBytes();
      await _idCardOCR(uint8list);
    } else {
      print('No image selected.');
    }
    setState(() {});
  }

  Future _idCardOCR(Uint8List uint8list) async {
    const String secretId = "AKIDsXt8brSb9RUFjzviBkFUTBra2E9xqb3E";
    const String secretKey = "81dy1wa4HI4crpZ2FBRRAcoHwOZaL5ao";
    //final ByteData imageBytes = await rootBundle.load(path);

    FlutterTencentOcr.iDCardOCR(
      secretId,
      secretKey,
      IDCardOCRRequest.fromParams(
          config: IDCardOCRConfig.fromParams(reshootWarn: true),
          //imageBase64: base64Encode(imageBytes.buffer.asUint8List())),
          imageBase64: base64Encode(uint8list),),
    ).then((onValue) {
      if(onValue.error != null){
        Get.snackbar('提示', '扫描失败', snackPosition: SnackPosition.BOTTOM);
      }else{
        setState(() {
          _name = onValue.name;
          _sex = onValue.sex;
          _nation = onValue.nation;
          _address = onValue.address;
          _birth = onValue.birth;
          _idNum = onValue.idNum;

          _scanMessage = onValue.toString();
          print(_scanMessage);
          Get.snackbar('提示', '扫描成功', snackPosition: SnackPosition.BOTTOM);
        });
      }

    }).catchError(
          (error) {
        setState(() {
          _scanMessage = error;
          Get.snackbar('提示', '扫描失败', snackPosition: SnackPosition.BOTTOM);
        });
      },
    );
  }

}