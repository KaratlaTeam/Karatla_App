import 'package:flutter/cupertino.dart';

abstract class LoginState{}

class LoginStateSignProcess extends LoginState{}

class LoginStateSignSuccessful extends LoginState{}


class LoginStateSignFail extends LoginState{
  LoginStateSignFail({this.text});
  String text;
}

class LoginStateSignOutProcess extends LoginState{}

class LoginStateSignOutFinished extends LoginState{}

class LoginStateSignError extends LoginState{
  LoginStateSignError({@required this.e});
  final e;
  backError(){
    return print("LoginStateError: \n"+e.toString());
  }
}

class LoginStateSignOutError extends LoginState{
  LoginStateSignOutError({@required this.e});
  final e;
  backError(){
    return print("LoginStateSignOutError: \n"+e.toString());
  }
}