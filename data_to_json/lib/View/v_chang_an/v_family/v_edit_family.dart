import 'package:data_to_json/Controller/c_root.dart';
import 'package:data_to_json/Model/m_family.dart';
import 'package:data_to_json/View/v_chang_an/v_family/v_common_family.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VEditFamily extends StatelessWidget{
  VEditFamily({Key? key}) : super(key: key);

  final cRoot = Get.find<CRoot>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return VCommonFamily(
      initState: (mFamily){
        var json = cRoot.mFamily?.toJson();
        mFamily.value = MFamily.fromJson(json!);
      },
      submit: (mFamily){
        cRoot.updateFamily(mFamily.value);
      },
      title: 'Edit',
      submitTitle: 'Save',
    );
  }
}