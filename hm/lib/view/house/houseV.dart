
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

      body: GetBuilder<HouseL>(
        builder: (_) => ListView.builder(
          padding: EdgeInsets.only(left: 10, right: 10, top: 40, bottom: 20),
          itemCount: _.houseState.housesM.houseList.length,
          itemBuilder: (context, index){
            return Column(
              children: [
                index == 0
                    ? Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(bottom: 20),
                  child: Text('房屋管理' , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),) ,
                )
                    : Container(),
                Container(
                  width: 380,
                  child: Card(
                    //color: Colors.red,
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    margin: EdgeInsets.symmetric(vertical: 10,),
                    child: InkWell(

                      child: Container(
                        //height: 300,
                        //padding: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                              child: Image.asset('assets/images/house.jpg',fit: BoxFit.cover,width: 380,height: 200,),
                            ),

                            ListTile(
                              title: Text(_.houseState.housesM.houseList[index].houseName, style: TextStyle(fontWeight: FontWeight.bold),),
                              subtitle: Column(
                                children: [
                                  //Row(children: _showFeeTypeList(_.houseState.housesM.houseList[index]),),
                                  Row(children: [Text('备注: '+_.houseState.housesM.houseList[index].mark,style: TextStyle(color: Colors.grey),),],),
                                ],
                              ),
                            ),
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
                      onTap: (){
                        _.setHouseIndex(index);
                        _.setItemList(index);
                        Get.toNamed(RN.room);
                      },
                    ),
                  ),
                ),
              ],
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