import 'package:get/get.dart';
import 'package:hm/state/roomS.dart';

class RoomL extends GetxController{
  RoomS roomS ;

  @override
  void onInit() {
    super.onInit();
    printInfo(info: 'onInit');
    this.roomS = RoomS();
  }

  @override
  void onClose() {
    super.onClose();
    printInfo(info: 'onClose');
    this.roomS = null;
  }

  @override
  void onReady() {
    printInfo(info: 'onReady');
    super.onReady();
  }

  setRoomIndex(int index){
    this.roomS.roomIndex = index;
    update();
  }

  setLevelIndex(int index){
    this.roomS.roomLevel = index;
    update();
  }

}