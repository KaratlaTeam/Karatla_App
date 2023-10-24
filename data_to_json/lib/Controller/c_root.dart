import 'dart:convert';
import 'dart:io';

import 'package:data_to_json/Model/m_building.dart';
import 'package:data_to_json/Model/m_dir.dart';
import 'package:data_to_json/Model/m_event.dart';
import 'package:data_to_json/Model/m_family.dart';
import 'package:data_to_json/Model/m_family_role.dart';
import 'package:data_to_json/Model/m_fang.dart';
import 'package:data_to_json/Model/m_people.dart';
import 'package:data_to_json/Model/m_profession.dart';
import 'package:data_to_json/Model/m_profession_type.dart';
import 'package:data_to_json/Model/m_prop.dart';
import 'package:data_to_json/Model/m_prop_type.dart';
import 'package:data_to_json/Plugin/p_string.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CRoot extends GetxController{

  var mDir = MDir.newOne().obs;

  var mFangList = MFangList.nowOne().obs;
  var mPropList = MPropList.newOne().obs;
  var mPropTypeList = MPropTypeList.newOne().obs;
  var mProfessionList = MProfessionList.newOne().obs;
  var mFamilyRoleList = MFamilyRoleList.newOne().obs;
  var mProfessionTypeList = MProfessionTypeList.newOne().obs;

  int get mFangIndex => mFangList.value.index;
  MFang? get mFang => mFangList.value.mFangList.isNotEmpty ? mFangList.value.mFangList[mFangIndex] : null;

  int get mPeopleIndex => mFang?.mPeopleList.index??0;
  MPeople? get mPeople => mFang?.mPeopleList.mPeopleList.isNotEmpty??false ? mFang?.mPeopleList.mPeopleList[mPeopleIndex] : null;

  int get mBuildingIndex => mFang?.buildings.index??0;
  MBuilding? get mBuilding => mFang?.buildings.mBuildingList.isNotEmpty??false ? mFang?.buildings.mBuildingList[mBuildingIndex] : null;

  int get mEventIndex => mFang?.events.index??0;
  MEvent? get mEvent => mFang?.events.mEventList.isNotEmpty??false ? mFang?.events.mEventList[mEventIndex] : null;

  int get mFamilyIndex => mFang?.families.index??0;
  MFamily? get mFamily => mFang?.families.mFamilyList.isNotEmpty??false ? mFang?.families.mFamilyList[mFamilyIndex] : null;

  int get mPropIndex => mPropList.value.index;
  MProp? get mProp => mPropList.value.mPropList.isNotEmpty? mPropList.value.mPropList[mPropIndex] : null;

  List get allPeople {
    List data = [];
    for(var a in mFangList.value.mFangList){
      data = data+a.mPeopleList.mPeopleList;
    }
    return data;
  }

  List get allEvent {
    List data = [];
    for(var a in mFangList.value.mFangList){
      data = data+a.events.mEventList;
    }
    return data;
  }

  List get allBuilding {
    List data = [];
    for(var a in mFangList.value.mFangList){
      data = data+a.buildings.mBuildingList;
    }
    return data;
  }

  List get allFamily {
    List data = [];
    for(var a in mFangList.value.mFangList){
      data = data+a.families.mFamilyList;
    }
    return data;
  }

  initAllData(){
    _initializeDir();

    _checkData(
      PS.mFangList,
      mFangList,
      nullAction: (){_initFangData();},
      tureAction: (afterDecode){
        mFangList.value = MFangList.fromJson(afterDecode);
      },
    );

    _checkData(
      PS.mProfessionTypeList,
      mProfessionTypeList,
      nullAction: (){_initMProfessionTypeData();},
      tureAction: (afterDecode){
        mProfessionTypeList.value = MProfessionTypeList.fromJson(afterDecode);
      },
    );

    _checkData(
      PS.mProfessionList,
      mProfessionList,
      nullAction: (){_initProfessionData();},
      tureAction: (afterDecode){
        mProfessionList.value = MProfessionList.fromJson(afterDecode);
      },
    );

    _checkData(
      PS.mFamilyRoleList,
      mFamilyRoleList,
      nullAction: (){_initFamilyRoleData();},
      tureAction: (afterDecode){
        mFamilyRoleList.value = MFamilyRoleList.fromJson(afterDecode);
      },
    );

    _checkData(
      PS.mPropTypeList,
      mPropTypeList,
      nullAction: (){_initPropTypeData();},
      tureAction: (afterDecode){
        mPropTypeList.value = MPropTypeList.fromJson(afterDecode);
      },
    );

    _checkData(
      PS.mPropList,
      mPropList,
      nullAction: (){_initPropData();},
      tureAction: (afterDecode){
        mPropList.value = MPropList.fromJson(afterDecode);
      },
    );
  }
  ///
  _initializeDir(){

    mDir.update((val) async{
      if(val != null){
        /// ios only supports save files in NSDocumentDirectory--getApplicationDocumentsDirectory

        val.tempDir = await getTemporaryDirectory();
        val.tempPath = val.tempDir.path;
        print('tempPath'+val.tempPath);

        val.appDocDir = GetPlatform.isAndroid
            ? await getExternalStorageDirectory()
            : await getApplicationDocumentsDirectory();
        val.appDocPath = val.appDocDir?.path;
        print('appDocPath'+val.appDocPath.toString());


        val.fileDir = await Directory(val.appDocPath!+'/File').create();
        val.filePath = val.fileDir.path;
        print(val.filePath);

        val.pictureDir = await Directory(val.filePath+'/Picture').create();
        val.picturePath = val.pictureDir.path;
        print(val.picturePath);
      }
    });


  }

  /// MFamily Function

  addFamily(MFamily mFamily){
    mFangList.update((val) {
      val?.mFangList[val.index].families.mFamilyList.insert(0, mFamily);
    });
    _saveData(PS.mFangList, mFangList);
  }

  removeFamily(MFamily mFamily){
    mFangList.update((val) {
      val?.mFangList[val.index].families.mFamilyList.remove(mFamily);
    });
    _saveData(PS.mFangList, mFangList);
  }

  updateFamily(MFamily mFamily){
    mFangList.update((val) {
      val?.mFangList[val.index].families.mFamilyList[mFamilyIndex] = mFamily;
    });
    _saveData(PS.mFangList, mFangList);
  }

  updateNowFamilyIndex(int index){
    mFangList.update((val) {
      val?.mFangList[mFangIndex].families.index = index;
    });
    _saveData(PS.mFangList, mFangList);
  }

  /// MProp Function

  _initPropData(){

  }

  addProp(MProp mProp){
    mPropList.update((val) {
      val?.mPropList.insert(0, mProp);
    });
    _saveData(PS.mPropList, mPropList);
  }

  removeProp(MProp mProp){
    deleteDir(mProp.uuid);
    mPropList.update((val) {
      val?.mPropList.remove(mProp);
    });
    _saveData(PS.mPropList, mPropList);
  }

  updateProp(MProp mProp){
    mPropList.update((val) {
      val?.mPropList[val.index] = mProp;
    });
    _saveData(PS.mPropList, mPropList);
  }

  updateNowPropIndex(int index){
    mPropList.update((val) {
      val?.index = index;
    });
    _saveData(PS.mPropList, mPropList);
  }

  /// MEvent Function

  addEvent(MEvent mEvent){
    mFangList.update((val) {
      val?.mFangList[val.index].events.mEventList.insert(0, mEvent);
    });
    _saveData(PS.mFangList, mFangList);
  }

  removeEvent(MEvent mEvent){
    mFangList.update((val) {
      val?.mFangList[val.index].events.mEventList.remove(mEvent);
    });
    _saveData(PS.mFangList, mFangList);
  }

  updateEvent(MEvent mEvent){
    mFangList.update((val) {
      val?.mFangList[val.index].events.mEventList[mEventIndex] = mEvent;
    });
    _saveData(PS.mFangList, mFangList);
  }

  updateNowEventIndex(int index){
    mFangList.update((val) {
      val?.mFangList[mFangIndex].events.index = index;
    });
    _saveData(PS.mFangList, mFangList);
  }

  /// MBuilding Function

  addBuilding(MBuilding mBuilding){
    mFangList.update((val) {
      val?.mFangList[val.index].buildings.mBuildingList.insert(0, mBuilding);
    });
    _saveData(PS.mFangList, mFangList);
  }

  removeBuilding(MBuilding mBuilding){
    mFangList.update((val) {
      val?.mFangList[val.index].buildings.mBuildingList.remove(mBuilding);
    });
    _saveData(PS.mFangList, mFangList);
  }

  updateBuilding(MBuilding mBuilding){
    mFangList.update((val) {
      val?.mFangList[val.index].buildings.mBuildingList[mBuildingIndex] = mBuilding;
    });
    _saveData(PS.mFangList, mFangList);
  }

  updateNowBuildingIndex(int index){
    mFangList.update((val) {
      val?.mFangList[mFangIndex].buildings.index = index;
    });
    _saveData(PS.mFangList, mFangList);
  }

  /// MPeople Function
  addPeople(MPeople mPeople){
    mFangList.update((val) {
      val?.mFangList[val.index].mPeopleList.mPeopleList.insert(0, mPeople);
    });
    _saveData(PS.mFangList, mFangList);
  }

  removePeople(MPeople mPeople){
    mFangList.update((val) {
      val?.mFangList[val.index].mPeopleList.mPeopleList.remove(mPeople);
    });
    _saveData(PS.mFangList, mFangList);
  }

  updatePeople(MPeople mPeople){
    mFangList.update((val) {
      val?.mFangList[val.index].mPeopleList.mPeopleList[mPeopleIndex] = mPeople;
    });
    _saveData(PS.mFangList, mFangList);
  }

  updateNowPeopleIndex(int index){
    mFangList.update((val) {
      val?.mFangList[mFangIndex].mPeopleList.index = index;
    });
    _saveData(PS.mFangList, mFangList);
  }


  /// MProfessionType FUNCTION
  _initMProfessionTypeData(){

  }

  addMProfessionType(MProfessionType mProfessionType){
    mProfessionTypeList.update((val) {
      if(val != null && checkNoRepeat(val.mProfessionTypeList, mProfessionType)){
        val.mProfessionTypeList.insert(0, mProfessionType);
      }
    });
    _saveData(PS.mProfessionTypeList, mProfessionTypeList);
  }

  removeMProfessionType(MProfessionType mProfessionType){
    mProfessionTypeList.update((val) {
      if(val != null){
        val.mProfessionTypeList.remove(mProfessionType);
      }
    });
    _saveData(PS.mProfessionTypeList, mProfessionTypeList);
  }

  /// mFamilyRoleList function
  _initFamilyRoleData(){

  }

  addMFamilyRol(MFamilyRole mFamilyRole){
    mFamilyRoleList.update((val) {
      if(val != null && checkNoRepeat(val.mFamilyRoleList, mFamilyRole)){
        val.mFamilyRoleList.insert(0, mFamilyRole);
      }
    });
    _saveData(PS.mFamilyRoleList, mFamilyRoleList);
  }

  removeMFamilyRol(MFamilyRole mFamilyRole){
    mFamilyRoleList.update((val) {
      if(val != null){
        val.mFamilyRoleList.remove(mFamilyRole);
      }
    });
    _saveData(PS.mFamilyRoleList, mFamilyRoleList);
  }


  /// Profession function
  _initProfessionData(){

  }

  addMProfession(MProfession mProfession){
    mProfessionList.update((val) {
      if(val != null && checkNoRepeat(val.mProfessionList, mProfession) ){
        val.mProfessionList.insert(0, mProfession);
      }
    });
    _saveData(PS.mProfessionList, mProfessionList);
  }

  removeMProfession(MProfession mProfession){
    mProfessionList.update((val) {
      if(val != null){
        val.mProfessionList.remove(mProfession);
      }
    });
    _saveData(PS.mProfessionList, mProfessionList);
  }

  List<MProfession> getMProfessionListByOneType(MProfessionType mProfessionType){
    List<MProfession> list = [];
    for(var a in mProfessionList.value.mProfessionList){
      if(a.type == mProfessionType){
        list.add(a);
      }
    }
    return list;
  }

  /// PropType function
  _initPropTypeData(){

  }

  addMPropType(MPropType mPropType){
    mPropTypeList.update((val) {
      if(val != null && checkNoRepeat(val.mPropTypeList, mPropType)){
        val.mPropTypeList.insert(0, mPropType);
      }
    });
    _saveData(PS.mPropTypeList, mPropTypeList);
  }

  removeMPropType(MPropType mPropType){
    mPropTypeList.update((val) {
      if(val != null){
        val.mPropTypeList.remove(mPropType);
      }
    });
    _saveData(PS.mPropTypeList, mPropTypeList);
  }



  /// Fang function

  _initFangData(){
    mFangList.update((val) {
      if(val != null){
        /// up
        for(var f in PS.areaUpL1Fang){
          var a = MFang.newOne()
            ..fangName = f
            ..fangArea = PS.areaUpL1;
          val.mFangList.add(a);
          printInfo(info: 'Create Fang $f - ${a.uuid}');
        }
        for(var f in PS.areaUpL2Fang){
          var a = MFang.newOne()
            ..fangName = f
            ..fangArea = PS.areaUpL2;
          val.mFangList.add(a);
          printInfo(info: 'Create Fang $f - ${a.uuid}');
        }
        for(var f in PS.areaUpR1Fang){
          var a = MFang.newOne()
            ..fangName = f
            ..fangArea = PS.areaUpR1;
          val.mFangList.add(a);
          printInfo(info: 'Create Fang $f - ${a.uuid}');
        }
        for(var f in PS.areaUpR2Fang){
          var a = MFang.newOne()
            ..fangName = f
            ..fangArea = PS.areaUpR2;
          val.mFangList.add(a);
          printInfo(info: 'Create Fang $f - ${a.uuid}');
        }
        /// down
        for(var f in PS.areaDownL1Fang){
          var a = MFang.newOne()
            ..fangName = f
            ..fangArea = PS.areaDownL1;
          val.mFangList.add(a);
          printInfo(info: 'Create Fang $f - ${a.uuid}');
        }
        for(var f in PS.areaDownL2Fang){
          var a = MFang.newOne()
            ..fangName = f
            ..fangArea = PS.areaDownL2;
          val.mFangList.add(a);
          printInfo(info: 'Create Fang $f - ${a.uuid}');
        }
        for(var f in PS.areaDownM1Fang){
          var a = MFang.newOne()
            ..fangName = f
            ..fangArea = PS.areaDownM1;
          val.mFangList.add(a);
          printInfo(info: 'Create Fang $f - ${a.uuid}');
        }
        for(var f in PS.areaDownR1Fang){
          var a = MFang.newOne()
            ..fangName = f
            ..fangArea = PS.areaDownR1;
          val.mFangList.add(a);
          printInfo(info: 'Create Fang $f - ${a.uuid}');
        }
        for(var f in PS.areaDownR2Fang){
          var a = MFang.newOne()
            ..fangName = f
            ..fangArea = PS.areaDownR2;
          val.mFangList.add(a);
          printInfo(info: 'Create Fang $f - ${a.uuid}');
        }
        for(var f in PS.areaUpM1Fang){
          var a = MFang.newOne()
            ..fangName = f
            ..fangArea = PS.areaUpM1;
          val.mFangList.add(a);
          printInfo(info: 'Create Fang $f - ${a.uuid}');
        }
        for(var f in PS.areaDownL1L2MFang){
          var a = MFang.newOne()
            ..fangName = f
            ..fangArea = PS.areaDownL1L2M;
          val.mFangList.add(a);
          printInfo(info: 'Create Fang $f - ${a.uuid}');
        }
      }

    });
  }

  bool updateNowFangIndex(MFang mFang){
    for(var a in mFangList.value.mFangList){
      if(a.fangName == mFang.fangName){
        mFangList.update((val) {
          val?.index = mFangList.value.mFangList.indexOf(a);
        });
        _saveData(PS.mFangList, mFangList);
        return true;
      }
    }
    return false;
  }


/// comment
  _checkData(String dataName, var data, {required Function nullAction, required Function(dynamic) tureAction})async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sharedData = prefs.getString(dataName);
    if(sharedData == null){
      nullAction();
      String afterEncode = jsonEncode(data.value.toJson());
      prefs.setString(dataName, afterEncode);
    }else{
      var afterDecode = jsonDecode(sharedData);
      tureAction(afterDecode);
    }
  }

  _saveData(String dataName,var data, )async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String afterEncode = jsonEncode(data.value.toJson());
    prefs.setString(dataName, afterEncode);
  }

  _getData(String dataName,var data, {required Function(dynamic) tureAction})async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? sharedData = prefs.getString(dataName);
    var afterDecode = jsonDecode(sharedData!);
    tureAction(afterDecode);
  }

  bool checkNoRepeat(List dataList, var data){
    for(var a in dataList){
      if(a == data){
        return false;
      }
    }
    return true;
  }

  Object getByName(String name, List values){
    for(var a in values){
      if(a.toString() == name){
        return a;
      }
    }
    return '';
  }

  Object getByUuid(String uuid, List values){
    for(var a in values){
      if(a.uuid == uuid){
        return a;
      }
    }
    return '';
  }

  pickImage(Function(String) action)async{
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if(image!=null){
      action(image.path);
    }else{
      return '';
    }
  }

  Future<List<String>> saveImage(List<String> paths, var oldPaths, String uuid)async{
    printInfo(info: 'Save image to $uuid');
    Directory pictureDir = await Directory(mDir.value.picturePath+'/$uuid').create();
    List<String> newList = [];

    for(var a in oldPaths ){
      if(paths.isNotEmpty&&paths.contains(a)){
        newList.add(a);
      }else{
        File file = File(a);
        file.deleteSync();
      }
    }
    for(int i = 0; i < paths.length; i++ ){
      if(!paths[i].contains(uuid)){
        String newPath = '${pictureDir.path}/${DateTime.now().toString()}${mDir.value.getFileTypeName(paths[i])}';
        File file = File(paths[i]);
        file.copySync(newPath);
        newList.add(newPath);
      }
    }
    return newList;
  }

  deleteDir(String uuid)async{
    Directory pictureDir = Directory(mDir.value.picturePath+'/$uuid');
    if(pictureDir.existsSync()){
      await pictureDir.delete(recursive: true);
    }
  }

  @override
  void onInit() {
    printInfo(info: 'CRoot onInit');
    initAllData();
    super.onInit();
  }
  @override
  void onReady() {
    printInfo(info: 'CRoot onReady');
    Get.offNamed(PS.home);
    super.onReady();
  }
  @override
  void onClose() {
    printInfo(info: 'CRoot onClose');
    mFangList.value.mFangList = [];
    mPropList.value.mPropList = [];
    mProfessionList.value.mProfessionList = [];
    mFamilyRoleList.value.mFamilyRoleList = [];
    mProfessionTypeList.value.mProfessionTypeList = [];
    super.onClose();
  }


}