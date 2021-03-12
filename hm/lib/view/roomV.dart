import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm/enumData.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/logic/roomL.dart';
import 'package:hm/main.dart';
import 'package:hm/model/houseM.dart';
import 'package:hm/model/roomM.dart';

class RoomV extends StatelessWidget{

  final HouseM _houseM = Get.find<HouseL>().houseState.housesM.houseList[Get.find<HouseL>().houseState.houseIndex];


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        //actions: [IconButton(
        //  icon: Icon(Icons.info),
        //  onPressed: (){
        //    Get.toNamed(RN.houseDetail);
        //  },
        //)],
        title: Text(_houseM.houseName+"管理"),
      ),
      body: GetBuilder<HouseL>(
        builder: (_) => GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            crossAxisCount: 4,
            childAspectRatio: 1,
          ),
          itemCount: _houseM.roomList.length,
          itemBuilder: (context, index){
            _houseM.roomList.sort((a, b) => a.roomLevel.compareTo(b.roomLevel));
            return Card(
              //elevation: 0,
              child: InkWell(
                onTap: (){
                  Get.find<RoomL>().setRoomIndex(index);
                  Get.toNamed(RN.roomDetail);
                },
                child: Container(
                  padding: EdgeInsets.all(2),
                  child: Stack(
                    children: [
                      Icon(Icons.house,size: 15,color: _houseM.roomList[index].roomState == RoomState.OFF ? Colors.grey : _houseM.roomList[index].roomState == RoomState.IN ? Colors.green : _houseM.roomList[index].roomState == RoomState.OUT ? Colors.black : Colors.red),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_houseM.roomList[index].roomLevel.toString()+"0"+_houseM.roomList[index].roomNumber.toString(),style: TextStyle(color: Colors.black),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
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