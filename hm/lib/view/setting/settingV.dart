
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/main.dart';

class SettingV extends StatefulWidget{
  @override
  _SettingVState createState() => _SettingVState();
}
class _SettingVState extends State<SettingV>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        //color: Colors.white,
        child: ListView(
          padding: EdgeInsets.only(top: context.mediaQueryPadding.top+20, bottom: 10,),
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
                Get.toNamed(RN.fixFeeType,);

              },
            ),
            Divider(),
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
            Divider(),
            ListTile(
              leading: Text('关于',),
              onTap: (){

              },
            ),
          ],
        ),
      ),
    );
  }
}