
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/model/houseM.dart';


class RoomCreateV extends StatefulWidget {
  @override
  _RoomCreateVState createState() => _RoomCreateVState();
}
class _RoomCreateVState extends State<RoomCreateV>{

  Map<int,String> _map = Map<int,String>();
  String _type = "";
  String _level = "";
  String _number = "";
  String _mark = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("添加房间"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
              ],
              decoration: InputDecoration(
                labelText: "层",
              ),
              onChanged: (String text){
                this._level = text;
              },
            ),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
              ],
              decoration: InputDecoration(
                labelText: "号",
              ),
              onChanged: (String text){
                this._number = text;
              },
            ),

            TextField(
              decoration: InputDecoration(
                labelText: "备注",
              ),
              onChanged: (String text){
                this._mark = text;
              },
            ),
            Divider(),
            Text("设置金额"),
            Column(
              children: feeTypeGroup(),
            ),

            TextButton(child: Text("创建"),onPressed: (){

              //if(_level != "" && _level != null && _number != "" && _number != null){
              //  HouseM house = HouseM()..initialize(this._level, this.feeTypeList, this._mark);
              //  //context.read<HouseList>().addNewHouse(house);
              //  Navigator.pop(context);
              //}


            }, )
          ],
        ),
      ),
    );
  }

  List<Widget> feeTypeGroup(){
    List<Widget> list = [];
    int houseIndex = Get.find<HouseL>().houseState.houseIndex;
    List<String> b = Get.find<HouseL>().houseState.housesM.houseList[houseIndex].feeTypeList;

    for(int a = 0; a < b.length; a++){
      Widget widget = TextField(
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
        ],
        decoration: InputDecoration(
          labelText: b[a],
        ),
        onChanged: (String text){
          this._map[a] = text;
        },
      );
      list.add(widget);
    }
    return list;
  }

}