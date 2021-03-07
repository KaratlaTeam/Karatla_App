
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/logic/roomL.dart';
import 'package:hm/model/houseM.dart';
import 'package:hm/model/roomM.dart';
import 'package:hm/plugin/myFunctions.dart';


class RoomCreateV extends StatefulWidget {
  @override
  _RoomCreateVState createState() => _RoomCreateVState();
}
class _RoomCreateVState extends State<RoomCreateV> {

  final HouseM _houseM = Get
      .find<HouseL>()
      .houseState
      .housesM
      .houseList[Get
      .find<HouseL>()
      .houseState
      .houseIndex];
  int _levelInt = 1;
  int _roomNumber ;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("添加改变"),
      ),
      body: Container(

        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Text("楼层选择:   "),
                DropdownButton<int>(
                  value: _levelInt,
                  elevation: 16,
                  onChanged: (int newValue) {
                    setState(() {
                      _levelInt = newValue;
                    });
                  },
                  items: levelAmount(),
                ),
              ],
            ),
            Row(
              children: [
                TextButton(child: Text("添加"), onPressed: () async{
                  String back = await Get.find<HouseL>().addRoom(_levelInt, _houseM);
                  Get.back();
                  Get.snackbar("提示", "添加$back。",snackPosition: SnackPosition.BOTTOM);
                },),

                TextButton(child: Text("减少"), onPressed: () async{
                  String back = await Get.find<HouseL>().deleteRoom(_levelInt, _houseM);
                  if(back == '成功'){
                    Get.back();
                  }else{

                  }
                  Get.snackbar("提示", "减少$back。",snackPosition: SnackPosition.BOTTOM);

                },),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<int>> levelAmount(){
    List<DropdownMenuItem<int>> l = [];
    int a = MyFunctions().getHouseHighestLevels(_houseM);
    for(int i = 1; i < a+1; i++){
      l.add(DropdownMenuItem<int>(
        value: i,
        child: Text(i.toString()),
      ));
    }
    return l;
  }
}