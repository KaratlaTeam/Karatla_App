import 'dart:io';

import 'package:data_to_json/Controller/c_root.dart';
import 'package:data_to_json/Plugin/p_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VPropList extends StatelessWidget{
  VPropList({Key? key}) : super(key: key);

  final cRoot = Get.find<CRoot>();
  final tIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Obx(()=>Scaffold(
      appBar: AppBar(title: const Text('道具列表'),),
      body: Column(
        children: [
          Flexible(
            fit: FlexFit.tight,
            flex: 1,
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              scrollDirection: Axis.horizontal,
              itemCount: cRoot.mPropTypeList.value.mPropTypeList.length+1,
              itemBuilder: (context, index){
                return Obx(()=>Card(
                  color: tIndex.value == index ? Colors.amber : Colors.white,
                  elevation: 0,
                  child: InkWell(
                    onTap: (){
                      tIndex.value = index;
                    },
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      child: index == 0 ? const Text('All') : Text(cRoot.mPropTypeList.value.mPropTypeList[index-1].type),
                    ),
                  ),
                ));
              },
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            flex: 15,
            child: ListView.builder(
              itemCount: cRoot.mPropList.value.mPropList.length,
              itemBuilder: (context,index){
                var value = '';
                if(cRoot.mPropList.value.mPropList[index].images.isNotEmpty ){
                  value = cRoot.mPropList.value.mPropList[index].images[0];
                }
                return Obx(()=>tIndex.value==0||cRoot.mPropTypeList.value.mPropTypeList[tIndex.value-1] == cRoot.mPropList.value.mPropList[index].mPropType
                    ?ListTile(
                  onTap: (){
                    cRoot.updateNowPropIndex(index);
                    Get.toNamed(PS.detailProp);
                  },
                  onLongPress: (){
                    _defaultDialog(
                      onConfirm: (){
                        cRoot.removeProp(cRoot.mPropList.value.mPropList[index]);
                        Get.back();
                      },
                    );
                  },
                  title: Text(cRoot.mPropList.value.mPropList[index].name),
                  leading: SizedBox(
                    width: Get.width*0.1,
                    height: Get.width*0.1,
                    child: value==''
                        ?const Icon(Icons.photo)
                        :Hero(tag: value.hashCode,
                      child: Image.file(File(value),fit: BoxFit.cover,),
                    ),
                  ),
                ):Container());

              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
          Get.toNamed(PS.addProp);
        },
      ),
    ));
  }
  _defaultDialog({required Function onConfirm}){
    return Get.defaultDialog(
      title: 'Warning!',
      content: const Text('Delete?'),
      onConfirm: () {
        onConfirm();
      },
      onCancel: () {},
    );
  }
}