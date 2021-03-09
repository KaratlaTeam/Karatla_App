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

class AddRentalFeeV extends StatefulWidget{
  @override
  _AddRentalFeeVState createState() => _AddRentalFeeVState();
}
class _AddRentalFeeVState extends State<AddRentalFeeV>{

  final RoomM _roomM = Get.find<HouseL>().houseState.housesM.houseList[Get.find<HouseL>().houseState.houseIndex].roomList[Get.find<RoomL>().roomS.roomIndex];
  MyTimeM _shouldPayTime;

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
              Get.find<HouseL>().addRentalFee(Get.find<RoomL>().roomS.roomIndex,  _shouldPayTime);
              Get.back();
              Get.snackbar("提示", '添加成功', snackPosition: SnackPosition.BOTTOM);
            }, )
          ],
        ),
      ),
    );
  }

}