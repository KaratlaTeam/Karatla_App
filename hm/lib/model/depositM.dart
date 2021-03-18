import 'package:hm/model/myTimeM.dart';

class DepositM{
  DepositM({
    this.mark,
    this.amount,
    this.refundTime,
    this.payedTime,
});

  String mark;
  double amount;
  MyTimeM payedTime;
  MyTimeM refundTime;

  initialize(String mark, double amount, MyTimeM payedTime, MyTimeM refundTime){
    this.mark = mark;
    this.amount = amount;
    this.payedTime = payedTime;
    this.refundTime = refundTime;
  }

  factory DepositM.fromJson(Map<String, dynamic> json){
    return DepositM(
      amount: json['amount'] ,
      mark: json['mark'],
      payedTime: json['payedTime'] != null ? MyTimeM.fromJson(json['payedTime']) : null,
      refundTime: json['refundTime'] != null ? MyTimeM.fromJson(json['refundTime']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> depositM = Map<String, dynamic>();
    depositM["amount"] = this.amount;
    depositM["mark"] = this.mark;
    if (this.refundTime != null) {
      depositM['refundTime'] = this.refundTime.toJson();
    }
    if (this.payedTime != null) {
      depositM['payedTime'] = this.payedTime.toJson();
    }
    return depositM;
  }

}