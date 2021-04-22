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

class RoomV extends StatefulWidget{
  @override
  _RoomVState createState() => _RoomVState();
}
class _RoomVState extends State<RoomV> with TickerProviderStateMixin{

  //final HouseM _houseM = Get.find<HouseL>().houseState.housesM.houseList[Get.find<HouseL>().houseState.houseIndex];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
    return GetBuilder<HouseL>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_.houseState.housesM.houseList[_.houseState.houseIndex].houseName),
            actions: [
              _tabController.index == 0
                  ? IconButton(icon: Icon(Icons.edit), onPressed: (){
                Get.toNamed(RN.houseEdit);
              })
                  : _tabController.index == 1
                  ? IconButton(icon: Icon(Icons.add_circle), onPressed: (){
                Get.toNamed(RN.addExpense);
              })
                  : Container(),
            ],
            bottom: TabBar(
              onTap: (int i){
                setState(() {});
              },
              controller: _tabController,
              tabs: <Widget>[
                Tab(
                  //icon: Icon(Icons.money),
                  text: '房间',
                ),
                Tab(
                  //icon: Icon(Icons.people),
                  text: '支出',
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(
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
                              width: 65,
                              height: 65,
                              child: Card(
                                color: roomM.roomState == RoomState.OFF ? Colors.grey : roomM.roomState == RoomState.IN ? Colors.green : roomM.roomState == RoomState.OUT ? Colors.grey.shade800 : Colors.red,
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
                                          alignment: Alignment.center,
                                          child: Icon(CupertinoIcons.house_alt_fill,size: 36,color: Colors.white),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 42),
                                          alignment: Alignment.bottomLeft,
                                          child: Text("0"+roomM.roomNumber.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),),
                                        ),
                                        Container(
                                          alignment: Alignment.topRight,
                                          child: MyFunctions().getExpiredLeft(roomM)!=null
                                              ? Text(MyFunctions().getExpiredLeft(roomM).toString(),style: TextStyle(color: Colors.white),)
                                              : Container(),
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
              ),
              ListView.builder(
                itemCount: _.houseState.housesM.houseList[_.houseState.houseIndex].houseExpensesList.length,
                itemBuilder: (BuildContext context, int index){
                  return ListTile(
                    onLongPress: (){
                      Get.toNamed(RN.expenseEdit, arguments: index);
                    },
                    title: Text(_.houseState.housesM.houseList[_.houseState.houseIndex].houseExpensesList[index].expense.type),
                    subtitle: Text(_.houseState.housesM.houseList[_.houseState.houseIndex].houseExpensesList[index].expenseDate.toString()),
                    trailing: Text(_.houseState.housesM.houseList[_.houseState.houseIndex].houseExpensesList[index].expense.cost.toString()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

}
