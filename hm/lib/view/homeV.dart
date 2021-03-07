import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/main.dart';
import 'package:flutter/services.dart';

class HomeV extends StatefulWidget {

  @override
  _HomeVState createState() => _HomeVState();
}

class _HomeVState extends State<HomeV> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: TextButton(
                child: Text("房屋"),
                onPressed: (){
                  Get.toNamed(RN.house);
                },
              ),
            ),
            Container(
              child: TextButton(
                child: Text("房客"),
                onPressed: (){
                  Get.toNamed(RN.customer);
                },
              ),
            ),
            Container(
              child: TextButton(
                child: Text("备份"),
                onPressed: (){
                  try{
                    String backup = json.encode(Get.find<HouseL>().houseState.housesM.toJson());
                    Clipboard.setData(ClipboardData(text: backup));
                    Get.snackbar("提示", "成功备份数据到剪贴版", snackPosition: SnackPosition.BOTTOM);
                    printInfo(info: backup);
                    //TODO backup roomState null!!!!!
                  }catch (e){
                    printError(info: e);
                    Get.snackbar("提示", "备份失败", snackPosition: SnackPosition.BOTTOM);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}