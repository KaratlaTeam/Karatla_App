import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/main.dart';
import 'package:hm/model/houseM.dart';
import 'package:hm/model/roomM.dart';
import 'package:hm/plugin/myFunctions.dart';

class HouseDetailV extends StatelessWidget{

  final HouseM _houseM = Get.find<HouseL>().houseState.housesM.houseList[Get.find<HouseL>().houseState.houseIndex];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("房屋详情"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(child: Text("房屋名称:  ${_houseM.houseName}"),),
            Container(child: Row(children: showFeeTypeList(),mainAxisAlignment: MainAxisAlignment.center,),),
            Container(child: Text("房屋层数:  ${MyFunctions().getHouseHighestLevels(_houseM)}"),),
            Container(child: Text("房间数量:  ${_houseM.roomList.length}"),),
            Container(child: Text("房屋备注:  ${_houseM.mark}"),),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.delete),
        onPressed: (){
          Get.defaultDialog(
            middleText: "是否要删除?",
            //onConfirm: (){
            //  Get.find<HouseL>().deleteHouse(Get.find<HouseL>().houseState.houseIndex);
            //  Get.back();
            //},
            //onCancel: (){
            //  Get.back();
            //}
            confirm: ElevatedButton(
              child: Text("确认"),
              onPressed: (){
                Get.find<HouseL>().deleteHouse(Get.find<HouseL>().houseState.houseIndex);
                Get.offAllNamed(RN.home);
              },
            ),
            cancel: ElevatedButton(
              child: Text("取消"),
              onPressed: (){
                Get.back();
              },
            ),
          );
        },
      ),
    );
  }
  showFeeTypeList(){
    List<Widget> feeTypeList = [];
    feeTypeList.add(Text("缴费模板:  "),);
    for(String a in _houseM.feeTypeList){
      feeTypeList.add(Text(a+"  "));
    }
    return feeTypeList;
  }

}