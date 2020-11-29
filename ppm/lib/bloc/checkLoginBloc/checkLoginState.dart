import 'package:flutter/cupertino.dart';

abstract class CheckLoginState{
  const CheckLoginState();
}

class CheckLoginStateGood extends CheckLoginState{

}

class CheckLoginStateBad extends CheckLoginState{

}

class CheckLoginStateReadyToBad extends CheckLoginState{

}


class CheckLoginStateError extends CheckLoginState{
  final e;
  const CheckLoginStateError({@required this.e});
  backError(){
    return print("CheckLoginStateError: \n"+e.toString());
  }
}