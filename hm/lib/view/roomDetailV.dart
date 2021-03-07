import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/logic/roomL.dart';
import 'package:hm/model/houseM.dart';
import 'package:hm/model/roomM.dart';

class RoomDetailV extends StatelessWidget{

  final RoomM _roomM = Get.find<HouseL>().houseState.housesM.houseList[Get.find<HouseL>().houseState.houseIndex].roomList[Get.find<RoomL>().roomS.roomIndex];
  //final HouseM _houseM = Get.find<HouseL>().houseState.housesM.houseList[Get.find<HouseL>().houseState.houseIndex];
  //final RoomL _roomL = Get.find<RoomL>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("${_roomM.roomLevel}0${_roomM.roomNumber}详情"),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(50),
          children: [
           // Container(child: Text("房屋名称:  ${_houseM.houseName}"),alignment: Alignment.centerLeft,),
           // Container(child: Row(children: showFeeTypeList()),alignment: Alignment.centerLeft,),
           // Container(child: Text("房间数量:  ${_houseM.roomList.length}"),alignment: Alignment.centerLeft,),
           // Container(child: Text("房屋备注:  ${_houseM.mark}"),alignment: Alignment.centerLeft,),
          ],
        ),
      ),
    );
  }
  //showFeeTypeList(){
  //  List<Widget> feeTypeList = [];
  //  feeTypeList.add(Text("缴费模板:  "),);
  //  for(String a in _houseM.feeTypeList){
  //    feeTypeList.add(Text(a+"  "));
  //  }
  //  return feeTypeList;
  //}
}