import 'package:data_to_json/Controller/c_root.dart';
import 'package:data_to_json/View/v_chang_an/v_building/v_common_building.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VAddBuilding extends StatelessWidget{
  VAddBuilding({Key? key}) : super(key: key);

  final cRoot = Get.find<CRoot>();

  @override
  Widget build(BuildContext context) {

    return VCommonBuilding(
      initState: (mBuilding){},
      submit: (mBuilding){
        cRoot.addBuilding(mBuilding.value);
      },
      title: 'Add Building',
      submitTitle: 'Add',
    );
  }
}