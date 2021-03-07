import 'dart:convert';

import 'package:get/get.dart';
import 'package:hm/model/houseM.dart';
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