import 'package:hm/model/myTimeM.dart';

class HouseholderM{
  HouseholderM({
    this.mark,
    this.sex,
    this.idNum,
    this.address,
    this.birth,
    this.nation,
    this.name,
    this.checkOutDate,
    this.checkInDate,
    this.photoPath,
    this.level,
    this.number,
    this.temporaryIdPhotoPath,
    this.temporaryIdStart,
    this.temporaryIdEnd,
    this.phoneNumber,
});
  String name, sex, nation, birth, address, idNum, mark, photoPath, temporaryIdPhotoPath, phoneNumber;
  int level, number;
  MyTimeM checkInDate;
  MyTimeM checkOutDate;

  MyTimeM temporaryIdStart;
  MyTimeM temporaryIdEnd;


  initialize(
      MyTimeM checkInDate,
      MyTimeM temporaryIdStart,
      MyTimeM temporaryIdEnd,
      String name,
      String idNum,
      String sex,
      int level,
      int number,
      [ MyTimeM checkOutDate,
        String nation,
        String birth,
        String address,
        String mark,
        String photoPath,
        String temporaryIdPhotoPath,
        String phoneNumber,
      ]
      ){
    this.name = name;
    this.sex = sex ;
    this.idNum = idNum;
    this.checkInDate = checkInDate;
    this.checkOutDate = checkOutDate;
    this.temporaryIdStart = temporaryIdStart;
    this.temporaryIdEnd = temporaryIdEnd;
    this.photoPath = photoPath;
    this.level = level;
    this.number = number;
    this.temporaryIdPhotoPath = temporaryIdPhotoPath;
    nation != null ? this.nation = nation : this.nation = "";
    birth != null ? this.birth = birth : this.birth = "";
    address != null ? this.address = address : this.address = "";
    mark != null ? this.mark = mark : this.mark = "";
    phoneNumber != null ? this.phoneNumber = phoneNumber : this.phoneNumber = "";
  }

  factory HouseholderM.fromJson(Map<String, dynamic> json){
    return HouseholderM(
      checkInDate: json['checkInDate'] != null ? MyTimeM.fromJson(json['checkInDate']) : null,
      checkOutDate: json['checkOutDate'] != null ? MyTimeM.fromJson(json['checkOutDate']) : null,
      temporaryIdStart: json['temporaryIdStart'] != null ? MyTimeM.fromJson(json['temporaryIdStart']) : null,
      temporaryIdEnd: json['temporaryIdEnd'] != null ? MyTimeM.fromJson(json['temporaryIdEnd']) : null,
      sex: json['sex'],
      mark: json['mark'],
      idNum: json['idNum'],
      address: json['address'],
      birth: json['birth'],
      nation: json['nation'],
      name: json['name'],
      photoPath: json['photoPath'],
      temporaryIdPhotoPath: json['temporaryIdPhotoPath'],
      level: json['level'],
      number: json['number'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> householder = Map<String, dynamic>();
    if (this.checkInDate != null) {
      householder['checkInDate'] = this.checkInDate.toJson();
    }
    if (this.checkOutDate != null) {
      householder['checkOutDate'] = this.checkOutDate.toJson();
    }
    if (this.temporaryIdStart != null) {
      householder['temporaryIdStart'] = this.temporaryIdStart.toJson();
    }
    if (this.temporaryIdEnd != null) {
      householder['temporaryIdEnd'] = this.temporaryIdEnd.toJson();
    }
    householder["sex"] = this.sex;
    householder["mark"] = this.mark;
    householder["idNum"] = this.idNum;
    householder["address"] = this.address;
    householder["birth"] = this.birth;
    householder["nation"] = this.nation;
    householder["name"] = this.name;
    householder['photoPath'] = this.photoPath;
    householder['temporaryIdPhotoPath'] = this.temporaryIdPhotoPath;
    householder['level'] = this.level;
    householder['number'] = this.number;
    householder['phoneNumber'] = this.phoneNumber;
    return householder;
  }

}
