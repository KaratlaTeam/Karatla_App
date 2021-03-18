
import 'package:hm/model/myTimeM.dart';
import 'package:hm/model/roomM.dart';


class FeeM{
  FeeM({
    this.payedFee,
    this.feeTypeCost,
    this.amount,
    this.usageStartNumber,
});
  double payedFee;
  FeeTypeCost feeTypeCost;
  int amount;
  double usageStartNumber;

  initialize(FeeTypeCost feeTypeCost, double payedFee, int amount, double usageStartNumber){
    this.feeTypeCost = feeTypeCost;
    this.usageStartNumber = usageStartNumber;
    amount == null ? this.amount = 1 : this.amount = amount;
    payedFee != null ? this.payedFee = payedFee : this.payedFee = 0;
  }

  factory FeeM.fromJson(Map<String, dynamic> json){
    return FeeM(
      payedFee: json['payedFee'],
      amount: json['amount'],
      feeTypeCost: json['feeTypeCost'] != null ? FeeTypeCost.fromJson(json['feeTypeCost']) : null,
      usageStartNumber: json['usageStartNumber'] ,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> fee = Map<String, dynamic>();
    fee["payedFee"] = this.payedFee;
    fee['amount'] = this.amount;
    fee['usageStartNumber'] = this.usageStartNumber;
    if (this.feeTypeCost != null) {
      fee['feeTypeCost'] = this.feeTypeCost.toJson();
    }
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

  initialize(MyTimeM shouldPayTime, [MyTimeM payedTime, List<FeeM> rentalFee, String mark]){
    this.shouldPayTime = shouldPayTime;
    payedTime != null ? this.payedTime = payedTime : this.payedTime = null;
    rentalFee != null ? this.rentalFee = rentalFee : this.rentalFee = [];
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
      rentalFee['shouldPayTime'] = this.shouldPayTime.toJson();
    }
    if (this.payedTime != null) {
      rentalFee['payedTime'] = this.payedTime.toJson();
    }
    return rentalFee;
  }

}


