import 'dart:convert';

import 'package:get/get.dart';
import 'package:hm/model/houseM.dart';
import 'package:hm/model/roomM.dart';
import 'package:hm/plugin/myFunctions.dart';
import 'package:hm/state/houseS.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HouseL extends GetxController{
  HouseS houseState ;

  @override
  void onInit() async{
    super.onInit();
    HousesM houseList = HousesM()..initialize();
    this.houseState = HouseS(housesM: houseList);
    await getSharedPHouseList();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    this.houseState = null;
  }

  Future<String> addRoom(int level, HouseM houseM)async{
    Map<int, int> m = MyFunctions().getRoomsPerLevelMap(houseM);
    int roomNumber = m[level]+1;
    this.houseState.housesM.houseList[this.houseState.houseIndex].roomList.add(RoomM(roomLevel: level, roomNumber: roomNumber));
    await setSharedPHouseList();
    update();
    return '成功';
  }

  Future<String> deleteRoom(int level, HouseM houseM)async{
    Map<int, int> m = MyFunctions().getRoomsPerLevelMap(houseM);
    int roomNumber = 0;
    for(int i = 1; i < level+1; i++){
      print(m[i]);
      roomNumber = m[i] + roomNumber;
    }
    if(m[level] > 1){
      this.houseState.housesM.houseList[this.houseState.houseIndex].roomList.removeAt(roomNumber-1);
      await setSharedPHouseList();
      update();
      return '成功';
    }else{
      return '失败';
    }
  }

  setHouseIndex(int index){
    this.houseState.houseIndex = index;
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

  Future setSharedPHouseList() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try{
      await sharedPreferences.setString("houseList",json.encode(this.houseState.housesM.toJson()));
      printInfo(info: "set houseList.toJson()");
    }catch (e){
      printError(info: "Error($e): set houseList.toJson()");
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

}