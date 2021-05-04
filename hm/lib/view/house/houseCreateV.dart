import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/main.dart';
import 'package:hm/model/houseM.dart';
import 'package:hm/model/roomM.dart';
import 'package:image_picker/image_picker.dart';

class HouseCreateV extends StatefulWidget {
  @override
  _HouseCreateVState createState() => _HouseCreateVState();
}
class _HouseCreateVState extends State<HouseCreateV>{
  List<FeeTypeCost> _feeTypeCostList = [];
  List<String> _feeTypeList = [];
  String _type ;
  String _name = "";
  String _mark = "";
  bool isFirstTime ;
  String photoPath ;
  File _image;
  final picker = ImagePicker();

  List<HouseLevel> _levelList = [];

  @override
  void initState() {
    isFirstTime = Get.arguments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(this.isFirstTime == true ? '我的第一个房子' : "创建房子"),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "房子名称",
              ),
              onChanged: (String text){
                this._name = text;
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "房子备注",
                ),
                onChanged: (String text){
                  this._mark = text;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("楼房层数:  ${this._levelList.length}"),
                  Row(
                    children: [
                      IconButton(icon: Icon(Icons.add), onPressed: (){
                        setState(() {
                          int l = this._levelList.length+1;
                          var r = RoomM()..initialize(l-1, 1, _feeTypeCostList);
                          this._levelList.add(HouseLevel()..initialize([r], '$l 层'));
                        });
                      }),
                      IconButton(icon: Icon(Icons.remove), onPressed: (){
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
            ),
            Column(
              children: _showRooms(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 85,
                  child: DropdownButton<String>(
                    hint: Text("费用类型"),
                    value: checkFeeType() ? this._type : null,
                    elevation: 16,
                    underline: Container(
                      height: 0,
                      color: Colors.black,
                    ),
                    style: TextStyle(
                        color: Colors.black
                    ),
                    onChanged: (String newValue) {
                      this._type = newValue;
                      setState(() {});
                    },
                    items: Get
                        .find<HouseL>()
                        .houseState
                        .housesM
                        .feeTypeList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Container(
                          width: 50,
                          //constraints: BoxConstraints(maxWidth: 100),
                          child: Text(value, maxLines: 1,
                            overflow: TextOverflow.ellipsis,),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  child: IconButton(icon: Icon(Icons.add),onPressed: (){
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
                ),
                //IconButton(icon: Icon(Icons.add,color: Colors.transparent),),
              ],
            ),
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children: _showTypes(),
            ),
            _image == null
                ? Container()
                : Container(
              margin: EdgeInsets.only(top: 20,bottom: 20),
              child: InkWell(
                onTap: (){
                  Get.to(()=>Scaffold(
                    backgroundColor: Colors.black,
                    appBar: AppBar(backgroundColor: Colors.black,),
                    body: Container(
                      child: Center(
                        child: Image.file(_image),
                      ),
                    ),
                  ));
                },
                child: Container(
                  child: Image.file(_image, height: 200,width: 190,fit: BoxFit.contain,),
                ),
              ),
            ),
            ElevatedButton(child: Text("添加照片"),onPressed: ()async{
              Get.bottomSheet(
                Container(
                  child: Wrap(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.camera_alt, color: Colors.cyan),
                        title: Text('相机'),
                        onTap: () async{
                          Get.back();
                          await _getImageByOpenCamera();
                        },
                      ),
                      ListTile(
                          leading: Icon(CupertinoIcons.folder_fill,color: Colors.cyan),
                          title: Text('文件'),
                          onTap: () async{
                            Get.back();
                            await _getImageByOpenFile();
                          }
                      ),
                    ],
                  ),
                ),
                backgroundColor: Colors.white,
              );
            },),
            ElevatedButton(child: Text("创建"),onPressed: ()async{
              if(_name != "" && _name != null && _feeTypeCostList.length > 0 && this._levelList.length > 0){
                if(_checkHouseName(_name)){
                  HouseM house = HouseM()..initialize(this._levelList, this._name, this._feeTypeList,this.photoPath,  this._mark);
                  HouseL houseL = Get.find<HouseL>();
                  //print("11");
                  await houseL.addNewHouse(house);

                  if(this.isFirstTime == true){
                    Get.offNamed(RN.home);
                  }else{
                    Get.back();
                  }
                  Get.snackbar("提示", "创建成功。",snackPosition: SnackPosition.BOTTOM);
                }else{
                  Get.snackbar("提示", "房子名称已存在!",snackPosition: SnackPosition.BOTTOM);
                }

              }else{
                Get.snackbar("提示", "设置不完整。",snackPosition: SnackPosition.BOTTOM);
              }
            }, ),
            this.isFirstTime == true
                ? ElevatedButton(child: Text("从已有数据恢复"),onPressed: (){
              Get.toNamed(RN.backupList);
            }, )
                : Container(),

          ],
        ),
      ),
    );
  }

  bool _checkHouseName(String name){
    HouseL houseL = Get.find<HouseL>();
    if(houseL.houseState.housesM.houseList.length != 0){
      for(HouseM houseM in houseL.houseState.housesM.houseList){
        if(houseM.houseName == name){
          return false;
        }
      }
    }
    return true;
  }
  
  List<Widget> _showRooms(){
    List<Widget> rooms = [];
    for(int i = 0; i<this._levelList.length; i++){
      Widget widget = Row(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 150,
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
            ],
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
                        if(this._levelList[i].roomList.length > 1){
                          setState(() {
                            this._levelList[i].roomList.removeLast();
                          });
                        }else{
                          Get.snackbar("提示", "每层至少一个房间。",snackPosition: SnackPosition.BOTTOM);
                        }

                      }),
                    ],
                  ),

                ],
              ),
            ),
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
          side: BorderSide(color: Colors.grey),
          deleteIconColor: Colors.red,
          label: Text(_feeTypeCostList[index].type),
          backgroundColor: Colors.white,
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

  bool checkFeeType(){
    return Get.find<HouseL>().houseState.housesM.feeTypeList.contains(this._type);
  }

  Future _getImageByOpenCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      this.photoPath = _image.path;
    } else {
      print('No image selected.');
    }
    setState(() {});
  }

  Future _getImageByOpenFile() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      this.photoPath = _image.path;
    } else {
      print('No image selected.');
    }
    setState(() {});
  }

}