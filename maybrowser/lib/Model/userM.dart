
import 'package:flutter/foundation.dart';

class UserM {
  UserM({
    required this.password,
    required this.account,
    required this.state,
});
  String account;
  String password;
  String state;

  factory UserM.fromJson(Map<String, dynamic> json){
    return UserM(
        password: json['password'],
        account: json['account'],
        state: json['state'],
    );
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> userM = Map<String, dynamic>();

    userM['account'] = this.account;
    userM['password'] = this.password;
    userM['state'] = this.state;

    return userM;
  }
}