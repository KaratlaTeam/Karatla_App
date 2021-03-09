
import 'package:hm/enumData.dart';
import 'package:hm/model/householderM.dart';
import 'package:hm/model/myTimeM.dart';
import 'package:hm/model/rentalFeeM.dart';
import 'package:hm/state/roomS.dart';


class CheckTimeM{
  CheckTimeM({
   this.checkTime,
   this.checkState,
    this.mark,
});
  RoomState checkState;
  MyTimeM checkTime;
  String mark;

  initialize(RoomState checkState, MyTimeM checkTime,[String mark]){
    this.checkState = checkState;
    this.checkTime = checkTime;
    mark != null ? this.mark = mark : this.mark = "";
  }

  factory CheckTimeM.fromJson(Map<String, dynamic> json){
    return CheckTimeM(
      checkTime: json['checkTime'] != null ? MyTimeM.fromJson(json['checkTime']) : null,
      checkState:  json['checkState'] != null ? RoomState.values.firstWhere((element) => element.toString() == json['checkState']) : RoomState.ERROR,
      mark: json['mark'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> checkTime = Map<String, dynamic>();
    if (this.checkTime != null) {
      checkTime['checkTime'] = this.checkTime.toJson();
    }
    checkTime["checkState"] = this.checkState.toString();
    checkTime["mark"] = this.mark;
    return checkTime;
  }
}

class FeeTypeCost{
  FeeTypeCost({
    this.cost,
    this.type,
});
  String type;
  double cost;

  initialize(String type, double cost, ){
    this.type = type;
    this.cost = cost;
    
  }

  factory FeeTypeCost.fromJson(Map<String, dynamic> json){
    return FeeTypeCost(
      type: json['type'],
      cost: json['cost'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> feeTypeCost = Map<String, dynamic>();
    feeTypeCost["type"] = this.type;
    feeTypeCost["cost"] = this.cost;
    return feeTypeCost;
  }
}

class RoomM {
  RoomM({
    this.checkTime,
    this.mark,
    this.rentalFee,
    this.householderList,
    this.roomState,
    this.roomNumber,
    this.roomLevel,
    this.feeTypeCostList,
});
  int roomLevel;
  int roomNumber;
  RoomState roomState;
  String mark;

  List<FeeTypeCost> feeTypeCostList;
  List<HouseholderM> householderList ;
  List<RentalFeeM> rentalFee;
  List<CheckTimeM> checkTime;

  initialize(
      int roomLevel,
      int roomNumber,
      List<FeeTypeCost> feeTypeCostList,
      [List<HouseholderM> householderList,String mark]
      ){
    this.roomLevel = roomLevel;
    this.roomNumber = roomNumber;
    this.roomState = RoomState.OFF;
    this.feeTypeCostList = feeTypeCostList;
    this.householderList = [];
    this.rentalFee = [];
    this.checkTime = [];
    mark != null ? this.mark = mark : this.mark = "";
  }

  factory RoomM.fromJson(Map<String, dynamic> json){
    return RoomM(
      feeTypeCostList: json['feeTypeCostList'] != null ? (json['feeTypeCostList'] as List).map((i) => FeeTypeCost.fromJson(i)).toList() : null,
      mark: json['mark'],
      roomLevel: json['roomLevel'],
      roomNumber: json['roomNumber'],
      roomState: json['roomState'] != null ? RoomState.values.firstWhere((element) => element.toString() == json['roomState']) : RoomState.ERROR,
      householderList: json['householderList'] != null ? (json['householderList'] as List).map((i) => HouseholderM.fromJson(i)).toList() : null,
      checkTime: json['checkTime'] != null ? (json['checkTime'] as List).map((i) => CheckTimeM.fromJson(i)).toList() : null,
      rentalFee: json['rentalFee'] != null ? (json['rentalFee'] as List).map((i) => RentalFeeM.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> room = Map<String, dynamic>();

    room["mark"] = this.mark;
    room["roomLevel"] = this.roomLevel;
    room["roomNumber"] = this.roomNumber;
    room["roomState"] = this.roomState.toString();
    if (this.feeTypeCostList != null) {
      room['feeTypeCostList'] = this.feeTypeCostList.map((v) => v.toJson()).toList();
    }
    if (this.householderList != null) {
      room['householderList'] = this.householderList.map((v) => v.toJson()).toList();
    }
    if (this.checkTime != null) {
      room['checkTime'] = this.checkTime.map((v) => v.toJson()).toList();
    }
    if (this.rentalFee != null) {
      room['rentalFee'] = this.rentalFee.map((v) => v.toJson()).toList();
    }

    return room;
  }

}
