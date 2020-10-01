import 'package:kpp01/typedef.dart';

abstract class LoginEvent{

}

class LoginEventSignIn extends LoginEvent{
  LoginEventSignIn({this.loginAccount,this.password,this.loginType,this.myDeviceIdNow});
  final String loginAccount;
  final String password;
  final String loginType;
  final String myDeviceIdNow;
}

class LoginEventSignInChangeToSuccessful extends LoginEvent{}


class LoginEventSignOut extends LoginEvent{}