import 'package:data_to_json/Controller/c_root.dart';
import 'package:get/get.dart';


class CRootBinding implements Bindings{
  @override
  void dependencies() {
    printInfo(info: 'CRootBinding called');
    Get.put(CRoot());
  }

}
