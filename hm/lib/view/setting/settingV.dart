
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/main.dart';
import 'package:package_info/package_info.dart';

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
              leading: Text('关于',style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Image.asset('assets/images/icon.jpeg',fit: BoxFit.contain,height: 80,)
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              alignment: Alignment.center,
              child: Text('${Get.find<HouseL>().houseState.appModel.appName}'),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              alignment: Alignment.center,
              child: Text('V${Get.find<HouseL>().houseState.appModel.version}.${Get.find<HouseL>().houseState.appModel.buildNumber}'),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              alignment: Alignment.center,
              child: Text('Powered by Karatla'),
            ),
          ],
        ),
      ),
    );
  }
}