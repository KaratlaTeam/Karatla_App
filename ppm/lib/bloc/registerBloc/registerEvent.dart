import 'package:flutter/cupertino.dart';

abstract class RegisterEvent{}

class RegisterEventAccountRegister extends RegisterEvent{
  RegisterEventAccountRegister({
    @required this.userName,
    @required this.phone,
    @required this.passWord,
    @required this.confirmPassWord,
});
  final String userName;
  final String phone;
  final String passWord;
  final String confirmPassWord;
}

class RegisterEventCodeRegister extends RegisterEvent{
  RegisterEventCodeRegister({
    @required this.phone,
    @required this.code,
  });
  final String phone;
  final String code;
}

class RegisterEventCodeCanRegister extends RegisterEvent{

}

class RegisterEventAccountCanRegister extends RegisterEvent{

}