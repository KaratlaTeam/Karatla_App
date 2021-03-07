
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/model/houseM.dart';

class HouseCreateV extends StatefulWidget {
  @override
  _HouseCreateVState createState() => _HouseCreateVState();
}
class _HouseCreateVState extends State<HouseCreateV>{
  List<String> feeTypeList = [];
  String _type = "";
  String _name = "";
  String _mark = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("新建房子"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
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
                TextButton(child: Text("添加"),onPressed: (){
                  setState(() {
                    if(_type != ""){
                      feeTypeList.add(_type);
                      _type = "";
                    }

                  });
                }),
              ],
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1.5,
                  crossAxisCount: 3,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 0.0,
                ),
                itemCount: feeTypeList.length,
                itemBuilder: (context,index){
                  return Container(
                    //color: Colors.red,
                    child: Chip(
                      label: Text(feeTypeList[index]),
                      deleteIcon: Icon(Icons.delete,size: 20,),
                      deleteIconColor: Colors.red,
                      onDeleted: (){
                        setState(() {
                          feeTypeList.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            TextButton(child: Text("创建"),onPressed: (){
              if(_name != "" && _name != null && feeTypeList.length > 0){
                HouseM house = HouseM()..initialize(this._name, this.feeTypeList, this._mark);
                HouseL houseL = Get.find<HouseL>()..addNewHouse(house);
                //context.read<HouseList>().addNewHouse(house);
                Get.back();
              }


            }, )
          ],
        ),
      ),
    );
  }

}