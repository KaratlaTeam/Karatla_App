
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/model/houseM.dart';
import 'package:hm/model/roomM.dart';

class HouseCreateV extends StatefulWidget {
  @override
  _HouseCreateVState createState() => _HouseCreateVState();
}
class _HouseCreateVState extends State<HouseCreateV>{
  List<FeeTypeCost> _feeTypeCostList = [];
  List<String> _feeTypeList = [];
  String _type = "";
  String _name = "";
  String _mark = "";
  int _levels = 1;
  Map<int, int> _levelAndNumber = Map<int, int>()..[1]=1;
  String _typeHold = '';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("创建房子"),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(10),
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "房子名称",
              ),
              onChanged: (String text){
                this._name = text;
              },
            ),
            TextField(
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
                Text("楼房层数:  $_levels"),
                Row(
                  children: [
                    IconButton(icon: Icon(CupertinoIcons.add), onPressed: (){
                      setState(() {
                        _levels++;
                        _levelAndNumber[_levels] = 1;
                      });
                    }),
                    IconButton(icon: Icon(CupertinoIcons.minus), onPressed: (){
                      if(_levels > 1){
                        setState(() {
                          _levels--;
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
                    controller: TextEditingController(text: _typeHold??''),
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
                    if(_type != ""){
                      _feeTypeList.add(_type);
                      _feeTypeCostList.add(FeeTypeCost()..initialize(_type, 0.0));
                      _type = "";
                      _typeHold = '';
                    }

                  });
                }),
              ],
            ),
            Wrap(
              children: _showTypes(),
            ),
            ElevatedButton(child: Text("创建"),onPressed: ()async{
              if(_name != "" && _name != null && _feeTypeCostList.length > 0){
                List<RoomM> rooms = [];
                for(int i = 1; i < _levels+1; i++){
                  for(int a = 1; a < _levelAndNumber[i]+1; a++){
                    RoomM room = RoomM()..initialize(i,a, _feeTypeCostList);
                    rooms.add(room);
                  }
                }
                HouseM house = HouseM()..initialize(this._name, this._feeTypeList, rooms, this._mark);
                HouseL houseL = Get.find<HouseL>();
                //print("11");
                await houseL.addNewHouse(house);
                Get.back();
                Get.snackbar("提示", "创建成功。",snackPosition: SnackPosition.BOTTOM);
              }else{
                Get.snackbar("提示", "设置不完整。",snackPosition: SnackPosition.BOTTOM);
              }
            }, )
          ],
        ),
      ),
    );
  }
  
  List<Widget> _showRooms(){
    List<Widget> rooms = [];
    for(int i = 1; i<_levels+1; i++){
      Widget widget = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("第 $i 层房间数：${_levelAndNumber[i]}"),
          Row(
            children: [
              IconButton(icon: Icon(CupertinoIcons.add), onPressed: (){
                setState(() {
                  _levelAndNumber[i]++;
                });
              }),
              IconButton(icon: Icon(CupertinoIcons.minus), onPressed: (){
                if(_levelAndNumber[i] > 1){
                  setState(() {
                    _levelAndNumber[i]--;
                  });
                }else{
                  Get.snackbar("提示", "每层至少一个房间。",snackPosition: SnackPosition.BOTTOM);
                }

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
        child: Chip(
          backgroundColor: Colors.grey.shade200,
          label: Text(_feeTypeCostList[index].type),
          deleteIcon: Icon(Icons.delete,size: 20,),
          deleteIconColor: Colors.red,
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