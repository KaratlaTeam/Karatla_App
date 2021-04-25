import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/logic/roomL.dart';


class HomeBinding implements Bindings{
  @override
  void dependencies() {
    printInfo(info: 'HomeBinding called');
    Get.put(HouseL());
    Get.put(RoomL());
  }

}

class HouseBinding implements Bindings{
  @override
  void dependencies() {
    printInfo(info: 'HouseBinding called');

  }
}

class RoomBinding implements Bindings{
  @override
  void dependencies() {
    printInfo(info: 'RoomBinding called');
    //Get.put(RoomL());
  }
}