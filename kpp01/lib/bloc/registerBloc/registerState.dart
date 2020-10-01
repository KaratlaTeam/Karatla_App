
import 'package:flutter/cupertino.dart';

abstract class RegisterState{}

class RegisterStateRegisterStart extends RegisterState{}

class RegisterStateRegisterSuccessful extends RegisterState{}

class RegisterStateRegisterFail extends RegisterState{
  RegisterStateRegisterFail({this.text});
  final String text;
}

class RegisterStateRegisterFinished extends RegisterState{}

class RegisterStateError extends RegisterState{
  RegisterStateError({@required this.e});
  final e;
  backError(){
    return print("RegisterStateError: \n"+e.toString());
  }
}