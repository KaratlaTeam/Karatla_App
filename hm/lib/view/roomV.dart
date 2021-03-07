import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/logic/roomL.dart';
import 'package:hm/main.dart';
import 'package:hm/model/houseM.dart';

class RoomV extends StatelessWidget{

  final HouseM _houseM = Get.find<HouseL>().houseState.housesM.houseList[Get.find<HouseL>().houseState.houseIndex];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(
          icon: Icon(Icons.info),
          onPressed: (){
            Get.toNamed(RN.houseDetail);
          },
        )],
        title: Text(_houseM.houseName+"管理"),
      ),
      body: ListView.builder(
        itemCount: _houseM.roomList.length,
        itemBuilder: (context, index){
          return ListTile(
            title: Text(_houseM.roomList[index].roomNumber.toString()),//Text(context.watch<HouseList>().houseList[index].houseName),
            onTap: (){
              Get.find<RoomL>().setRoomIndex(index);
              Get.toNamed(RN.roomDetail);
            },
          );

        },

      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          //print(context.read<HouseList>().houseList.length);
          Get.toNamed(RN.roomCreate);
        },
      ),
    );
  }
}