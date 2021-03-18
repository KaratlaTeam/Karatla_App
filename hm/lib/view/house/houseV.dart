
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/main.dart';
import 'package:get/get.dart';
import 'package:hm/model/houseM.dart';
import 'package:hm/model/roomM.dart';

class HouseV extends StatefulWidget {
  @override
  _HouseVState createState() => _HouseVState();
}
class _HouseVState extends State<HouseV>{

  String _message = '';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("房屋管理"),
      ),
      body: GetBuilder<HouseL>(
        builder: (_) => ListView.builder(
          itemCount: _.houseState.housesM.houseList.length,
          itemBuilder: (context, index){
            return Container(
              child: Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                //elevation: 0,
                child: InkWell(
                  onLongPress: (){
                    Get.defaultDialog(
                      middleText: "是否要删除 '${_.houseState.housesM.houseList[index].houseName}' 房所有数据? 删除后无法恢复，建议提前备份。",
                      onConfirm: (){
                        Get.back();
                        Get.find<HouseL>().deleteHouse(index);
                      },
                      onCancel: (){

                      }
                    );
                  },
                  child: Container(
                    //height: 300,
                    padding: EdgeInsets.all(5),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(_.houseState.housesM.houseList[index].houseName, style: TextStyle(fontWeight: FontWeight.bold),),
                          subtitle: Column(
                            children: [
                              //Row(children: _showFeeTypeList(_.houseState.housesM.houseList[index]),),
                              Row(children: [Text('备注: '+_.houseState.housesM.houseList[index].mark,style: TextStyle(color: Colors.grey),),],),
                            ],
                          ),
                        ),
                        //ListTile(
                        //  //title: Text('将到期: '),
                        //  subtitle: Column(
                        //    children: [
                        //      Row(
                        //        children: [
                        //        Expanded(
                        //          child: _showRoomPayOverride(_.houseState.housesM.houseList[index]),
                        //        ),
                        //      ],
                        //      ),
                        //      Row(
                        //        children: [
                        //          Expanded(
                        //            child: Text('已到期: '),
                        //          ),
                        //        ],
                        //      ),
                        //    ],
                        //  ),
                        //),
                        ListTile(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(children: [
                              Icon(Icons.house),
                              Text("${_showRoomAmount(_.houseState.housesM.houseList[index])}"),
                            ],),
                            Row(children: [
                              Icon(Icons.people),
                              Text(_houseHoldAmount(_.houseState.housesM.houseList[index]).toString()),
                            ],),

                          ],
                        ),
                      ],
                    ),
                  ),
                  onTap: (){
                    _.setHouseIndex(index);
                    _.setItemList(index);
                    Get.toNamed(RN.room);
                  },
                ),
              ),
            );

          },

        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Get.toNamed(RN.houseCreate);
        },
      ),
    );
  }

  _showFeeTypeList(HouseM houseM){
    List<Widget> feeTypeList = [];
    feeTypeList.add(Text("缴费模板:  "),);
    for(String a in houseM.feeTypeList){
      feeTypeList.add(Text(a+"  "));
    }
    return feeTypeList;
  }

  int _showRoomAmount(HouseM houseM){
    int amount = 0;
    for(var a in houseM.levelList){
      amount+=a.roomList.length;
    }
    return amount;
  }

  int _houseHoldAmount(HouseM houseM){
    int amount = 0;
    for(var b in houseM.levelList){
      for(var a in b.roomList){
        amount += a.householderList.length;
      }
    }
    return amount;
  }

  _houseIncomeAmount(HouseM houseM){
    double amount = 0;
    for(var b in houseM.levelList){
      for(var a in b.roomList){
        for(var b in a.feeTypeCostList){
          amount += b.cost;
        }
      }
    }

    return amount;
  }

  double _getShouldPayAmount(RoomM roomM){
    double amount = 0;
    for(var a in roomM.rentalFee[0].rentalFee){
      amount+=(a.amount*a.feeTypeCost.cost);
    }
    return amount;
  }
  double _getPayedAmount(RoomM roomM){
    double payed = 0;
    for(var a in roomM.rentalFee[0].rentalFee){
      payed+=a.payedFee;
    }
    return payed;
  }


}
