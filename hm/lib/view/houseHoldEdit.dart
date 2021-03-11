import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tencent_ocr/IDCardOCR.dart';
import 'package:flutter_tencent_ocr/flutter_tencent_ocr.dart';
import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/logic/roomL.dart';
import 'package:hm/model/myTimeM.dart';

class EditHouseHolderV extends StatefulWidget{
  @override
  _EditHouseHolderVState createState() => _EditHouseHolderVState();
}
class _EditHouseHolderVState extends State<EditHouseHolderV>{

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
              decoration: InputDecoration(
                labelText: "*姓名",
              ),
              onChanged: (String text){
                this._name = text;
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "*性别",
              ),
              onChanged: (String text){
                this._sex = text;
              },
            ),

            TextField(
              decoration: InputDecoration(
                labelText: "*身份证号",
              ),
              onChanged: (String text){
                this._idNum = text;
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "族别",
              ),
              onChanged: (String text){
                this._nation = text;
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "出生日期",
              ),
              onChanged: (String text){
                this._birth = text;
              },
            ),
            TextField(
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
            ElevatedButton(child: Text("创建"),onPressed: ()async{
              if(_checkInDate != null && _name != null && _idNum != null && _sex != null ){
                Get.find<HouseL>().addHouseHolder(Get.find<RoomL>().roomS.roomIndex, _checkInDate, _name, _idNum, _sex, _checkOutDate, _nation, _address, _mark);
                Get.back();
                Get.snackbar("提示", "添加成功。",snackPosition: SnackPosition.BOTTOM);
              }else{
                Get.snackbar("提示", "信息不完整，添加失败。* 为必填项",snackPosition: SnackPosition.BOTTOM);
              }
            },
            ),
            ElevatedButton(child: Text("扫描身份证"),onPressed: (){

            },),
          ],
        ),
      ),
    );
  }

  Future idCardOCR() async {
    const String secretId = "AKIDsXt8brSb9RUFjzviBkFUTBra2E9xqb3E";
    const String secretKey = "81dy1wa4HI4crpZ2FBRRAcoHwOZaL5ao";
    final ByteData imageBytes = await rootBundle.load('assets/images/test.jpeg');

    FlutterTencentOcr.iDCardOCR(
      secretId,
      secretKey,
      IDCardOCRRequest.fromParams(
          config: IDCardOCRConfig.fromParams(reshootWarn: true),
          imageBase64: base64Encode(imageBytes.buffer.asUint8List())),
    ).then((onValue) {
      setState(() {
        _scanMessage = onValue.toString();
        print(_scanMessage);
      });
    }).catchError(
          (error) {
        setState(() {
          _scanMessage = error;
        });
      },
    );
  }

}