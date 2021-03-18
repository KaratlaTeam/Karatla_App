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

class AddRentalFeeV extends StatefulWidget{
  @override
  _AddRentalFeeVState createState() => _AddRentalFeeVState();
}
class _AddRentalFeeVState extends State<AddRentalFeeV>{

  final RoomM _roomM = Get.find<HouseL>().houseState.housesM.houseList[Get.find<HouseL>().houseState.houseIndex].levelList[Get.find<RoomL>().roomS.roomLevel].roomList[Get.find<RoomL>().roomS.roomIndex];
  MyTimeM _shouldPayTime;
  MyTimeM _payedTime;
  List<FeeM> _listFeeM ;
  double _amount = 0;
  String _mark = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._listFeeM = [];
    List<FeeM> rentalFeeLast ;
    if(_roomM.rentalFee.length>0){
      rentalFeeLast = _roomM.rentalFee[0].rentalFee;
    }

    for(int i = 0; i< _roomM.feeTypeCostList.length; i++){
      FeeM feeM = FeeM()..initialize(_roomM.feeTypeCostList[i], 0.0, 1, rentalFeeLast != null ? rentalFeeLast.length > i ? rentalFeeLast[i].usageStartNumber+rentalFeeLast[i].amount : 0.0 : 0.0);
      _listFeeM.add(feeM);
    }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("添加缴费" ),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            TextField(
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
            ElevatedButton(child: Text("创建"),onPressed: (){
              if(_shouldPayTime == null){
                Get.snackbar("提示", '必须设置到期时间', snackPosition: SnackPosition.BOTTOM);
              }else{
                Get.find<HouseL>().addRentalFee(Get.find<RoomL>().roomS.roomLevel, Get.find<RoomL>().roomS.roomIndex,  _shouldPayTime, _payedTime, _listFeeM, _mark);
                Get.back();
                Get.snackbar("提示", '添加成功', snackPosition: SnackPosition.BOTTOM);
              }
            }, )
          ],
        ),
      ),
    );
  }

  List<Widget> _showFeeAmount(){
    List<Widget> widgets = [];
    for(int i = 0; i < _listFeeM.length; i++){
      Widget widget = ListTile(
        horizontalTitleGap: 24,
        leading: Text("${_listFeeM[i].feeTypeCost.type}"),
        title: Text("${_listFeeM[i].feeTypeCost.cost} * ${_listFeeM[i].amount} = ${_listFeeM[i].feeTypeCost.cost * _listFeeM[i].amount}"),
        subtitle: _listFeeM[i].feeTypeCost.rangeAvailable
            ? SizedBox(
          width: 40,height: 30,
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(0),
            ),
            onPressed: (){
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    double usageStartNumber;
                    return SimpleDialog(
                      //titlePadding: EdgeInsets.only(left: 60, top: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      contentPadding: EdgeInsets.symmetric(horizontal: 30),
                      title: Text('${_listFeeM[i].feeTypeCost.type} 起始值'),
                      children: <Widget>[
                        TextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[0-9.]'))
                          ],
                          keyboardType: TextInputType.number,
                          onChanged: (String text){

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
                                  usageStartNumber = double.parse(text);

                                }catch (e){
                                  printError(info: e.toString());
                                  usageStartNumber = 0.0;
                                }
                              }
                            }
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 20),
                              child: TextButton(onPressed: (){
                                Get.back();
                              }, child: Text('取消')),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 20),
                              child: TextButton(onPressed: (){
                                print(usageStartNumber);
                                _listFeeM[i].usageStartNumber = usageStartNumber;
                                setState(() {});
                                Get.back();
                              }, child: Text('确认')),
                            ),
                          ],
                        ),

                      ],
                    );
                  }
              );
            },
            child: Text('${_listFeeM[i].usageStartNumber} ~ ${_listFeeM[i].amount+_listFeeM[i].usageStartNumber}'),
          ),
        )
            : Container(),
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
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[0-9.]'))
          ],
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: _listFeeM[index].feeTypeCost.type+': '+(_listFeeM[index].feeTypeCost.cost*_listFeeM[index].amount).toString()+' 元',
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