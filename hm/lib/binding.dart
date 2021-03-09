import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/logic/roomL.dart';
import 'package:hm/main.dart';

class HomeBinding implements Bindings{
  @override
  void dependencies() {
    printInfo(info: 'HomeBinding called');
    Get.put(HouseL());
  }

}

class HouseBinding implements Bindings{
  @override
  void dependencies() {
    printInfo(info: 'HouseBinding called');
    // TODO: implement dependencies
  }
}

class RoomBinding implements Bindings{
  @override
  void dependencies() {
    printInfo(info: 'RoomBinding called');
    Get.put(RoomL());
  }
}