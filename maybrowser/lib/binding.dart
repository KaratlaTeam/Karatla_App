import 'package:get/get.dart';
import 'package:maybrowser/Logic/tabRootL.dart';


class TabRootBinding implements Bindings{
  @override
  void dependencies() {
    printInfo(info: 'TabRootBinding called');
    Get.put(TabRootL());
  }

}
