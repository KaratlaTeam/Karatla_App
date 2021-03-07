
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
    this.roomList,
    this.houseName,
});
  String houseName ;
  String mark;
  List<String> feeTypeList;
  List<RoomM> roomList ;

  initialize(String name, List<String> feeTypeList, [String mark]){
    this.houseName = name;
    this.feeTypeList = feeTypeList;
    mark != null ? this.mark = mark : this.mark = "";
    this.roomList = List<RoomM>();
  }

  factory HouseM.fromJson(Map<String, dynamic> json){
    return HouseM(
      houseName: json['houseName'],
      mark: json['mark'],

      feeTypeList: json['feeTypeList'] != null ? new List<String>.from(json['feeTypeList']) : null,

      roomList: json['roomList'] != null ? (json['roomList'] as List).map((i) => RoomM.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> house = Map<String, dynamic>();

    house["mark"] = this.mark;
    house["houseName"] = this.houseName;

    if (this.feeTypeList != null) {
      house['feeTypeList'] = this.feeTypeList;
    }

    if (this.roomList != null) {
      house['roomList'] = this.roomList.map((v) => v.toJson()).toList();
    }

    return house;
  }

}

