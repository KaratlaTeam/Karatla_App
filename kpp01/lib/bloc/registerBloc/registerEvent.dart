import 'package:flutter/cupertino.dart';

abstract class RegisterEvent{}

class RegisterEventAccountRegister extends RegisterEvent{
  RegisterEventAccountRegister({
    @required this.userName,
    @required this.phone,
    @required this.passWord,
    @required this.confirmPassWord,
    @required this.context,
});
  final String userName;
  final String phone;
  final String passWord;
  final String confirmPassWord;
  final BuildContext context;
}

class RegisterEventCodeRegister extends RegisterEvent{
  RegisterEventCodeRegister({
    @required this.phone,
    @required this.code,
    @required this.context,
  });
  final String phone;
  final String code;
  final BuildContext context;
}

class RegisterEventCodeCanRegister extends RegisterEvent{

}

class RegisterEventAccountCanRegister extends RegisterEvent{

}