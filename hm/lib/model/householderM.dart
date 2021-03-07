class HouseholderM{
  HouseholderM({
    this.mark,
    this.sex,
    this.idNum,
    this.address,
    this.birth,
    this.nation,
    this.name,
});
  String name, sex, nation, birth, address, idNum, mark;

  initialize(String name, [String sex, String nation, String birth, String address, String idNum, String mark]){
    this.name = name;
    sex != null ? this.sex = sex : this.sex = "";
    nation != null ? this.nation = nation : this.nation = "";
    birth != null ? this.birth = birth : this.birth = "";
    address != null ? this.address = address : this.address = "";
    idNum != null ? this.idNum = idNum : this.idNum = "";
    mark != null ? this.mark = mark : this.mark = "";
  }

  factory HouseholderM.fromJson(Map<String, dynamic> json){
    return HouseholderM(
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