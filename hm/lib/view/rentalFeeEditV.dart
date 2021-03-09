import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/logic/roomL.dart';
import 'package:hm/model/houseM.dart';
import 'package:hm/model/myTimeM.dart';
import 'package:hm/model/rentalFeeM.dart';
import 'package:hm/model/roomM.dart';

class RentalFeeEditV extends StatefulWidget{
  @override
  _RentalFeeEditVState createState() => _RentalFeeEditVState();
}
class _RentalFeeEditVState extends State<RentalFeeEditV>{

  final RoomM _roomM = Get.find<HouseL>().houseState.housesM.houseList[Get.find<HouseL>().houseState.houseIndex].roomList[Get.find<RoomL>().roomS.roomIndex];
  String _mark = "";
  List<FeeM> _rentalFeeList ;
  MyTimeM _shouldPayTime;
  MyTimeM _payedTime;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _rentalFeeList = []..length = _roomM.feeTypeCostList.length;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("添加缴费"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "缴费备注",
              ),
              onChanged: (String text){
                this._mark = text;
              },
            ),

            Container(
              height: 250,
              //padding: EdgeInsets.all(5),
              child: ListView.builder(
                itemCount: _roomM.feeTypeCostList.length,
                itemBuilder: (context,index){
                  return Container(
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
                                labelText: _roomM.feeTypeCostList[index].type+': '+_roomM.feeTypeCostList[index].cost.toString()+' 元',
                              ),
                              onChanged: (String text){
                                double feePayed;
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
                                      feePayed = double.parse(text);

                                    }catch (e){
                                      printError(info: e.toString());
                                      feePayed = 0.0;
                                    }
                                    FeeM feeM = FeeM()..initialize(_roomM.feeTypeCostList[index], feePayed);
                                    _rentalFeeList[index] = feeM;
                                  }
                                  feePayed = 0;
                                  i = 0;
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ListTile(
              leading: Text("缴费时间"),
              title: Text(_payedTime == null ? '' : _payedTime.toString()),
              trailing: ElevatedButton(
                onPressed: ()async{
                  var date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year - 1),
                    lastDate: DateTime(DateTime.now().year + 2),
                  );
                  var time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    helpText: "SELECT START TIME",
                  );
                  if(time != null && date!=null){
                    _payedTime = MyTimeM()..initialize(date.year, date.month, date.day, time.hour, time.minute, 0);
                    setState(() {});
                  }

                },
                child: Text("添加"),
              ),
            ),
            ListTile(
              leading: Text("到期时间"),
              title: Text(_shouldPayTime == null ? '' : _shouldPayTime.toString()),
              trailing: ElevatedButton(
                onPressed: ()async{
                  var date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year - 1),
                    lastDate: DateTime(DateTime.now().year + 2),
                  );
                  var time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    helpText: "SELECT START TIME",
                  );
                  if(time != null && date!=null){
                    _shouldPayTime = MyTimeM()..initialize(date.year, date.month, date.day, time.hour, time.minute, 0);
                    setState(() {});
                  }

                },
                child: Text("添加"),
              ),
            ),
            ElevatedButton(child: Text("创建"),onPressed: (){
              //Get.find<HouseL>().addRentalFee(Get.find<RoomL>().roomS.roomIndex, _rentalFeeList, _shouldPayTime, _payedTime, _mark);
              Get.back();
              Get.snackbar("提示", '添加成功', snackPosition: SnackPosition.BOTTOM);
            }, )
          ],
        ),
      ),
    );
  }

}