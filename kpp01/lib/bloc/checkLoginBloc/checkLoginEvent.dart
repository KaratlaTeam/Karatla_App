import 'package:flutter/cupertino.dart';

abstract class CheckLoginEvent {
  const CheckLoginEvent();
}

class CheckLoginEventCheck extends CheckLoginEvent{
  const CheckLoginEventCheck(this.context);
  final BuildContext context;
}

class CheckLoginEventChangeToBad extends CheckLoginEvent{
  const CheckLoginEventChangeToBad();
}

class CheckLoginEventChangeToGood extends CheckLoginEvent{
  const CheckLoginEventChangeToGood();
}
