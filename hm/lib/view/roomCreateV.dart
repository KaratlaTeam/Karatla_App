
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hm/enumData.dart';
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
        title: Text("房间数量修改"),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                Column(
                  children: [
                    ElevatedButton(child: Text("添加"), onPressed: () async{
                      ActionState backState = await Get.find<HouseL>().addRoom(_levelInt, _houseM);
                      if(backState == ActionState.SUCCESS) {
                        Get.back();
                        Get.snackbar("提示", "添加成功。",snackPosition: SnackPosition.BOTTOM);
                      }

                    },),

                    ElevatedButton(child: Text("减少"), onPressed: () async{
                      ActionState backState = await Get.find<HouseL>().deleteRoom(_levelInt, _houseM);
                      if(backState == ActionState.SUCCESS){
                        Get.back();
                        Get.snackbar("提示", "添加成功。",snackPosition: SnackPosition.BOTTOM);
                      }else{
                        Get.snackbar("提示", "减少失败。",snackPosition: SnackPosition.BOTTOM);
                      }


                    },),
                  ],
                ),
              ],
            ),
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