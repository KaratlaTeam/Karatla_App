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
   String _typeHold = '';
   String _mark ;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(FeeTypeCost a in _roomM.feeTypeCostList){
      FeeTypeCost feeTypeCost = FeeTypeCost()..initialize(a.type, a.cost);
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
          padding: EdgeInsets.all(10),
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
              children: [
                Container(
                  child: Expanded(
                    child: TextField(
                      controller: TextEditingController(text: _typeHold??''),
                      decoration: InputDecoration(
                        labelText: "缴费类型",
                      ),
                      onChanged: (String text){
                        this._typeHold = text;
                      },
                    ),
                  ),
                ),
                ElevatedButton(child: Text("添加"),onPressed: (){
                  setState(() {
                    if(_typeHold != ""){
                      _feeTypeCostList.add(FeeTypeCost()..initialize(_typeHold, 0.0));
                      _typeHold = '';
                    }

                  });
                }),
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
                     labelText: _feeTypeCostList[index].type+': '+_feeTypeCostList[index].cost.toString()+' 元',
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
             ElevatedButton(child: Text("删除"),onPressed: (){
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

}