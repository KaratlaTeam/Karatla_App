
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hm/enumData.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/logic/roomL.dart';
import 'package:hm/model/houseM.dart';
import 'package:hm/model/roomM.dart';
import 'package:hm/plugin/myFunctions.dart';


class HouseEditV extends StatefulWidget {
  @override
  _HouseEditVState createState() => _HouseEditVState();
}
class _HouseEditVState extends State<HouseEditV> {

  final HouseM _houseM = Get.find<HouseL>().houseState.housesM.houseList[Get.find<HouseL>().houseState.houseIndex];

  List<FeeTypeCost> _feeTypeCostList = [] ;
  List<String> _feeTypeList = [];
  String _type ;
  String _name ;
  String _mark ;

  List<HouseLevel> _levelList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for(var a in _houseM.levelList){
      _levelList.add(HouseLevel.fromJson(a.toJson()));
    }
    for(var a in _houseM.feeTypeList){
      _feeTypeList.add(a);
      _feeTypeCostList.add(FeeTypeCost()..initialize(a, 0.0, false));
    }
    this._mark = _houseM.mark;
    this._name = _houseM.houseName;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _levelList = null;
    _feeTypeCostList = null ;
    _feeTypeList = null;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("更新房子"),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            TextField(
              controller: TextEditingController(text: _name??''),
              decoration: InputDecoration(
                labelText: "房子名称",
              ),
              onChanged: (String text){
                this._name = text;
              },
            ),
            TextField(
              controller: TextEditingController(text: _mark??''),
              decoration: InputDecoration(
                labelText: "房子备注",
              ),
              onChanged: (String text){
                this._mark = text;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("楼房层数:  ${this._levelList.length}"),
                Row(
                  children: [
                    IconButton(icon: Icon(CupertinoIcons.add), onPressed: (){
                      setState(() {
                        int l = this._levelList.length+1;
                        var r = RoomM()..initialize(l-1, 1, _feeTypeCostList);
                        this._levelList.add(HouseLevel()..initialize([r], '$l 层'));
                      });
                    }),
                    IconButton(icon: Icon(CupertinoIcons.minus), onPressed: (){
                      if(this._levelList.length > 1){
                        setState(() {
                          this._levelList.removeLast();
                        });
                      }else{
                        Get.snackbar("提示", "楼房层数不能少于一层。",snackPosition: SnackPosition.BOTTOM);
                      }

                    }),
                  ],
                ),
              ],
            ),
            Column(
              children: _showRooms(),
            ),
            Row(
              children: [
                Expanded(
                  //width: 250,
                  child: TextField(
                    controller: TextEditingController(text: _type??''),
                    decoration: InputDecoration(
                      labelText: "缴费类型",
                    ),
                    onChanged: (String text){
                      this._type = text;
                    },
                  ),
                ),
                ElevatedButton(child: Text("添加"),onPressed: (){
                  setState(() {
                    if(_type != "" && _type!=null){
                      if(_feeTypeList.contains(_type)){
                        Get.snackbar("提示", "缴费类型已存在！",snackPosition: SnackPosition.BOTTOM);
                      }else{
                        _feeTypeList.add(_type);
                        _feeTypeCostList.add(FeeTypeCost()..initialize(_type, 0.0, false));
                      }
                      _type = "";
                    }

                  });
                }),
              ],
            ),
            Wrap(
              children: _showTypes(),
            ),
            ElevatedButton(child: Text("更新"),onPressed: ()async{
              if(_name != "" && _name != null && _feeTypeCostList.length > 0 && this._levelList.length > 0){
                if(_checkHouseName(_name)){
                  HouseM house = HouseM()..initialize(this._levelList, this._name, this._feeTypeList, this._mark);
                  HouseL houseL = Get.find<HouseL>();
                  await houseL.updateHouse(house, Get.find<HouseL>().houseState.houseIndex);
                  houseL.setItemList(houseL.houseState.houseIndex);
                  Get.back();
                  Get.snackbar("提示", "更新成功。",snackPosition: SnackPosition.BOTTOM);
                }else{
                  Get.snackbar("提示", "房子名称已存在!",snackPosition: SnackPosition.BOTTOM);
                }
              }else{
                Get.snackbar("提示", "设置不完整。",snackPosition: SnackPosition.BOTTOM);
              }
            }, )
          ],
        ),
      ),
    );
  }

  bool _checkHouseName(String name){
    HouseL houseL = Get.find<HouseL>();
    if(houseL.houseState.housesM.houseList.length != 0){
      for(HouseM houseM in houseL.houseState.housesM.houseList){
        if(houseM.houseName == name ){
          if(houseM.houseName != this._houseM.houseName){
            return false;
          }
        }
      }
    }
    return true;
  }

  List<Widget> _showRooms(){
    List<Widget> rooms = [];
    for(int i = 0; i<this._levelList.length; i++){
      Widget widget = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              controller: TextEditingController(text: this._levelList[i].name),
              decoration: InputDecoration(
                labelText: "楼层名称",
              ),
              onChanged: (String text){
                this._levelList[i].name = text;
              },
            ),
          ),
          Text("房间数：${this._levelList[i].roomList.length}"),
          Row(
            children: [
              IconButton(icon: Icon(CupertinoIcons.add), onPressed: (){
                setState(() {
                  int n = this._levelList[i].roomList.length+1;
                  this._levelList[i].roomList.add(RoomM()..initialize(i, n, _feeTypeCostList));
                });
              }),
              IconButton(icon: Icon(CupertinoIcons.minus), onPressed: (){
                Get.defaultDialog(
                  onCancel: (){

                  },
                  onConfirm: (){
                    Get.back();
                    if(this._levelList[i].roomList.length > 1){
                      setState(() {
                        this._levelList[i].roomList.removeLast();
                      });
                    }else{
                      Get.snackbar("提示", "每层至少一个房间。",snackPosition: SnackPosition.BOTTOM);
                    }
                  },
                  middleText: '此操作会删除最后一个房间的所有数据，是否删除？',
                );

              }),
            ],
          ),
        ],
      );
      rooms.add(widget);
    }

    return rooms;
  }

  List<Widget> _showTypes(){
    List<Widget> widgets = [];
    for(int index = 0; index < _feeTypeCostList.length; index++){
      widgets.add(Container(
        //color: Colors.red,
        child: InputChip(
          //side: BorderSide(width: 1, color: Colors.grey),
          deleteIconColor: Colors.red,
          label: Text(_feeTypeCostList[index].type),
          //backgroundColor: Colors.grey,
          onDeleted: (){
            setState(() {
              _feeTypeCostList.removeAt(index);
              _feeTypeList.removeAt(index);
            });
          },
        ),
      ),);
    }
    return widgets;
  }
}