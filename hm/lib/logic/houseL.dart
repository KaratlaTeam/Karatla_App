import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hm/enumData.dart';
import 'package:hm/main.dart';
import 'package:hm/model/houseM.dart';
import 'package:hm/model/householderM.dart';
import 'package:hm/model/myTimeM.dart';
import 'package:hm/model/rentalFeeM.dart';
import 'package:hm/model/roomM.dart';
import 'package:hm/plugin/myFunctions.dart';
import 'package:hm/state/houseS.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HouseL extends GetxController{
  HouseS houseState;


  @override
  void onInit() async{
    printInfo(info: 'onInit');
    super.onInit();
    HousesM houseList = HousesM()..initialize();
    this.houseState = HouseS(housesM: houseList);
    await this.getAppDirectory();
    await getSharedPHouseList();
    //await getSharedPBackupList();
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

  Future getAppDirectory()async{
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    this.houseState.tempPath = tempPath;
    printInfo(info: 'tempPath: $tempPath');

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    this.houseState.appDocPath = appDocPath;
    var ad = Directory('${appDocDir.path}${RN.backUpDirectoryName}');
    var ex1 = await ad.exists();
    if(!ex1){
      await ad.create();
    }
    printInfo(info: 'appDocBackPath: ${ad.path}');
    printInfo(info: 'appDocPath: $appDocPath');

    if(Platform.isAndroid){
      Directory appStoDir = await getExternalStorageDirectory();
      String appStoPath = appStoDir.path;
      this.houseState.appStoPath = appStoPath;
      var sd = Directory('${appStoDir.path}${RN.backUpDirectoryName}');
      var ex = await sd.exists();
      if(!ex){
        await sd.create();
      }
      printInfo(info: 'appStoBackPath: ${sd.path}');
      printInfo(info: 'appStoPath: $appStoPath');
    }

  }

  //Future setSharedPBackUpList()async{
  //  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //  try{
  //    await sharedPreferences.setStringList('backUpList', this.houseState.backUp.backUpList);
  //  }catch (e){
  //    printError(info: e);
  //  }
  //}

  //Future getSharedPBackupList()async{
  //  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //  try{
  //    this.houseState.backUp.backUpList = sharedPreferences.getStringList('backUpList');
  //    if(this.houseState.backUp.backUpList == null){
  //      this.houseState.backUp.backUpList = [];
  //    }else{
  //      for(var a in this.houseState.backUp.backUpList){
  //        printInfo(info: 'backup list: $a');
  //      }
  //    }
//
  //  }catch (e){
  //    printError(info: e);
  //  }
  //  update();
  //}

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


  backupData()async{
    try{
      var a = DateTime.now();
      String backupPath;
      Platform.isAndroid ? backupPath = this.houseState.appStoPath : backupPath = this.houseState.appDocPath;
      String dateTime = '${a.year}_${a.month}_${a.day}_${a.hour}:${a.minute}:${a.second}';
      var directory = Directory('$backupPath${RN.backUpDirectoryName}');
      String backup = json.encode(houseState.housesM.toJson());
      File file = File('${directory.path}/$dateTime.hm');
      await file.writeAsString(backup);
      //this.houseState.backUp.backUpList.add(dateTime);
      //await setSharedPBackUpList();
      Get.snackbar("提示", "$dateTime 备份成功", snackPosition: SnackPosition.BOTTOM);
    }catch (e){
      printError(info: e.toString());
      Get.snackbar("提示", "备份失败", snackPosition: SnackPosition.BOTTOM);
    }
    update();
  }

  restoreData(FileSystemEntity fileSystemEntity)async{
    try{
      //String backupPath;
      //Platform.isAndroid ? backupPath = this.houseState.appStoPath : backupPath = this.houseState.appDocPath;
      File file = File(fileSystemEntity.path);
      String restore = await file.readAsString();
      HousesM housesM = HousesM.fromJson(json.decode(restore));
      this.houseState.housesM = housesM;
      await setSharedPHouseList();
      Get.snackbar("提示", "数据恢复成功", snackPosition: SnackPosition.BOTTOM);
    }catch (e){
      printError(info: e.toString());
      Get.snackbar("提示", "数据恢复失败", snackPosition: SnackPosition.BOTTOM);
    }
    update();
  }

  List<FileSystemEntity> getRestoreDataList(){
    List<FileSystemEntity> files = [];
    String backupPath;
    Platform.isAndroid ? backupPath = this.houseState.appStoPath : backupPath = this.houseState.appDocPath;
    try{
    var directory = Directory('$backupPath${RN.backUpDirectoryName}');
      for(var f in directory.listSync()){
        if(f.path.endsWith('hm')){
          files.add(f);
          printInfo(info: f.path);
        }
      }
    }catch(e){
      printError(info: e.toString());

    }
    return files;
  }

  Future<ActionState> addRoom(int level, HouseM houseM)async{
    List<FeeTypeCost> listFeeTypeCost = [];
    for(var a in houseM.feeTypeList){
      listFeeTypeCost.add(FeeTypeCost()..initialize(a, 0.0));
    }
    Map<int, int> m = MyFunctions().getRoomsPerLevelMap(houseM);
    int roomNumber = m[level]+1;
    getHouse().roomList.add(RoomM()..initialize(level, roomNumber, listFeeTypeCost));
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


  addNewHouse(HouseM houseM)async{
    this.houseState.housesM.houseList = this.houseState.housesM.houseList.reversed.toList();
    this.houseState.housesM.houseList.add(houseM);
    this.houseState.housesM.houseList = this.houseState.housesM.houseList.reversed.toList();
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

  addHouseHolder(int roomIndex, MyTimeM checkInDate, MyTimeM temporaryIdStart, MyTimeM temporaryIdEnd, String name, String idNum, String sex, int level, int number,  MyTimeM checkOutDate, String nation, String birth, String address, String mark, String photoPath, String temporaryIdPhotoPath)async{
    HouseholderM householderM = HouseholderM()..initialize(checkInDate, temporaryIdStart, temporaryIdEnd, name, idNum, sex, level, number, checkOutDate, nation, birth, address, mark, photoPath, temporaryIdPhotoPath);
    var room = getRoom(roomIndex);
    room.householderList = room.householderList.reversed.toList();
    room.householderList.add(householderM);
    room.householderList = room.householderList.reversed.toList();
    await setSharedPHouseList();
    update();
  }

  deleteHouseHolder(int houseHoldIndex, int roomIndex)async{
    getRoom(roomIndex).householderList.removeAt(houseHoldIndex);
    await setSharedPHouseList();
    update();
  }

  updateHouseHolder(int houseHoldIndex, int roomIndex, MyTimeM checkInDate, MyTimeM temporaryIdStart, MyTimeM temporaryIdEnd, String name, String idNum, String sex, MyTimeM checkOutDate, String nation, String birth, String address, String mark, String photoPath, String temporaryIdPhotoPath)async{
    var room = getRoom(roomIndex);
    int oLevel = room.householderList[houseHoldIndex].level;
    int oNumber = room.householderList[houseHoldIndex].number;
    HouseholderM householderM = HouseholderM()..initialize(checkInDate, temporaryIdStart, temporaryIdEnd, name, idNum, sex,oLevel, oNumber, checkOutDate, nation, birth, address, mark, photoPath, temporaryIdPhotoPath);
    room.householderList[houseHoldIndex] = householderM;
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