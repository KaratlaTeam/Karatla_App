import 'package:data_to_json/Controller/c_root.dart';
import 'package:data_to_json/Model/m_people.dart';
import 'package:data_to_json/View/v_chang_an/v_people/v_common_people.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VEditPeople extends StatelessWidget{
  VEditPeople({Key? key}) : super(key: key);

  final cRoot = Get.find<CRoot>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return VCommonPeople(
      title: 'Edit',
      submitTitle: 'Save',
      initState: (mPeople){
        var json = cRoot.mPeople?.toJson();
        mPeople.value = MPeople.fromJson(json!);
      },
      submit: (mPeople){
        cRoot.updatePeople(mPeople.value);
      },
    );
  }
}