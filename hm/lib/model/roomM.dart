
import 'package:hm/model/householderM.dart';
import 'package:hm/model/myTimeM.dart';
import 'package:hm/model/rentalFeeM.dart';

enum RoomState{IN,OUT,OFF}

class CheckTimeM{
  CheckTimeM({
   this.checkTime,
   this.checkState,
});
  RoomState checkState;
  MyTimeM checkTime;

  initialize(RoomState checkState, MyTimeM checkTime){
    this.checkState = checkState;
    this.checkTime = checkTime;
  }

  factory CheckTimeM.fromJson(Map<String, dynamic> json){
    return CheckTimeM(
      checkTime: json['checkTime'] != null ? MyTimeM.fromJson(json['checkTime']) : null,
      checkState: json['checkState'],

    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> checkTime = Map<String, dynamic>();
    if (this.checkTime != null) {
      checkTime['checkTime'] = this.checkTime.toJson();
    }
    checkTime["checkState"] = this.checkState;

    return checkTime;
  }
}

class RoomM {
  RoomM({
    this.checkTime,
    this.mark,
    this.rentalFee,
    this.householderList,
    this.feeTypeList,
    this.roomState,
    this.roomNumber,
    this.roomLevel,
    this.id,
});
  int id;
  int roomLevel;
  int roomNumber;
  RoomState roomState;
  String mark;
  List<String> feeTypeList;

  List<HouseholderM> householderList ;
  List<RentalFeeM> rentalFee;
  List<CheckTimeM> checkTime;

  initialize(
      int id,
      int roomLevel,
      int roomNumber,
      List<String> feeTypeList,
      List<HouseholderM> householderList,
      [String mark]
      ){
    this.id = id;
    this.roomLevel = roomLevel;
    this.roomNumber = roomNumber;
    this.roomState = RoomState.OFF;
    this.feeTypeList = feeTypeList;
    this.householderList = List<HouseholderM>();
    this.rentalFee = List<RentalFeeM>();
    this.checkTime = List<CheckTimeM>();
    mark != null ? this.mark = mark : this.mark = "";
  }

  factory RoomM.fromJson(Map<String, dynamic> json){
    return RoomM(
      mark: json['mark'],
      id: json['id'],
      roomLevel: json['roomLevel'],
      roomNumber: json['roomNumber'],
      roomState: json['roomState'],

      feeTypeList: json['feeTypeList'] != null ? new List<String>.from(json['feeTypeList']) : null,

      householderList: json['householderList'] != null ? (json['householderList'] as List).map((i) => HouseholderM.fromJson(i)).toList() : null,
      checkTime: json['checkTime'] != null ? (json['checkTime'] as List).map((i) => CheckTimeM.fromJson(i)).toList() : null,
      rentalFee: json['rentalFee'] != null ? (json['rentalFee'] as List).map((i) => RentalFeeM.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> room = Map<String, dynamic>();

    room["mark"] = this.mark;
    room["id"] = this.id;
    room["roomLevel"] = this.roomLevel;
    room["roomNumber"] = this.roomNumber;
    room["roomState"] = this.roomState;

    if (this.feeTypeList != null) {
      room['feeTypeList'] = this.feeTypeList;
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
