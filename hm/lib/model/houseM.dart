
import 'package:hm/model/houseExpensesM.dart';
import 'package:hm/model/roomM.dart';


class HousesM{
  HousesM({
    this.houseList,

    /// new version
    this.feeTypeList,
});
  List<HouseM> houseList ;

  /// new version
  List<String> feeTypeList;

  initialize(){
    this.houseList = [];

    /// new version
    this.feeTypeList = [];
  }

  factory HousesM.fromJson(Map<String, dynamic> json){
    return HousesM(
      houseList: json['houseList'] != null ? (json['houseList'] as List).map((i) => HouseM.fromJson(i)).toList() : null,

      /// new version
      feeTypeList: json['feeTypeList'] != null ? new List<String>.from(json['feeTypeList']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> houseMap = Map<String, dynamic>();

    if (this.houseList != null) {
      houseMap['houseList'] = this.houseList.map((v) => v.toJson()).toList();
    }

    /// new version
    if (this.feeTypeList != null) {
      houseMap['feeTypeList'] = this.feeTypeList;
    }
    return houseMap;
  }

}

class HouseM {
  HouseM({
    this.feeTypeList,
    this.mark,
    this.houseName,

    this.houseExpensesList,
    this.levelList,

    /// new version
    this.photoPath,
});
  String houseName ;
  String mark;
  List<String> feeTypeList;

  List<HouseExpensesM> houseExpensesList ;
  List<HouseLevel> levelList;

  /// new version
  String photoPath;

  initialize(List<HouseLevel> levelList, String name, List<String> feeTypeList, String photoPath, [String mark]){
    this.houseName = name;
    this.feeTypeList = feeTypeList;
    mark != null ? this.mark = mark : this.mark = "";

    this.houseExpensesList = [];
    this.levelList = levelList;

    /// new version
    this.photoPath = photoPath;
  }

  factory HouseM.fromJson(Map<String, dynamic> json){
    return HouseM(
      /// new version
      photoPath: json['photoPath'],

      houseName: json['houseName'],
      mark: json['mark'],

      feeTypeList: json['feeTypeList'] != null ? new List<String>.from(json['feeTypeList']) : [],

      houseExpensesList: json['houseExpensesList'] != null ? (json['houseExpensesList'] as List).map((i) => HouseExpensesM.fromJson(i)).toList() : [],
      levelList: json['levelList'] != null ? (json['levelList'] as List).map((i) => HouseLevel.fromJson(i)).toList() : [],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> house = Map<String, dynamic>();

    /// new version
    house["photoPath"] = this.photoPath;

    house["mark"] = this.mark;
    house["houseName"] = this.houseName;

    if (this.feeTypeList != null) {
      house['feeTypeList'] = this.feeTypeList;
    }

    if (this.houseExpensesList != null) {
      house['houseExpensesList'] = this.houseExpensesList.map((v) => v.toJson()).toList();
    }
    if (this.levelList != null) {
      house['levelList'] = this.levelList.map((v) => v.toJson()).toList();
    }

    return house;
  }

}

class HouseLevel {
  HouseLevel({
    this.roomList,
    this.name,
});

  List<RoomM> roomList ;
  String name;

  initialize( List<RoomM> roomList, String name){
    this.name = name;
    this.roomList = roomList;
  }

  factory HouseLevel.fromJson(Map<String, dynamic> json){
    return HouseLevel(
      name: json['name'],
      roomList: json['roomList'] != null ? (json['roomList'] as List).map((i) => RoomM.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> houseLevel = Map<String, dynamic>();

    if (this.roomList != null) {
      houseLevel['roomList'] = this.roomList.map((v) => v.toJson()).toList();
    }
    houseLevel['name'] = this.name;

    return houseLevel;
  }

}

