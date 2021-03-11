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
});
  String name, sex, nation, birth, address, idNum, mark;
  MyTimeM checkInDate;
  MyTimeM checkOutDate;

  initialize(MyTimeM checkInDate,  String name, String idNum, String sex, [ MyTimeM checkOutDate, String nation, String birth, String address, String mark]){
    this.name = name;
    this.sex = sex ;
    this.idNum = idNum;
    this.checkInDate = checkInDate;
    this.checkOutDate = checkOutDate;
    nation != null ? this.nation = nation : this.nation = "";
    birth != null ? this.birth = birth : this.birth = "";
    address != null ? this.address = address : this.address = "";
    mark != null ? this.mark = mark : this.mark = "";
  }

  factory HouseholderM.fromJson(Map<String, dynamic> json){
    return HouseholderM(
      checkInDate: json['checkInDate'] != null ? MyTimeM.fromJson(json['checkInDate']) : null,
      checkOutDate: json['checkOutDate'] != null ? MyTimeM.fromJson(json['checkOutDate']) : null,
      sex: json['sex'],
      mark: json['mark'],
      idNum: json['idNum'],
      address: json['address'],
      birth: json['birth'],
      nation: json['nation'],
      name: json['name'],
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
    householder["sex"] = this.sex;
    householder["mark"] = this.mark;
    householder["idNum"] = this.idNum;
    householder["address"] = this.address;
    householder["birth"] = this.birth;
    householder["nation"] = this.nation;
    householder["name"] = this.name;
    return householder;
  }

}
