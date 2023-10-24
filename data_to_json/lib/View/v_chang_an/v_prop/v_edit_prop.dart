import 'package:data_to_json/Controller/c_root.dart';
import 'package:data_to_json/Model/m_prop.dart';
import 'package:data_to_json/View/v_chang_an/v_prop/v_common_prop.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class VEditProp extends StatelessWidget{
  VEditProp({Key? key}) : super(key: key);

  final cRoot = Get.find<CRoot>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return VCommonProp(
      initState: (mProp){
        var json = cRoot.mProp?.toJson();
        mProp.value = MProp.fromJson(json!);
      },
      submit: (mProp){
        cRoot.updateProp(mProp.value);
      },
      title: 'Edit Prop',
      submitTitle: 'Save',
    );
  }
}