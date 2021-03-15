
import 'package:hm/model/roomM.dart';


class HousesM{
  HousesM({
    this.houseList,
});
  List<HouseM> houseList ;

  initialize(){
    this.houseList = [];
  }

  factory HousesM.fromJson(Map<String, dynamic> json){
    return HousesM(
      houseList: json['houseList'] != null ? (json['houseList'] as List).map((i) => HouseM.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> houseMap = Map<String, dynamic>();

    if (this.houseList != null) {
      houseMap['houseList'] = this.houseList.map((v) => v.toJson()).toList();
    }
    return houseMap;
  }

}

class HouseM {
  HouseM({
    this.feeTypeList,
    this.mark,
    this.houseName,

    //this.roomList,
    this.levelList,
});
  String houseName ;
  String mark;
  List<String> feeTypeList;

  //List<RoomM> roomList ;
  List<HouseLevel> levelList;

  initialize(List<HouseLevel> levelList, String name, List<String> feeTypeList, [String mark]){
    this.houseName = name;
    this.feeTypeList = feeTypeList;
    mark != null ? this.mark = mark : this.mark = "";

    //this.roomList = roomList;
    this.levelList = levelList;
  }

  factory HouseM.fromJson(Map<String, dynamic> json){
    return HouseM(
      houseName: json['houseName'],
      mark: json['mark'],

      feeTypeList: json['feeTypeList'] != null ? new List<String>.from(json['feeTypeList']) : null,

      //roomList: json['roomList'] != null ? (json['roomList'] as List).map((i) => RoomM.fromJson(i)).toList() : null,
      levelList: json['levelList'] != null ? (json['levelList'] as List).map((i) => HouseLevel.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> house = Map<String, dynamic>();

    house["mark"] = this.mark;
    house["houseName"] = this.houseName;

    if (this.feeTypeList != null) {
      house['feeTypeList'] = this.feeTypeList;
    }

    //if (this.roomList != null) {
    //  house['roomList'] = this.roomList.map((v) => v.toJson()).toList();
    //}
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

