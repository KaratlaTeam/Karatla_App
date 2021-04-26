import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';
import 'package:hm/enumData.dart';
import 'package:hm/main.dart';
import 'package:hm/model/depositM.dart';
import 'package:hm/model/houseExpensesM.dart';
import 'package:hm/model/houseM.dart';
import 'package:hm/model/householderM.dart';
import 'package:hm/model/myTimeM.dart';
import 'package:hm/model/rentalFeeM.dart';
import 'package:hm/model/roomM.dart';
import 'package:hm/plugin/myFunctions.dart';
import 'package:hm/state/houseS.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HouseL extends GetxController with StateMixin<HouseS>{
  HouseS houseState;

  @override
  void onInit() {
    change(houseState, status: RxStatus.loading());
    printInfo(info: 'onInit');
    HousesM houseList = HousesM()..initialize();
    CarouselController carouselController = CarouselController();
    this.houseState = HouseS(housesM: houseList,carouselController: carouselController);
    this.getAppDirectory();
    this.getSharedPHouseList();
    change(houseState, status: RxStatus.success());
    super.onInit();
  }

  @override
  void onReady() {
    printInfo(info: 'onReady');
    super.onReady();
  }

  @override
  void onClose() {
    printInfo(info: 'onClose');
    this.houseState = null;
    super.onClose();
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
      //printInfo(info: this.houseState.housesM.toJson().toString());
      await sharedPreferences.setString("HousesM",json.encode(this.houseState.housesM.toJson()));
      printInfo(info: "set HousesM.toJson()");
    }catch (e){
      printError(info: e);
    }
  }

  Future getSharedPHouseList() async{
    change(this.houseState, status: RxStatus.loading());
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonBody = sharedPreferences.getString("HousesM");
    if (jsonBody != null) {
      var decodeJsonBody = await json.decode(jsonBody);
      this.houseState.housesM = HousesM.fromJson(decodeJsonBody);
      printInfo(info: "get HousesM from Json()");
      this.setHouseIndex(0);
      this.setItemList(0);
      await Future.delayed(Duration(seconds:  2));
      change(this.houseState, status: RxStatus.success());
      this.houseState.housesM.houseList.length == 0
          ? Get.offNamed(RN.houseCreate, arguments: true)
          : Get.offNamed(RN.home);
    }else{
      printError(info: "Fail to get HousesM from Json() ");
      Get.offNamed(RN.houseCreate,arguments: true);
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
      ///Clipboard.setData(ClipboardData(text: backup));///
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
      change(houseState, status: RxStatus.loading());
      //String backupPath;
      //Platform.isAndroid ? backupPath = this.houseState.appStoPath : backupPath = this.houseState.appDocPath;
      File file = File(fileSystemEntity.path);
      String restore = await file.readAsString();
      HousesM housesM = HousesM.fromJson(json.decode(restore));
      this.houseState.housesM = housesM;
      await setSharedPHouseList();
      ///await Future.delayed(Duration(seconds: 4));
      change(houseState, status: RxStatus.success());
      Get.offNamed(RN.home);
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



  addNewHouse(HouseM houseM)async{
    this.houseState.housesM.houseList = this.houseState.housesM.houseList.reversed.toList();
    this.houseState.housesM.houseList.add(houseM);
    this.houseState.housesM.houseList = this.houseState.housesM.houseList.reversed.toList();
    setHouseIndex(0);
    setItemList(0);
    this.houseState.carouselController.jumpToPage(0);
    houseHolderListToNull();
    await setSharedPHouseList();
    update();
  }

  updateHouse(HouseM houseM, int index)async{
    this.houseState.housesM.houseList[index] = houseM;
    houseHolderListToNull();
    await setSharedPHouseList();
    update();
  }

  deleteHouse(int index)async{
    this.houseState.housesM.houseList.removeAt(index);
    if(houseState.housesM.houseList.length > 0){
      if(index == 0 || this.houseState.housesM.houseList.length  == index){
        /// if first
        if(index == 0){
          setHouseIndex(index);
          setItemList(index);
          this.houseState.carouselController.jumpToPage(index);
        }
        /// if last
        if(this.houseState.housesM.houseList.length  == index){
          setHouseIndex(this.houseState.housesM.houseList.length-1);
          setItemList(this.houseState.housesM.houseList.length-1);
          this.houseState.carouselController.jumpToPage(this.houseState.housesM.houseList.length-1);
        }
      }else{
        setHouseIndex(index);
        setItemList(index);
        this.houseState.carouselController.jumpToPage(index);
      }
    }else{
      setHouseIndex(0);
      setItemList(0);
      Get.offNamed(RN.houseCreate, arguments: true);
    }
    houseHolderListToNull();
    await setSharedPHouseList();
    update();
  }

  updateFeeTypeList(List<String> feeTypeList, int roomIndex)async{
    getHouse().feeTypeList = feeTypeList;
    await setSharedPHouseList();
    update();
  }

  updateFeeTypeCostList(int levelIndex, List<FeeTypeCost> feeTypeCostList, int roomIndex, String mark)async{
    getRoom(roomIndex, levelIndex).mark = mark;
    getRoom(roomIndex, levelIndex).feeTypeCostList = feeTypeCostList;
    await setSharedPHouseList();
    update();
  }

  addCheckTime(int levelIndex, int index, RoomState roomState, MyTimeM myTimeM,List<String> photoPathList,[String mark])async{
    try{
      var room = getRoom(index, levelIndex);
      CheckTimeM checkTimeM = CheckTimeM()..initialize(roomState, myTimeM, photoPathList, mark ?? '');
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

  updateCheckTime(int levelIndex, int index,int checkTimeIndex, RoomState roomState, MyTimeM myTimeM,List<String> photoPathList, [String mark])async{
    try{
      var room = getRoom(index, levelIndex);
      CheckTimeM checkTimeM = CheckTimeM()..initialize(roomState, myTimeM,photoPathList, mark ?? '');
      if(checkTimeIndex == 0){
        room.roomState = roomState;
      }
      room.checkTime[checkTimeIndex] = checkTimeM;
      await setSharedPHouseList();
      update();
      return 'ok';
    }catch (e){
      printError(info: e.toString());
      return 'no';
    }
  }

  deleteCheckTime(int levelIndex, int index, int deleteIndex)async{
    var room = getRoom(index, levelIndex);
    room.checkTime.removeAt(deleteIndex);
    if(room.checkTime.length > 0){
      room.roomState = room.checkTime[0].checkState;
    }else{
      room.roomState = RoomState.OFF;
    }
    await setSharedPHouseList();
    update();
  }

  addRentalFee(int levelIndex, int index, MyTimeM shouldPay, MyTimeM payedTime, List<FeeM> listFeeM, String mark)async{
    RentalFeeM rentalFeeM = RentalFeeM()..initialize(shouldPay, payedTime, listFeeM, mark);
    var room = getRoom(index, levelIndex);
    room.rentalFee = room.rentalFee.reversed.toList();
    room.rentalFee.add(rentalFeeM);
    room.rentalFee = room.rentalFee.reversed.toList();
    await setSharedPHouseList();
    update();
  }

  updateRentalFee(int levelIndex, int indexOfChange,int index, MyTimeM shouldPay, MyTimeM payedTime, List<FeeM> listFeeM, String mark)async{
    RentalFeeM rentalFeeM = RentalFeeM()..initialize(shouldPay, payedTime, listFeeM, mark);
    getRoom(index, levelIndex).rentalFee[indexOfChange] = rentalFeeM;
    await setSharedPHouseList();
    update();
  }

  deleteRentalFee(int levelIndex, int roomIndex, int deleteIndex)async{
    getRoom(roomIndex, levelIndex).rentalFee.removeAt(deleteIndex);
    await setSharedPHouseList();
    update();
  }

  addHouseHolder(String phoneNumber, int levelIndex, int roomIndex, MyTimeM checkInDate, MyTimeM temporaryIdStart, MyTimeM temporaryIdEnd, String name, String idNum, String sex, int level, int number,  MyTimeM checkOutDate, String nation, String birth, String address, String mark, String photoPath, String temporaryIdPhotoPath)async{
    HouseholderM householderM = HouseholderM()..initialize(checkInDate, temporaryIdStart, temporaryIdEnd, name, idNum, sex, level, number, checkOutDate, nation, birth, address, mark, photoPath, temporaryIdPhotoPath, phoneNumber);
    var room = getRoom(roomIndex, levelIndex);
    room.householderList = room.householderList.reversed.toList();
    room.householderList.add(householderM);
    room.householderList = room.householderList.reversed.toList();
    await setSharedPHouseList();
    update();
  }

  deleteHouseHolder(int levelIndex, int houseHoldIndex, int roomIndex)async{
    getRoom(roomIndex,levelIndex ).householderList.removeAt(houseHoldIndex);
    await setSharedPHouseList();
    update();
  }

  updateHouseHolder(String phoneNumber, int levelIndex,int houseHoldIndex, int roomIndex, MyTimeM checkInDate, MyTimeM temporaryIdStart, MyTimeM temporaryIdEnd, String name, String idNum, String sex, MyTimeM checkOutDate, String nation, String birth, String address, String mark, String photoPath, String temporaryIdPhotoPath)async{
    var room = getRoom(roomIndex, levelIndex);
    int oLevel = room.householderList[houseHoldIndex].level;
    int oNumber = room.householderList[houseHoldIndex].number;
    HouseholderM householderM = HouseholderM()..initialize(checkInDate, temporaryIdStart, temporaryIdEnd, name, idNum, sex,oLevel, oNumber, checkOutDate, nation, birth, address, mark, photoPath, temporaryIdPhotoPath, phoneNumber);
    room.householderList[houseHoldIndex] = householderM;
    await setSharedPHouseList();
    update();
  }

  addDepositM (int levelIndex, int roomIndex,String mark, double amount, MyTimeM payedTime, MyTimeM refundTime, ) async{
    var room = getRoom(roomIndex, levelIndex);
    DepositM deposit = DepositM()..initialize(mark, amount, payedTime, refundTime);
    room.depositList = room.depositList.reversed.toList();
    room.depositList.add(deposit);
    room.depositList = room.depositList.reversed.toList();
    await setSharedPHouseList();
    update();
  }

  updateDepositM (int levelIndex, int roomIndex,int depositIndex, String mark, double amount, MyTimeM payedTime, MyTimeM refundTime,) async{
    var room = getRoom(roomIndex, levelIndex);
    DepositM deposit = DepositM()..initialize(mark, amount, payedTime, refundTime);
    room.depositList[depositIndex] = deposit;
    await setSharedPHouseList();
    update();
  }

  deleteDepositM (int levelIndex, int roomIndex,int depositIndex) async{
    var room = getRoom(roomIndex, levelIndex);
    room.depositList.removeAt(depositIndex);
    await setSharedPHouseList();
    update();
  }

  addHouseExpense(String mark, FeeTypeCost expense, MyTimeM expenseDate)async{
    var house = getHouse();
    HouseExpensesM houseExpense = HouseExpensesM()..initialize(mark, expense, expenseDate);
    house.houseExpensesList = house.houseExpensesList.reversed.toList();
    house.houseExpensesList.add(houseExpense);
    house.houseExpensesList = house.houseExpensesList.reversed.toList();
    await setSharedPHouseList();
    update();
  }

  updateHouseExpense(String mark, FeeTypeCost expense, MyTimeM expenseDate, int expenseListIndex)async{
    var house = getHouse();
    HouseExpensesM houseExpense = HouseExpensesM()..initialize(mark, expense, expenseDate);
    house.houseExpensesList[expenseListIndex] = houseExpense;
    await setSharedPHouseList();
    update();
  }

  deleteHouseExpense(int expenseListIndex)async{
    var house = getHouse();
    house.houseExpensesList.removeAt(expenseListIndex);
    await setSharedPHouseList();
    update();
  }

  /// new version
  newUpdateFeeTypeList(List<String> feeTypeList)async{
    //print(feeTypeList);
    this.houseState.housesM.feeTypeList = feeTypeList;
    await setSharedPHouseList();
    update();
  }


  /// /////////////////////// functions
  RoomM getRoom(int index, int levelIndex){
    return getHouse().levelList[levelIndex].roomList[index];
  }

  HouseM getHouse(){
    return this.houseState.housesM.houseList[this.houseState.houseIndex];
  }

  setHouseIndex(int index){
    if(this.houseState.housesM.houseList.length != 0){
      this.houseState.houseIndex = index;
      //printInfo(info: "set house index: $index" );
      update();
    }
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

  setItemList(int houseIndex){
    if(this.houseState.housesM.houseList.length != 0){
      this.houseState.itemList =  List<Item>.generate(this.houseState.housesM.houseList[houseIndex].levelList.length, (int index) {
        return Item(
          houseLevel: this.houseState.housesM.houseList[houseIndex].levelList[index],
          levelIndex: index,
        );
      });
      //printInfo(info: "set setItemList");
      update();
    }

  }

  upDateItemIsExpanded(int index, bool isExpanded){
    this.houseState.itemList[index].isExpanded = !isExpanded;
    update();
  }

  /// /////////// line chart part
  /// for income line chart
  List<RentalFeeM> getLineChartAllRentalFeeData(int houseIndex){
    List<RentalFeeM> rentalFeeList = [];
    var houseList = houseState.housesM.houseList;
    for(var houseLevel in houseList[houseIndex].levelList){
      for(var roomM in houseLevel.roomList){
        for(var rentalFeeM in roomM.rentalFee){
          rentalFeeList.add(rentalFeeM);
        }
      }
    }
    return rentalFeeList;
  }

  /// for income line chart
  List<Map> getLineChartFeeDataMap(int houseIndex){
    List<Map> feeDataMapList = [];
    for(RentalFeeM rentalFeeM in getLineChartAllRentalFeeData(houseIndex)){
      Map feeDataMap = Map();
      List<Map> feeMList = [];
      feeDataMap['shouldPayTime'] = {'year': rentalFeeM.shouldPayTime.year, 'month': rentalFeeM.shouldPayTime.month};
      feeDataMap['payedTime'] = rentalFeeM.payedTime == null ? null : {'year':rentalFeeM.payedTime.year, 'month': rentalFeeM.payedTime.month};
      for(int i = 0 ; i < rentalFeeM.rentalFee.length; i++){
        FeeM feeM = rentalFeeM.rentalFee[i];
        feeMList.add({
          'type': feeM.feeTypeCost.type,
          'cost': feeM.feeTypeCost.cost,
          'amount': feeM.amount,
          'payedFee': feeM.payedFee,
        });
      }
      feeDataMap['feeM'] = feeMList;
      feeDataMapList.add(feeDataMap);
    }
    ///printInfo(info: feeDataMapList.toString());
    return feeDataMapList;
  }

  /// for cost line chart
  List<HouseExpensesM> getLineChartAllCostData(int houseIndex){
    List<HouseExpensesM> houseExpensesList = [];
    var houseList = houseState.housesM.houseList;
    houseExpensesList = houseList[houseIndex].houseExpensesList;
    return houseExpensesList;
  }

  /// ///////////// get all customers
   Future getHouseHolderList()async{
    change(houseState, status: RxStatus.loading());
    var houseList = houseState.housesM.houseList;
    List<Map> houseHolderList = [];
    ///await Future.delayed(Duration(seconds: 1));
    if(houseList.length > 0){
      for(int i = 0 ; i < houseList.length; i++){
        var levels = houseList[i].levelList;
        for(int j = 0; j<levels.length ; j++ ){
          var rooms = levels[j].roomList;
          for(int k = 0; k <rooms.length; k++){
            var houseHolders = rooms[k].householderList;
            for(int h = 0; h < houseHolders.length; h++){
              var houseHold = houseHolders[h];
              Map ho = {
                'house': i,
                'level': j,
                'room': k,
                'holders': h,
                'name':houseHold.name,
                'sex':houseHold.sex,
                'nation':houseHold.nation,
                'idNum':houseHold.idNum,
              };
              houseHolderList.add(ho);
            }
          }
        }
      }
    }
    this.houseState.houseHolderList = houseHolderList;
    this.houseState.houseHolderShowList = houseHolderList;
    change(houseState, status: RxStatus.success());
    update();
  }

  updateHouseHolderShowList(String query){
    change(houseState, status: RxStatus.loading());
    if(query != ''){
      this.houseState.houseHolderShowList = [];
      for(Map b in this.houseState.houseHolderList){
        if(b['name'].contains(query)){
          this.houseState.houseHolderShowList.add(b);
        }
      }
    }else{
      this.houseState.houseHolderShowList = this.houseState.houseHolderList;
    }
    change(houseState, status: RxStatus.success());
    update();
  }

  houseHolderListToNull(){
    this.houseState.houseHolderList = null;
    this.houseState.houseHolderShowList = null;
  }

  /// fix feeType
  Future<Map> getFixFeeType()async{
    Map fixFeeTypeMap = Map();
    List<FeeTypeCost> feeTypeCostListFromPayedH = [];
    List<FeeTypeCost> feeTypeCostListFromExpendH = [];
    List<FeeTypeCost> feeTypeCostListFromRoomM = [];

    ///List<HouseM> feeTypeCostListFromHouseM = [];


    for(HouseM houseM in this.houseState.housesM.houseList){
      for(HouseLevel houseLevel in houseM.levelList){
        for(RoomM roomM in houseLevel.roomList){
          /// fix rental fee payed history
          for(RentalFeeM rentalFeeM in roomM.rentalFee){
            for(var a in rentalFeeM.rentalFee){
              feeTypeCostListFromPayedH.add(a.feeTypeCost);
            }
          }
          /// fix rental fee model
          for(FeeTypeCost feeTypeCost in roomM.feeTypeCostList){
            feeTypeCostListFromRoomM.add(feeTypeCost);
          }
        }
      }
      /// fix houseExpensesM history
      for(HouseExpensesM houseExpensesM in houseM.houseExpensesList){
        feeTypeCostListFromExpendH.add(houseExpensesM.expense);
      }
      /// fix house model
      ///feeTypeCostListFromHouseM.add(houseM);
    }
    ///fixFeeTypeMap['houseM'] = feeTypeCostListFromHouseM;
    fixFeeTypeMap['roomM'] = feeTypeCostListFromRoomM;
    fixFeeTypeMap['roomH'] = feeTypeCostListFromPayedH;
    fixFeeTypeMap['expendH'] = feeTypeCostListFromExpendH;
    ///await Future.delayed(Duration(seconds: 1));
    return fixFeeTypeMap;
  }

}