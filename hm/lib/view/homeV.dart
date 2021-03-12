
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hm/enumData.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/main.dart';


class HomeV extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 50),
                  child: Text("房屋出租管理",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.house),
                    label: Text("房屋"),
                    onPressed: (){
                      Get.toNamed(RN.house);
                    },
                  ),
                ),
                //Container(
                //  child: ElevatedButton.icon(
                //    icon: Icon(Icons.people),
                //    label: Text("房客"),
                //    onPressed: (){
                //      Get.toNamed(RN.customer);
                //    },
                //  ),
                //),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.backup),
                    label: Text("备份"),
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
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.restore),
                    label: Text("恢复"),
                    onPressed: (){
                      Get.defaultDialog(
                        middleText: '确认要恢复？现有数据将丢失。',
                        onConfirm: ()async{
                          Get.back();
                          await Get.find<HouseL>().restoreData();
                        },
                        onCancel: (){
                          Get.back();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        GetBuilder<HouseL>(
          builder: (_) => _.houseState.actionState == ActionState.PROCESS ?
          Scaffold(body: Center(child: Text("Loading..."),),) :
          Container(),
        ),
      ],
    );
  }
}