import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hm/enumData.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/logic/roomL.dart';
import 'package:hm/model/houseM.dart';
import 'package:hm/model/myTimeM.dart';
import 'package:hm/model/roomM.dart';
import 'package:image_picker/image_picker.dart';

class EditHouseExpenseV extends StatefulWidget{
  @override
  _EditHouseExpenseVState createState() => _EditHouseExpenseVState();
}
class _EditHouseExpenseVState extends State<EditHouseExpenseV>{

  HouseM _houseM = Get.find<HouseL>().houseState.housesM.houseList[Get.find<HouseL>().houseState.houseIndex];

  String _mark = "";
  MyTimeM _myTimeM ;
  FeeTypeCost _expense = FeeTypeCost()..initialize('', 0.0, false);
  int expenseIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.expenseIndex = Get.arguments;
    this._mark = _houseM.houseExpensesList[expenseIndex].mark;
    this._expense = _houseM.houseExpensesList[expenseIndex].expense;
    this._myTimeM = _houseM.houseExpensesList[expenseIndex].expenseDate;
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("支出添加"),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            TextField(
              controller: TextEditingController(text: _expense == null ? '' : _expense.type),
              decoration: InputDecoration(
                labelText: "*名称",
              ),
              onChanged: (String text){
                this._expense.type = text;
              },
            ),
            TextField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.]'))
              ],
              controller: TextEditingController(text: _expense == null ? '' : _expense.cost.toString()),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '*金额',
              ),
              onChanged: (String text){
                double feePayed;
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
                      feePayed = double.parse(text);

                    }catch (e){
                      printError(info: e.toString());
                      feePayed = 0.0;
                    }
                    _expense.cost = feePayed;
                  }
                  feePayed = 0;
                  i = 0;
                }
              },
            ),
            TextField(
              controller: TextEditingController(text: _mark??''),
              decoration: InputDecoration(
                labelText: "备注",
              ),
              onChanged: (String text){
                this._mark = text;
              },
            ),
            ListTile(
              leading: Text("*时间"),
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

            ElevatedButton(child: Text("更新"),onPressed: ()async{
              if(_myTimeM != null){
                Get.find<HouseL>().updateHouseExpense(_mark,_expense,_myTimeM, expenseIndex);
                Get.back();
                Get.snackbar("提示", "更新成功", snackPosition: SnackPosition.BOTTOM);
              }else{
                Get.snackbar("提示", "请添加时间", snackPosition: SnackPosition.BOTTOM);
              }
            },
            ),
            ElevatedButton(child: Text("删除"),onPressed: ()async{
              Get.defaultDialog(
                onCancel: (){

                },
                onConfirm: (){
                  Get.find<HouseL>().deleteHouseExpense(expenseIndex);
                  Get.back();
                  Get.back();
                  Get.snackbar("提示", '删除成功', snackPosition: SnackPosition.BOTTOM);
                },
                middleText: "是否要删除该条记录？删除后无法恢复。",
              );
            },
            ),

          ],
        ),
      ),
    );
  }
}