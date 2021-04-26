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
  FeeTypeCost _expense = FeeTypeCost()..initialize(null, 0.0, false);
  int expenseIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.expenseIndex = Get.arguments;
    this._mark = _houseM.houseExpensesList[expenseIndex].mark;
    FeeTypeCost feeTypeCost = FeeTypeCost()..initialize(_houseM.houseExpensesList[expenseIndex].expense.type, _houseM.houseExpensesList[expenseIndex].expense.cost, _houseM.houseExpensesList[expenseIndex].expense.rangeAvailable);
    this._expense = feeTypeCost;
    MyTimeM myTimeM = MyTimeM()..initialize(_houseM.houseExpensesList[expenseIndex].expenseDate.year, _houseM.houseExpensesList[expenseIndex].expenseDate.month, _houseM.houseExpensesList[expenseIndex].expenseDate.day, _houseM.houseExpensesList[expenseIndex].expenseDate.hour, _houseM.houseExpensesList[expenseIndex].expenseDate.minute, _houseM.houseExpensesList[expenseIndex].expenseDate.second);
    this._myTimeM = myTimeM;
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
            Row(
              children: [
                Container(
                  width: 250,
                  child: TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9.]'))
                    ],
                    controller: TextEditingController(
                        text: _expense == null ? '' : _expense.cost.toString()),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '*金额 ${checkFeeType() ? '' : '(旧类型：${this._expense.type}，建议修改)'}',
                    ),
                    onChanged: (String text) {
                      double feePayed;
                      if (text != '' || text != null) {
                        int i = 0;
                        var b = text;
                        for (var a in b.characters) {
                          a == '.' ? i++ : i = i;
                        }
                        if (i > 1 || text == '.') {
                          Get.snackbar(
                              '提示', '格式错误', snackPosition: SnackPosition
                              .BOTTOM);
                        } else {
                          try {
                            feePayed = double.parse(text);
                          } catch (e) {
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
                ),

                Container(
                  width: 100,
                  alignment: Alignment.centerRight,
                  child: DropdownButton<String>(
                    hint: Text("类型"),
                    value: checkFeeType() ? this._expense.type : null,
                    elevation: 16,
                    underline: Container(
                      height: 0,
                      color: Colors.black,
                    ),
                    style: TextStyle(
                        color: Colors.black
                    ),
                    onChanged: (String newValue) {
                      this._expense.type = newValue;
                      setState(() {});
                    },
                    items: Get
                        .find<HouseL>()
                        .houseState
                        .housesM
                        .feeTypeList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Container(
                          width: 50,
                          //constraints: BoxConstraints(maxWidth: 100),
                          child: Text(value, maxLines: 1,
                            overflow: TextOverflow.ellipsis,),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),

            ///TextField(
            ///  controller: TextEditingController(text: _expense == null ? '' : _expense.type),
            ///  decoration: InputDecoration(
            ///    labelText: "*名称",
            ///  ),
            ///  onChanged: (String text){
            ///    this._expense.type = text;
            ///  },
            ///),

            TextField(
              controller: TextEditingController(text: _mark ?? ''),
              decoration: InputDecoration(
                labelText: "备注",
              ),
              onChanged: (String text) {
                this._mark = text;
              },
            ),
            ListTile(
              leading: Text("*时间"),
              title: Text(_myTimeM == null ? '' : _myTimeM.toString()),
              trailing: ElevatedButton(
                onPressed: () async {
                  var date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime
                        .now()
                        .year - 1),
                    lastDate: DateTime(DateTime
                        .now()
                        .year + 2),
                  );
                  var time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    helpText: "SELECT START TIME",
                  );
                  if (time != null && date != null) {
                    _myTimeM = MyTimeM()
                      ..initialize(date.year, date.month, date.day, time.hour,
                          time.minute, 0);
                    setState(() {});
                  }
                },
                child: Text("添加"),
              ),
            ),

            ElevatedButton(child: Text("更新"), onPressed: () async {
              if (_myTimeM != null) {
                Get.find<HouseL>().updateHouseExpense(
                    _mark, _expense, _myTimeM, expenseIndex);
                Get.back();
                Get.snackbar("提示", "更新成功", snackPosition: SnackPosition.BOTTOM);
              } else {
                Get.snackbar(
                    "提示", "请添加时间", snackPosition: SnackPosition.BOTTOM);
              }
            },
            ),
            ElevatedButton(child: Text("删除"), onPressed: () async {
              Get.defaultDialog(
                onCancel: () {

                },
                onConfirm: () {
                  Get.find<HouseL>().deleteHouseExpense(expenseIndex);
                  Get.back();
                  Get.back();
                  Get.snackbar(
                      "提示", '删除成功', snackPosition: SnackPosition.BOTTOM);
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
  bool checkFeeType(){
    return Get.find<HouseL>().houseState.housesM.feeTypeList.contains(this._expense.type);
  }
  }
