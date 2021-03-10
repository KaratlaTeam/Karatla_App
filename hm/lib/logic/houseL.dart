import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hm/enumData.dart';
import 'package:hm/model/houseM.dart';
import 'package:hm/model/myTimeM.dart';
import 'package:hm/model/rentalFeeM.dart';
import 'package:hm/model/roomM.dart';
import 'package:hm/plugin/myFunctions.dart';
import 'package:hm/state/houseS.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HouseL extends GetxController{
  HouseS houseState;


  @override
  void onInit() async{
    printInfo(info: 'onInit');
    super.onInit();
    HousesM houseList = HousesM()..initialize();
    this.houseState = HouseS(housesM: houseList);
    await getSharedPHouseList();
  }

  @override
  void onReady() {
    printInfo(info: 'onReady');
    super.onReady();
  }

  @override
  void onClose() {
    printInfo(info: 'onClose');
    super.onClose();

    this.houseState = null;
  }

  Future setSharedPHouseList() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try{
      await sharedPreferences.setString("houseList",json.encode(this.houseState.housesM.toJson()));
      printInfo(info: "set houseList.toJson()");
    }catch (e){
      printError(info: e);
    }
  }

  Future getSharedPHouseList() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonBody = sharedPreferences.getString("houseList");
    if (jsonBody != null) {
      var decodeJsonBody = await json.decode(jsonBody);
      this.houseState.housesM.houseList = HousesM.fromJson(decodeJsonBody).houseList;
      printInfo(info: "get houseList from Json()");
    }else{
      printError(info: "Fail to get houseList from Json() ");
    }
    update();
  }

  Future<ActionState> addRoom(int level, HouseM houseM)async{
    Map<int, int> m = MyFunctions().getRoomsPerLevelMap(houseM);
    int roomNumber = m[level]+1;
    getHouse().roomList.add(RoomM(roomLevel: level, roomNumber: roomNumber));
    await setSharedPHouseList();
    update();
    return ActionState.SUCCESS;
  }

  Future<ActionState> deleteRoom(int level, HouseM houseM)async{
    Map<int, int> m = MyFunctions().getRoomsPerLevelMap(houseM);
    int roomNumber = 0;
    for(int i = 1; i < level+1; i++){
      print(m[i]);
      roomNumber = m[i] + roomNumber;
    }
    if(m[level] > 1){
      getHouse().roomList.removeAt(roomNumber-1);
      await setSharedPHouseList();
      update();
      return ActionState.SUCCESS;
    }else{
      return ActionState.FAIL;
    }
  }

  changeActionState(){
    if(this.houseState.actionState == null){
      this.houseState.actionState = ActionState.COMPLETE;
      changeActionState();
    }else{
      this.houseState.actionState == ActionState.PROCESS ?
      this.houseState.actionState = ActionState.COMPLETE :
      this.houseState.actionState = ActionState.PROCESS;
      printInfo(info: this.houseState.actionState.toString());
    }
    update();
  }

  backupData()async{
    try{
      changeActionState();
      //await Future.delayed(Duration(seconds: 2));
      String backup = json.encode(houseState.housesM.toJson());
      await Clipboard.setData(ClipboardData(text: backup));
      printInfo(info: backup);
      Get.snackbar("提示", "成功备份数据到剪贴版", snackPosition: SnackPosition.BOTTOM);
    }catch (e){
      printError(info: e);
      Get.snackbar("提示", "备份失败", snackPosition: SnackPosition.BOTTOM);
    }
    changeActionState();
    update();
  }

  restoreData()async{
    try{
      changeActionState();
      //await Future.delayed(Duration(seconds: 2));
      ClipboardData data = await Clipboard.getData('text/plain');
      String restore = data.text;
      HousesM housesM = HousesM.fromJson(json.decode(restore));
      this.houseState.housesM = housesM;
      await setSharedPHouseList();
      printInfo(info: restore);
      Get.snackbar("提示", "成功恢复数据从剪贴版", snackPosition: SnackPosition.BOTTOM);
    }catch (e){
      printError(info: e.toString());
      Get.snackbar("提示", "数据恢复失败", snackPosition: SnackPosition.BOTTOM);
    }
    changeActionState();
    update();
  }


  addNewHouse(HouseM houseM)async{
    this.houseState.housesM.houseList.add(houseM);
    await setSharedPHouseList();
    update();
  }

  deleteHouse(int index)async{
    this.houseState.housesM.houseList.removeAt(index);
    await setSharedPHouseList();
    update();
  }

  updateFeeTypeList(List<String> feeTypeList, int roomIndex)async{
    getHouse().feeTypeList = feeTypeList;
    await setSharedPHouseList();
    update();
  }

  updateFeeTypeCostList(List<FeeTypeCost> feeTypeCostList, int roomIndex, String mark)async{
    getRoom(roomIndex).mark = mark;
    getRoom(roomIndex).feeTypeCostList = feeTypeCostList;
    await setSharedPHouseList();
    update();
  }

  addCheckTime(int index, RoomState roomState, MyTimeM myTimeM,[String mark])async{
    try{
      var room = getRoom(index);
      CheckTimeM checkTimeM = CheckTimeM()..initialize(roomState, myTimeM, mark ?? '');
      room.roomState = roomState;
      room.checkTime = room.checkTime.reversed.toList();
      room.checkTime.add(checkTimeM);
      room.checkTime = room.checkTime.reversed.toList();
      await setSharedPHouseList();
      update();
      return 'ok';
    }catch (e){
      printError(info: e.toString());
      return 'no';
    }
  }

  addRentalFee(int index, MyTimeM shouldPay, MyTimeM payedTime, List<FeeM> listFeeM, String mark)async{
    RentalFeeM rentalFeeM = RentalFeeM()..initialize(shouldPay, payedTime, listFeeM, mark);
    var room = getRoom(index);
    room.rentalFee = room.rentalFee.reversed.toList();
    room.rentalFee.add(rentalFeeM);
    room.rentalFee = room.rentalFee.reversed.toList();
    await setSharedPHouseList();
    update();
  }

  updateRentalFee(int indexOfChange,int index, MyTimeM shouldPay, MyTimeM payedTime, List<FeeM> listFeeM, String mark)async{
    RentalFeeM rentalFeeM = RentalFeeM()..initialize(shouldPay, payedTime, listFeeM, mark);
    getRoom(index).rentalFee[indexOfChange] = rentalFeeM;
    await setSharedPHouseList();
    update();
  }

  deleteRentalFee(int roomIndex, int deleteIndex)async{
    getRoom(roomIndex).rentalFee.removeAt(deleteIndex);
    await setSharedPHouseList();
    update();
  }


  /// /////////////////////// functions
  RoomM getRoom(int index){
    return getHouse().roomList[index];
  }

  HouseM getHouse(){
    return this.houseState.housesM.houseList[this.houseState.houseIndex];
  }

  setHouseIndex(int index){
    this.houseState.houseIndex = index;
    update();
  }

  //changeRoomState(int index, RoomState roomState){
  //  getRoom(index).roomState = roomState;
  //}

  String roomStateToString(RoomState roomState){
    //RoomState roomState = getRoom(index).roomState;
    if(roomState == RoomState.ERROR){
      return '错误';

    }else if(roomState == RoomState.IN){
      return '入住';

    }else if(roomState == RoomState.OFF){
      return '空房';

    }else if(roomState == RoomState.OUT){
      return '暂离';

    }else{
      return '错误';
    }
  }

}