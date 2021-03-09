import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/model/houseM.dart';
import 'package:hm/model/roomM.dart';

class AddHouseHolderV extends StatefulWidget{
  @override
  _AddHouseHolderVState createState() => _AddHouseHolderVState();
}
class _AddHouseHolderVState extends State<AddHouseHolderV>{
  List<String> _feeTypeList = [];
  String _type = "";
  String _name = "";
  String _mark = "";
  int _levels = 1;
  Map<int, int> _levelAndNumber = Map<int, int>()..[1]=1;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("创建房子"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
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
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("楼房层数:  $_levels"),
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
                    //Get.snackbar("提示", "楼房层数不能少于一层。",snackPosition: SnackPosition.BOTTOM);
                  }

                })
              ],
            ),
            Column(
              children: _showRooms(),
            ),
            Row(
              children: [
                Container(
                  width: 250,
                  child: TextField(
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
                      _type = "";
                    }

                  });
                }),
              ],
            ),
            Container(
              height: 150,
              padding: EdgeInsets.all(5),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1.5,
                  crossAxisCount: 3,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 0.0,
                ),
                itemCount: _feeTypeList.length,
                itemBuilder: (context,index){
                  return Container(
                    //color: Colors.red,
                    child: Chip(
                      label: Text(_feeTypeList[index]),
                      deleteIcon: Icon(Icons.delete,size: 20,),
                      deleteIconColor: Colors.red,
                      onDeleted: (){
                        setState(() {
                          _feeTypeList.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(child: Text("创建"),onPressed: ()async{
              //if(_name != "" && _name != null && _feeTypeList.length > 0){
              //  List<RoomM> rooms = [];
              //  for(int i = 1; i < _levels+1; i++){
              //    for(int a = 1; a < _levelAndNumber[i]+1; a++){
              //      RoomM room = RoomM()..initialize(i,a, _feeTypeList);
              //      rooms.add(room);
              //    }
              //  }
              //  HouseM house = HouseM()..initialize(this._name, this._feeTypeList, rooms, this._mark);
              //  HouseL houseL = Get.find<HouseL>();
              //  //print("11");
              //  await houseL.addNewHouse(house);
              //  Get.back();
              //  Get.snackbar("提示", "创建成功。",snackPosition: SnackPosition.BOTTOM);
              //}else{
              //  Get.snackbar("提示", "设置不完整。",snackPosition: SnackPosition.BOTTOM);
              //}
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
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("第 $i 层房间数：${_levelAndNumber[i]}"),
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

          })
        ],
      );
      rooms.add(widget);
    }

    return rooms;
  }
}