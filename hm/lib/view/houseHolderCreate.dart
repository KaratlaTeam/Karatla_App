
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hm/model/houseM.dart';

class HouseHolderCreate extends StatefulWidget {
  @override
  _HouseHolderCreateState createState() => _HouseHolderCreateState();
}
class _HouseHolderCreateState extends State<HouseHolderCreate>{
  List<String> feeTypeList = List<String>();
  String _type = "";
  String _name = "";
  String _mark = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("人员添加"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "姓名",
              ),
              onChanged: (String text){
                this._name = text;
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "性别",
              ),
              onChanged: (String text){
                this._mark = text;
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "身份证号",
              ),
              onChanged: (String text){
                this._mark = text;
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "族别",
              ),
              onChanged: (String text){
                this._mark = text;
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "出生日期",
              ),
              onChanged: (String text){
                this._mark = text;
              },
            ),
            TextField(
              decoration: InputDecoration(
                labelText: "住址",
              ),
              onChanged: (String text){
                this._mark = text;
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
            TextButton(child: Text("扫描"),onPressed: (){
              if(_name != "" && _name != null && feeTypeList.length > 0){
                HouseM house = HouseM()..initialize(this._name, this.feeTypeList, this._mark);
                //context.read<HouseList>().addNewHouse(house);
                Navigator.pop(context);
              }


            }, ),

            TextButton(child: Text("添加"),onPressed: (){
              if(_name != "" && _name != null && feeTypeList.length > 0){
                HouseM house = HouseM()..initialize(this._name, this.feeTypeList, this._mark);
                //context.read<HouseList>().addNewHouse(house);
                Navigator.pop(context);
              }


            }, ),
          ],
        ),
      ),
    );
  }

}