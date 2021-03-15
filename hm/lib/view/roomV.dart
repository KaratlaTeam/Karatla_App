import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm/enumData.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/logic/roomL.dart';
import 'package:hm/main.dart';
import 'package:hm/model/houseM.dart';
import 'package:hm/model/myTimeM.dart';
import 'package:hm/model/roomM.dart';
import 'package:hm/plugin/myFunctions.dart';

class RoomV extends StatelessWidget{

  final HouseM _houseM = Get.find<HouseL>().houseState.housesM.houseList[Get.find<HouseL>().houseState.houseIndex];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(_houseM.houseName+"管理"),
      ),
      body: GetBuilder<HouseL>(
        builder: (_) {
          return SingleChildScrollView(
            child: Container(
              child: ExpansionPanelList(
                dividerColor: Colors.white,
                elevation: 0,
                expansionCallback: (int index, bool isExpanded) {
                  _.upDateItemIsExpanded(index, isExpanded);
                },
                children: _.houseState.itemList.map<ExpansionPanel>((Item item) {
                  return ExpansionPanel(
                    isExpanded: item.isExpanded,
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        title: Text(item.houseLevel.name),
                      );
                    },
                    body: Wrap(
                      children: item.houseLevel.roomList.map<Widget>((RoomM roomM) {
                        return Container(
                          alignment: Alignment.centerLeft,
                          width: 80,
                          height: 80,
                          child: Card(
                            color: Colors.white,
                            elevation: 0,
                            child: InkWell(
                              onTap: (){
                                Get.find<RoomL>().setLevelIndex(item.levelIndex);
                                Get.find<RoomL>().setRoomIndex(roomM.roomNumber-1);
                                Get.toNamed(RN.roomDetail);
                              },
                              child: Container(
                                padding: EdgeInsets.all(2),
                                child: Stack(
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Icon(Icons.house,size: 15,color: roomM.roomState == RoomState.OFF ? Colors.grey : roomM.roomState == RoomState.IN ? Colors.green : roomM.roomState == RoomState.OUT ? Colors.black : Colors.red),
                                    ),
                                    Container(
                                      alignment: Alignment.topRight,
                                      child:
                                      MyFunctions().getExpiredLeft(roomM)!=null?
                                      Text(
                                        MyFunctions().getExpiredLeft(roomM).toString(),
                                      ) : Container(),
                                    ),
                                    Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("0"+roomM.roomNumber.toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: (){
          Get.toNamed(RN.houseEdit);
        },
      ),
    );
  }

}
