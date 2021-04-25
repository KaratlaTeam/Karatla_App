
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
        padding: EdgeInsets.only(top: context.mediaQueryPadding.top+20, bottom: 10,left: 10, right: 10),
        children: [
          ListTile(
            title: Text('设置',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
          ),
          ListTile(
            leading: Text('模版',),
            onTap: (){
              Get.toNamed(RN.feeType);
            },
          ),
          ListTile(
            leading: Text('校正',),
            onTap: (){
            },
          ),
          ListTile(
            leading: Text('备份',),
            onTap: (){
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
          ListTile(
            leading: Text('恢复',),
            onTap: (){
              Get.toNamed(RN.backupList);
            },
          ),
        ],
      ),
    );
  }
}