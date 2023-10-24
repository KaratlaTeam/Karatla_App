import 'package:data_to_json/Controller/c_root.dart';
import 'package:data_to_json/View/v_chang_an/v_family/v_common_family.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VAddFamily extends StatelessWidget{
  VAddFamily({Key? key}) : super(key: key);

  final cRoot = Get.find<CRoot>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return VCommonFamily(
      initState: (mFamily){},
      submit: (mFamily){
        cRoot.addFamily(mFamily.value);
      },
      title: 'Add Family',
      submitTitle: 'Add',
    );
  }
}