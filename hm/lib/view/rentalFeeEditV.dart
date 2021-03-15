import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/logic/roomL.dart';
import 'package:hm/model/houseM.dart';
import 'package:hm/model/myTimeM.dart';
import 'package:hm/model/rentalFeeM.dart';
import 'package:hm/model/roomM.dart';

class RentalFeeEditV extends StatefulWidget{
  @override
  _RentalFeeEditVState createState() => _RentalFeeEditVState();
}
class _RentalFeeEditVState extends State<RentalFeeEditV>{

  final RoomM _roomM = Get.find<HouseL>().houseState.housesM.houseList[Get.find<HouseL>().houseState.houseIndex].levelList[Get.find<RoomL>().roomS.roomLevel].roomList[Get.find<RoomL>().roomS.roomIndex];
  double _amount = 0;
  int _argument = Get.arguments;
  RentalFeeM _rentalFeeMO;

  MyTimeM _shouldPayTime;
  MyTimeM _payedTime;
  List<FeeM> _listFeeM ;
  String _mark ;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._listFeeM = [];
    for(var a in _roomM.rentalFee[_argument].rentalFee){
      FeeM feeM = FeeM()..initialize(a.feeTypeCost, a.payedFee, a.amount);
      _listFeeM.add(feeM);
    }
    _rentalFeeMO = _roomM.rentalFee[_argument];
    _mark = _rentalFeeMO.mark;
    _shouldPayTime = MyTimeM()..initialize(_rentalFeeMO.shouldPayTime.year, _rentalFeeMO.shouldPayTime.month, _rentalFeeMO.shouldPayTime.day, _rentalFeeMO.shouldPayTime.hour, _rentalFeeMO.shouldPayTime.minute, _rentalFeeMO.shouldPayTime.second);
    if(_rentalFeeMO.payedTime != null){
      _payedTime = MyTimeM()..initialize(_rentalFeeMO.payedTime.year, _rentalFeeMO.payedTime.month, _rentalFeeMO.payedTime.day, _rentalFeeMO.payedTime.hour, _rentalFeeMO.payedTime.minute, _rentalFeeMO.payedTime.second);
    }

  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("更新缴费"),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            TextField(
              controller: TextEditingController(text: _mark??''),
              decoration: InputDecoration(
                labelText: "缴费备注",
              ),
              onChanged: (String text){
                this._mark = text;
              },
            ),
            Column(
              children: _showFeeAmount(),
            ),
            ListTile(
              leading: Text("到期时间"),
              title: Text(_shouldPayTime == null ? '' : _shouldPayTime.toString()),
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
                    _shouldPayTime = MyTimeM()..initialize(date.year, date.month, date.day, time.hour, time.minute, 0);
                    setState(() {});
                  }

                },
                child: Text("添加"),
              ),
            ),
            Column(
              children: _showPayTextFiled(),
            ),
            ListTile(
              leading: Text("缴费时间"),
              title: Text(_payedTime == null ? "" : _payedTime.toString()),
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
            ElevatedButton(child: Text("更新"),onPressed: (){
              Get.find<HouseL>().updateRentalFee(Get.find<RoomL>().roomS.roomLevel, _argument,Get.find<RoomL>().roomS.roomIndex,  _shouldPayTime, _payedTime, _listFeeM, _mark);
              Get.back();
              Get.snackbar("提示", '更新成功', snackPosition: SnackPosition.BOTTOM);
            },
            ),
            ElevatedButton(
              onPressed: (){
                Get.defaultDialog(
                  onCancel: (){

                  },
                  onConfirm: (){
                    Get.find<HouseL>().deleteRentalFee(Get.find<RoomL>().roomS.roomLevel, Get.find<RoomL>().roomS.roomIndex, _argument);
                    Get.back();
                    Get.back();
                    Get.snackbar("提示", '删除成功', snackPosition: SnackPosition.BOTTOM);
                  },
                  middleText: "是否要删除该条记录？删除后无法恢复。",
                );

            },
              child: Text("删除"),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _showFeeAmount(){
    List<Widget> widgets = [];
    for(int i = 0; i < _rentalFeeMO.rentalFee.length; i++){
      Widget widget = ListTile(
        leading: Text("${_listFeeM[i].feeTypeCost.type}"),
        title: Text("${_listFeeM[i].feeTypeCost.cost} * ${_listFeeM[i].amount} = ${_listFeeM[i].feeTypeCost.cost * _listFeeM[i].amount}"),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(icon: Icon(CupertinoIcons.add, size: 17,), onPressed: (){
                setState(() {
                  _listFeeM[i].amount++;
                });
              }),
              IconButton(icon: Icon(CupertinoIcons.minus, size: 17,), onPressed: (){
                if(_listFeeM[i].amount > 0){
                  setState(() {
                    _listFeeM[i].amount--;
                  });
                }else{
                  Get.snackbar("提示", "数量不能少于0。",snackPosition: SnackPosition.BOTTOM);
                }
              }),
            ],
          ),
        ),
      );
      widgets.add(widget);
    }
    _amount = 0;
    for(var a in _listFeeM){
      _amount = a.amount * a.feeTypeCost.cost + _amount;
    }
    widgets.add(
      ListTile(
        leading: Text("合计(元)"),
        title: Text("  $_amount"),
      ),
    );
    return widgets;
  }

  List<Widget> _showPayTextFiled(){
    List<Widget> widgets = [];
    for(int index = 0; index < _listFeeM.length; index++){
      Widget widget = Container(
        child: TextField(
          controller: TextEditingController(text: _listFeeM[index].payedFee.toString()),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[0-9.]'))
          ],
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: _roomM.feeTypeCostList[index].type+': '+(_roomM.feeTypeCostList[index].cost*_listFeeM[index].amount).toString()+' 元',
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
                _listFeeM[index].payedFee = feePayed;
              }
              feePayed = 0;
              i = 0;
            }
          },
        ),
      );
      widgets.add(widget);
    }

    return widgets;
  }
}