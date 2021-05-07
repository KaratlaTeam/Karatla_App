import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/logic/roomL.dart';
import 'package:hm/model/houseM.dart';
import 'package:hm/model/roomM.dart';

class RoomDetailEditV extends StatefulWidget {
  @override
  _RoomDetailEditVState createState() => _RoomDetailEditVState();
}
class _RoomDetailEditVState extends State<RoomDetailEditV>{
   RoomM _roomM = Get.find<HouseL>().houseState.housesM.houseList[Get.find<HouseL>().houseState.houseIndex].levelList[Get.find<RoomL>().roomS.roomLevel].roomList[Get.find<RoomL>().roomS.roomIndex];
   HouseM _houseM = Get.find<HouseL>().houseState.housesM.houseList[Get.find<HouseL>().houseState.houseIndex];
   List<FeeTypeCost> _feeTypeCostList = [];
   String _typeHold ;
   String _mark ;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(FeeTypeCost a in _roomM.feeTypeCostList){
      FeeTypeCost feeTypeCost = FeeTypeCost()..initialize(a.type, a.cost, a.rangeAvailable);
      _feeTypeCostList.add(feeTypeCost);
    }
    this._mark = _roomM.mark;

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('0${_roomM.roomNumber}编辑',style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            TextField(
              controller: TextEditingController(text: this._mark??''),
              decoration: InputDecoration(
                labelText: "房间备注",
              ),
              onChanged: (String text){
                this._mark = text;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 100,
                  child: DropdownButton<String>(
                    hint: Text("类型"),
                    value: this._typeHold,
                    elevation: 16,
                    underline: Container(
                      height: 0,
                      color: Colors.black,
                    ),
                    style: TextStyle(
                        color: Colors.black
                    ),
                    onChanged: (String newValue) {
                      this._typeHold = newValue;
                      if(_typeHold != "" && _typeHold != null){
                        if(_feeTypeCostList.where((element) => element.type == _typeHold).length > 0){
                          Get.snackbar("提示", "缴费类型已存在！",snackPosition: SnackPosition.BOTTOM);
                        }else{
                          _feeTypeCostList.add(FeeTypeCost()..initialize(_typeHold, 0.0, false));
                        }
                        _typeHold = null;
                      }
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
              ],
            ),
            Column(
              children: _showPayTextFiled(),
            ),
            ElevatedButton(child: Text("更新"),onPressed: ()async{
              if(_feeTypeCostList.length > 0){
                Get.find<HouseL>().updateFeeTypeCostList(Get.find<RoomL>().roomS.roomLevel,_feeTypeCostList, Get.find<RoomL>().roomS.roomIndex, _mark);
                Get.back();
                Get.snackbar("提示", "更新成功！", snackPosition: SnackPosition.BOTTOM);
              }

            }, )
          ],
        ),
      ),
    );
  }

   List<Widget> _showPayTextFiled(){
     List<Widget> widgets = [];
     for(int index = 0; index < _feeTypeCostList.length; index++){
       Widget widget = Container(
         margin: EdgeInsets.only(bottom: 30),
         child: Row(
           children: [
             Container(
               child: Expanded(
                 child: TextField(
                   inputFormatters: [
                     FilteringTextInputFormatter.allow(RegExp('[0-9.]'))
                   ],
                   keyboardType: TextInputType.number,
                   decoration: InputDecoration(
                     labelText: _feeTypeCostList[index].type+': '+_feeTypeCostList[index].cost.toString()+' 元${checkFeeType(index) ? '' : '(建议修改)'}',
                   ),
                   onChanged: (String text){
                     if(text != '' || text != null ){
                       int i = 0;
                       var b = text;
                       for(var a in b.characters){
                         a == '.' ? i++ : i=i;
                       }
                       if(i > 1 || text == '.'){
                         Get.snackbar('提示', '格式错误', snackPosition: SnackPosition.BOTTOM);
                       }else{
                         try{
                           var a = double.parse(text);
                           _feeTypeCostList[index].cost = a;
                         }catch(e){
                           printError(info: e.toString());
                           _feeTypeCostList[index].cost = 0.0;
                         }

                       }
                       i = 0;
                     }
                   },
                 ),
               ),
             ),
             Switch(
               value: _feeTypeCostList[index].rangeAvailable,
               onChanged: (available){
                 _feeTypeCostList[index].rangeAvailable = available;
                 setState(() {});
             },
             ),
             IconButton(icon: Icon(Icons.delete, color: Colors.red, size: 18,),onPressed: (){
               setState(() {
                 _feeTypeCostList.removeAt(index);
               });
             }),
           ],
         ),
       );
       widgets.add(widget);
     }

     return widgets;
   }

   bool checkFeeType(int index){
     return Get.find<HouseL>().houseState.housesM.feeTypeList.contains(this._feeTypeCostList[index].type);
   }

}