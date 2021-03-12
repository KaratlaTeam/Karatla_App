import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/logic/roomL.dart';
import 'package:hm/main.dart';
import 'package:hm/model/houseM.dart';
import 'package:hm/model/roomM.dart';

class RoomDetailV extends StatefulWidget{
  @override
  _RoomDetailVState createState() => _RoomDetailVState();
}
class _RoomDetailVState extends State<RoomDetailV> with TickerProviderStateMixin{

  final RoomM _roomM = Get.find<HouseL>().houseState.housesM.houseList[Get.find<HouseL>().houseState.houseIndex].roomList[Get.find<RoomL>().roomS.roomIndex];
  final HouseM _houseM = Get.find<HouseL>().houseState.housesM.houseList[Get.find<HouseL>().houseState.houseIndex];
  TabController _tabController;
  int _pIndex = 0;
  List<bool> _stage = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _stage = _offStageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: Icon(Icons.add), onPressed: (){
            if(_tabController.index == 0){
              Get.toNamed(RN.addRentalFee);

            }else if(_tabController.index == 1){
              Get.toNamed(RN.addCheckTime);

            }else if(_tabController.index == 2){
              Get.toNamed(RN.addHouseHolder);

            }
          }),
          IconButton(icon: Icon(Icons.edit), onPressed: (){
            Get.toNamed(RN.roomDetailEdit);
          }),
        ],
        title: ListTile(
          title: Text('${_roomM.roomLevel}0${_roomM.roomNumber}详情',style: TextStyle(color: Colors.white),),
          subtitle: Text("备注:  ${_roomM.mark}",style: TextStyle(color: Colors.white),),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.money),
            ),
            Tab(
              icon: Icon(Icons.sensor_door_sharp),
            ),
            Tab(
              icon: Icon(Icons.people),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          ListView.builder(
            itemCount: _roomM.rentalFee.length,
            itemBuilder: (BuildContext context, int index){
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Card(
                  elevation: 0,
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        _stage[_pIndex] = true;
                        _stage[index] = false;
                        _pIndex = index;
                      });
                    },
                    onLongPress: (){
                      Get.toNamed(RN.rentalFeeEdit, arguments: index);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: [
                          ListTile(
                            horizontalTitleGap: 0,
                            leading: Icon(CupertinoIcons.money_yen,color: _getColor(index)),
                            title: Text(_roomM.rentalFee[index].payedTime == null ? '未付款' : _roomM.rentalFee[index].payedTime.toString()),
                            subtitle: Text(_roomM.rentalFee[index].shouldPayTime.toString()),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(_getPayedAmount(index).toString()),
                                Text(_getShouldPayAmount(index).toString(),style: TextStyle(fontSize: 13, color: Colors.grey),),
                              ],
                            ),
                          ),
                          Offstage(
                            offstage: _stage[index],
                            child: Container(
                              //margin: EdgeInsets.only(left: 30),
                              child: Column(
                                children: _offStageDetail(index),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          ListView.builder(
            //padding: EdgeInsets.all(20),
            itemCount: _roomM.checkTime.length,
            itemBuilder: (BuildContext context, int index){
              return Container(
                //margin: EdgeInsets.only(bottom: 10),
                child: Card(
                  elevation: 0,
                  child: ListTile(
                    onLongPress: (){

                    },
                    horizontalTitleGap: 0,
                    title: Text(_roomM.checkTime[index].checkTime.toString()),
                    subtitle: Text("备注：${_roomM.checkTime[index].mark}"),
                    trailing: Text(Get.find<HouseL>().roomStateToString(_roomM.checkTime[index].checkState)),
                  ),
                ),
              );
            },
          ),
          ListView.builder(
            //padding: EdgeInsets.all(20),
            itemCount: _roomM.householderList.length,
            itemBuilder: (BuildContext context, int index){
              return Container(
                //margin: EdgeInsets.only(bottom: 10),
                child: Card(
                  elevation: 0,
                  child: ListTile(
                    horizontalTitleGap: 0,
                    leading: Icon(Icons.person, color: _roomM.householderList[index].checkOutDate == null ? Colors.green : Colors.grey),
                    title: Text(_roomM.householderList[index].name),
                    trailing: Text(_roomM.householderList[index].idNum),
                    onTap: (){

                    },
                    onLongPress: (){
                      Get.toNamed(RN.houseHoldEdit, arguments: index);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  
  List<bool> _offStageController(){
    List<bool> stage = [false];
    for(int i= 0; i < 9; i++){
      stage.add(true);
    }
    return stage;
  }

  List<Widget> _offStageDetail(int index){
    List<Widget> widgets = [];
    for(var a in _roomM.rentalFee[index].rentalFee){
      ListTile listTile =  ListTile(
        dense: true,
        minVerticalPadding: 0,
        leading: Icon(Icons.add,color: Colors.transparent,),
        title: Text(a.feeTypeCost.type),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(a.payedFee.toString()),
            Text((a.feeTypeCost.cost*a.amount).toString(),style: TextStyle(fontSize: 13, color: Colors.grey),),
          ],
        ),
      );
      widgets.add(listTile);
    }
    ListTile listTileLast = ListTile(
      dense: true,
      minVerticalPadding: 0,
      trailing: Text("${_getPayedAmount(index)-_getShouldPayAmount(index)}",style: TextStyle(color: _getColor(index)),),
      title: Text("结算(元)"),
      leading: Icon(Icons.add,color: Colors.transparent,),
    );
    widgets.add(listTileLast);
    widgets.add(Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.topLeft,
      child: Text("备注：${_roomM.rentalFee[index].mark}", style: TextStyle(color: Colors.grey,fontSize: 12),maxLines: 1,),
    ),);
    return widgets;
  }

  double _getShouldPayAmount(int index){
    double amount = 0;
    for(var a in _roomM.rentalFee[index].rentalFee){
      amount+=(a.amount*a.feeTypeCost.cost);
    }
    return amount;
  }
  double _getPayedAmount(int index){
    double payed = 0;
    for(var a in _roomM.rentalFee[index].rentalFee){
      payed+=a.payedFee;
    }
    return payed;
  }
  Color _getColor(int index){
    Color color ;
    _getPayedAmount(index) < _getShouldPayAmount(index) ? color = Colors.red : color = Colors.green;

    return color;
  }
}