import 'package:data_to_json/Controller/c_root.dart';
import 'package:data_to_json/View/v_chang_an/v_people/v_common_people.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VAddPeople extends StatelessWidget{
  VAddPeople({Key? key}) : super(key: key);

  final cRoot = Get.find<CRoot>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return VCommonPeople(
      title: 'Add People',
      submitTitle: 'Add',
      initState: (mPeople){},
      submit: (mPeople){
        cRoot.addPeople(mPeople.value);
      },
    );
  }
}