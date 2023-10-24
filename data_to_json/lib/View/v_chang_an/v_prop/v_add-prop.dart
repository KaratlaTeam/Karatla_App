import 'package:data_to_json/Controller/c_root.dart';
import 'package:data_to_json/View/v_chang_an/v_prop/v_common_prop.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class VAddProp extends StatelessWidget{
  VAddProp({Key? key}) : super(key: key);

  final cRoot = Get.find<CRoot>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return VCommonProp(
      initState: (mProp){
        mProp.update((val) {
          val?.mPropType = cRoot.mPropTypeList.value.mPropTypeList[0];
        });
      },
      submit: (mProp){
        cRoot.addProp(mProp.value);
      },
      title: 'add Prop',
      submitTitle: 'Add',
    );
  }
}