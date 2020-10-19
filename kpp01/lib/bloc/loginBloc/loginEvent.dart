import 'package:flutter/cupertino.dart';
import 'package:kpp01/typedef.dart';

abstract class LoginEvent{

}

class LoginEventSignIn extends LoginEvent{
  LoginEventSignIn({this.loginAccount,this.password,this.loginType,this.myDeviceIdNow, this.context});
  final String loginAccount;
  final String password;
  final String loginType;
  final String myDeviceIdNow;
  final BuildContext context;
}

class LoginEventSignInCanSignIn extends LoginEvent{

}

class LoginEventSignInChangeToSuccessful extends LoginEvent{}


class LoginEventSignOut extends LoginEvent{}