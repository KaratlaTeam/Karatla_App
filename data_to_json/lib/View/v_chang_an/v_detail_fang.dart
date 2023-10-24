import 'package:data_to_json/Controller/c_root.dart';
import 'package:data_to_json/Plugin/p_string.dart';
import 'package:data_to_json/View/v_chang_an/v_common_fang.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VDetailFang extends StatelessWidget {
  VDetailFang({Key? key}) : super(key: key);

  final cRoot = Get.find<CRoot>();

  @override
  Widget build(BuildContext context) {
    return Obx(()=>VCommonFang(
      floatActionButton: true,
      mFang: cRoot.mFang,
      newTypes: const ["People", "Family", "Event", "Building"],
      peopleListOnTap: (index, data) {
        cRoot.updateNowPeopleIndex(index);
        Get.toNamed(PS.detailPeople);
      },
      peopleListOnLongTap: (index, data){
        _defaultDialog(
          onConfirm: (){
            cRoot.removePeople(data[index]);
            Get.back();
          },
        );
      },

      eventListOnTap: (index, data) {
        cRoot.updateNowEventIndex(index);
        Get.toNamed(PS.detailEvent);
      },
      eventListOnLongTap: (index, data){
        _defaultDialog(
          onConfirm: (){
            cRoot.removeEvent(data[index]);
            Get.back();
          },
        );
      },

      familyListOnTap: (index, data) {
        cRoot.updateNowFamilyIndex(index);
        Get.toNamed(PS.detailFamily);
      },
      familyListOnLongTap: (index, data){
        _defaultDialog(
          onConfirm: (){
            cRoot.removeFamily(data[index]);
            Get.back();
          },
        );
      },

      buildingListOnTap: (index, data) {
        cRoot.updateNowBuildingIndex(index);
        Get.toNamed(PS.detailBuilding);
      },
      buildingListOnLongTap: (index, data){
        _defaultDialog(
          onConfirm: (){
            cRoot.removeBuilding(data[index]);
            Get.back();
          },
        );
      },
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