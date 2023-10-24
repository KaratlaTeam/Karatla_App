import 'package:data_to_json/Controller/c_root.dart';
import 'package:data_to_json/Model/m_building.dart';
import 'package:data_to_json/View/v_chang_an/v_building/v_common_building.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VEditBuilding extends StatelessWidget{
  VEditBuilding({Key? key}) : super(key: key);

  final cRoot = Get.find<CRoot>();

  @override
  Widget build(BuildContext context) {

    return VCommonBuilding(
      initState: (mBuilding){
        var json = cRoot.mBuilding?.toJson();
        mBuilding.value = MBuilding.fromJson(json!);
      },
      submit: (mBuilding){
        cRoot.updateBuilding(mBuilding.value);
      },
      title: 'Edit',
      submitTitle: 'Save',
    );
  }
}