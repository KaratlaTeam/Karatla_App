import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';

class FeeTypeV extends StatefulWidget{
  @override
  _FeeTypeVState createState() => _FeeTypeVState();
}
class _FeeTypeVState extends State<FeeTypeV>{

  HouseL _houseL = Get.find<HouseL>();
  List<String> _feeTypeList = [];
  String _type = "";

  @override
  void initState() {
    for(var fee in this._houseL.houseState.housesM.feeTypeList){
      this._feeTypeList.add(fee);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('费用模板'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        children: [
          Row(
            children: [
              Expanded(
                //width: 250,
                child: TextField(
                  controller: TextEditingController(text: _type??''),
                  decoration: InputDecoration(
                    labelText: "费用类型",
                  ),
                  onChanged: (String text){
                    this._type = text;
                  },
                ),
              ),
              ElevatedButton(
                  child: Icon(Icons.add_circle),
                  onPressed: (){
                    setState(() {
                      if(_type != "" && _type!=null){
                        if(_feeTypeList.contains(_type)){
                          Get.snackbar("提示", "类型已存在！",snackPosition: SnackPosition.BOTTOM);
                        }else{
                          _feeTypeList.add(_type);
                        }
                        _type = "";
                      }

                    });
                  },
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: Wrap(
              spacing: 5,
              runSpacing: 5,
              children: this._feeTypeList.asMap().map((index,e){
                return MapEntry(index, Container(
                  //color: Colors.red,
                  child: InputChip(
                    side: BorderSide(color: Colors.grey),
                    deleteIconColor: Colors.red,
                    label: Text(this._feeTypeList[index]),
                    backgroundColor: Colors.white,
                    onDeleted: (){
                      setState(() {
                        this._feeTypeList.removeAt(index);
                      });
                    },
                  ),
                ));
              }).values.toList(),
            ),
          ),
          ElevatedButton(
            onPressed: (){
              Get.defaultDialog(
                middleText: '确认要更新吗？',
                onCancel: (){},
                onConfirm: (){
                  Get.back();
                  this._houseL.newUpdateFeeTypeList(this._feeTypeList);
                  Get.back();
                  Get.snackbar('提示', '更新成功', snackPosition: SnackPosition.BOTTOM);
                },
              );
          },
            child: Text('更新'),
          ),
        ],
      ),
    );
  }
}