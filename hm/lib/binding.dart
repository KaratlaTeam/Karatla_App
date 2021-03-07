import 'package:get/get.dart';
import 'package:hm/logic/houseL.dart';
import 'package:hm/logic/roomL.dart';
import 'package:hm/main.dart';

class HomeBinding implements Bindings{
  @override
  void dependencies() {
    Get.putAsync(()async{
      HouseL houseLogic = HouseL();
      return houseLogic;
    });
  }

}

class HouseBinding implements Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
  }
}

class RoomBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(() => RoomL());
  }
}