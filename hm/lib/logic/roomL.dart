import 'package:get/get.dart';
import 'package:hm/state/roomS.dart';

class RoomL extends GetxController{
  RoomS roomS ;

  @override
  void onInit() {
    super.onInit();
    this.roomS = RoomS();
  }

  @override
  void onClose() {
    super.onClose();
    this.roomS = null;
  }

  @override
  void onReady() {
    super.onReady();
  }

  setRoomIndex(int index){
    this.roomS.roomIndex = index;
    update();
  }

}