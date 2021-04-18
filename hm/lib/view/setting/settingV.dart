
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/main.dart';

class SettingV extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: ListView(
        children: [
          Container(
            //margin: EdgeInsets.only(bottom: 10),
            child: ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
              ),
              child: Icon(Icons.backup),
              onPressed: (){
                Get.defaultDialog(
                    middleText: '确认要备份？',
                    onConfirm: ()async{
                      Get.back();
                      await Get.find<HouseL>().backupData();
                    },
                    onCancel: (){
                      Get.back();
                    }
                );
              },
            ),
          ),
          Container(
            child: ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
              ),
              child: Icon(Icons.restore),
              onPressed: (){
                Get.toNamed(RN.backupList);
              },
            ),
          ),
        ],
      ),
    );
  }
}