import 'package:data_to_json/Controller/c_root.dart';
import 'package:data_to_json/View/v_chang_an/v_event/v_common_event.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VAddEvent extends StatelessWidget{
  VAddEvent({Key? key}) : super(key: key);

  final cRoot = Get.find<CRoot>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return VCommonEvent(
      initState: (mEvent){},
      submit: (mEvent){
        cRoot.addEvent(mEvent.value);
      },
      title: 'Add Event',
      submitTitle: 'Add',
    );
  }
}