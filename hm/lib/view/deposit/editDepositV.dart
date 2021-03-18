import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/logic/roomL.dart';
import 'package:hm/model/houseM.dart';
import 'package:hm/model/myTimeM.dart';
import 'package:hm/model/roomM.dart';

class EditDepositV extends StatefulWidget {
  @override
  _EditDepositVState createState() => _EditDepositVState();
}
class _EditDepositVState extends State<EditDepositV>{
  RoomM _roomM = Get.find<HouseL>().houseState.housesM.houseList[Get.find<HouseL>().houseState.houseIndex].levelList[Get.find<RoomL>().roomS.roomLevel].roomList[Get.find<RoomL>().roomS.roomIndex];
  HouseM _houseM = Get.find<HouseL>().houseState.housesM.houseList[Get.find<HouseL>().houseState.houseIndex];

  double _amount;
  String _mark ;
  MyTimeM _payedTime;
  MyTimeM _refundTime;
  int index;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    index = Get.arguments;
    this._amount = _roomM.depositList[index].amount;
    this._mark = _roomM.depositList[index].mark;
    this._payedTime = _roomM.depositList[index].payedTime;
    this._refundTime = _roomM.depositList[index].refundTime;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('0${_roomM.roomNumber} 更新押金',style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            TextField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.]'))
              ],
              controller: TextEditingController(text: this._amount == null ? '' : this._amount.toString()),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '*押金',
              ),
              onChanged: (String text){
                double amount;
                if(text != '' || text != null ){
                  int i = 0;
                  var b = text;
                  for(var a in b.characters){
                    a == '.' ? i++ : i=i;
                  }
                  if(i > 1 || text == '.'){
                    Get.snackbar('提示', '格式错误', snackPosition: SnackPosition.BOTTOM);
                  }else{
                    try{
                      amount = double.parse(text);

                    }catch (e){
                      printError(info: e.toString());
                      amount = 0.0;
                    }
                    this._amount = amount;
                  }
                  amount = 0;
                  i = 0;
                }
              },
            ),
            TextField(
              controller: TextEditingController(text: this._mark??''),
              decoration: InputDecoration(
                labelText: "押金备注",
              ),
              onChanged: (String text){
                this._mark = text;
              },
            ),
            ListTile(
              leading: Text("*收押日期"),
              title: Text(_payedTime == null ? '' : _payedTime.toString()),
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
                    _payedTime = MyTimeM()..initialize(date.year, date.month, date.day, time.hour, time.minute, 0);
                    setState(() {});
                  }

                },
                child: Text("添加"),
              ),
            ),
            ListTile(
              leading: Text("退押日期"),
              title: Text(_refundTime == null ? '' : _refundTime.toString()),
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
                    _refundTime = MyTimeM()..initialize(date.year, date.month, date.day, time.hour, time.minute, 0);
                    setState(() {});
                  }

                },
                child: Text("添加"),
              ),
            ),

            ElevatedButton(child: Text("更新"),onPressed: ()async{
              if(_amount != null && _payedTime != null){
                Get.find<HouseL>().updateDepositM(Get.find<RoomL>().roomS.roomLevel,Get.find<RoomL>().roomS.roomIndex,index, _mark, _amount, _payedTime, _refundTime);
                Get.back();
                Get.snackbar("提示", "更新成功！", snackPosition: SnackPosition.BOTTOM);
              }else{
                Get.snackbar("提示", "填写不完整！", snackPosition: SnackPosition.BOTTOM);
              }

            }, ),
            ElevatedButton(child: Text("删除"),onPressed: ()async{
              Get.defaultDialog(
                middleText: '是否删除当前房押金 "${_roomM.depositList[index].payedTime.toString()}" 记录？',
                onConfirm: ()async{
                  Get.find<HouseL>().deleteDepositM(Get.find<RoomL>().roomS.roomLevel, Get.find<RoomL>().roomS.roomIndex, index);
                  Get.back();
                  Get.back();
                  Get.snackbar("提示", "删除成功。",snackPosition: SnackPosition.BOTTOM);
                },
                onCancel: (){},
              );

            }, ),
          ],
        ),
      ),
    );
  }
}