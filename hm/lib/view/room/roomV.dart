import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm/enumData.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/logic/roomL.dart';
import 'package:hm/main.dart';
import 'package:hm/model/roomM.dart';
import 'package:hm/plugin/myFunctions.dart';

class RoomV extends StatefulWidget{
  @override
  _RoomVState createState() => _RoomVState();
}
class _RoomVState extends State<RoomV> with TickerProviderStateMixin{


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GetBuilder<HouseL>(
      builder: (_) {
        return _.houseState.itemList == null
            ? Container()
            : SingleChildScrollView(
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
                          color: _getRoomColor(roomM),
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
                                    child: MyFunctions().getExpiredLeft(roomM)!= null
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
        );
      },
    );
  }

  Color _getRoomColor(RoomM roomM){
    if(MyFunctions().getExpiredLeft(roomM)!= null){
      if(_getPayedAmount(roomM)-_getShouldPayAmount(roomM) < 0){
        return Colors.red;
      }

    }
    if(roomM.roomState == RoomState.OFF){
      return Colors.grey;
    }else if(roomM.roomState == RoomState.IN){
      return Colors.green;
    }else if(roomM.roomState == RoomState.OUT){
      return Colors.grey.shade800;
    }else{
      return Colors.red;
    }
  }
  double _getShouldPayAmount(RoomM _roomM){
    double amount = 0;
    for(var a in _roomM.rentalFee[0].rentalFee){
      amount+=(a.amount*a.feeTypeCost.cost);
    }
    return amount;
  }
  double _getPayedAmount(RoomM _roomM){
    double payed = 0;
    for(var a in _roomM.rentalFee[0].rentalFee){
      payed+=a.payedFee;
    }
    return payed;
  }

}
