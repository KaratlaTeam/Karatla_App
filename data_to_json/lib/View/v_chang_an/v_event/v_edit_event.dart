import 'package:data_to_json/Controller/c_root.dart';
import 'package:data_to_json/Model/m_event.dart';
import 'package:data_to_json/View/v_chang_an/v_building/v_common_building.dart';
import 'package:data_to_json/View/v_chang_an/v_event/v_common_event.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VEditEvent extends StatelessWidget{
  VEditEvent({Key? key}) : super(key: key);

  final cRoot = Get.find<CRoot>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return VCommonEvent(
      initState: (mEvent){
        var json = cRoot.mEvent?.toJson();
        mEvent.value = MEvent.fromJson(json!);
      },
      submit: (mEvent){
        cRoot.updateEvent(mEvent.value);
      },
      title: 'Edit',
      submitTitle: 'Save',
    );
  }
}