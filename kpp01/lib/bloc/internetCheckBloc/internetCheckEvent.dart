import 'package:flutter/cupertino.dart';

abstract class InternetCheckEvent{}

class InternetCheckEventCheck extends InternetCheckEvent{
  InternetCheckEventCheck({this.context});
  final BuildContext context;
}

class InternetCheckEventToGod extends InternetCheckEvent{}

class InternetCheckEventToNoAction extends InternetCheckEvent{}