
import 'package:hm/model/myTimeM.dart';


class FeeM{
  FeeM({
    this.feeType,
    this.mark,
    this.payedFee,
    this.shouldPayFee,
});
  String mark;
  int shouldPayFee;
  int payedFee;
  String feeType;

  initialize(int shouldPayFee, String feeType, [String mark, int payedFee]){
    this.shouldPayFee = shouldPayFee;
    this.feeType = feeType;
    payedFee != null ? this.payedFee = payedFee : this.payedFee = 0;
    mark != null ? this.mark = mark : this.mark = "";
  }

  factory FeeM.fromJson(Map<String, dynamic> json){
    return FeeM(
      feeType: json['feeType'],
      mark: json['mark'],
      payedFee: json['payedFee'],
      shouldPayFee: json['shouldPayFee'],

    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> fee = Map<String, dynamic>();
    fee["feeType"] = this.feeType;
    fee["mark"] = this.mark;
    fee["payedFee"] = this.payedFee;
    fee["shouldPayFee"] = this.shouldPayFee;
    return fee;
  }
}

class RentalFeeM{
  RentalFeeM({
    this.mark,
    this.rentalFee,
    this.shouldPayTime,
    this.payedTime,
});
  List<FeeM> rentalFee ;

  MyTimeM shouldPayTime;
  MyTimeM payedTime;

  String mark;

  initialize(List<FeeM> rentalFee,  MyTimeM shouldPayTime, [MyTimeM payedTime, String mark]){
    this.rentalFee = rentalFee;
    this.shouldPayTime = shouldPayTime;
    payedTime != null ? this.payedTime = payedTime : this.payedTime = null;
    mark != null ? this.mark = mark : this.mark = "";
  }

  factory RentalFeeM.fromJson(Map<String, dynamic> json){
    return RentalFeeM(
      rentalFee: json['rentalFee'] != null ? (json['rentalFee'] as List).map((i) => FeeM.fromJson(i)).toList() : null,
      mark: json['mark'],
      shouldPayTime: json['shouldPayTime'] != null ? MyTimeM.fromJson(json['shouldPayTime']) : null,
      payedTime: json['payedTime'] != null ? MyTimeM.fromJson(json['payedTime']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rentalFee = Map<String, dynamic>();
    if (this.rentalFee != null) {
      rentalFee['rentalFee'] = this.rentalFee.map((v) => v.toJson()).toList();
    }
    rentalFee["mark"] = this.mark;
    if (this.shouldPayTime != null) {
      rentalFee['shouldPayTime'] = this.payedTime.toJson();
    }
    if (this.payedTime != null) {
      rentalFee['payedTime'] = this.payedTime.toJson();
    }
    return rentalFee;
  }

}


