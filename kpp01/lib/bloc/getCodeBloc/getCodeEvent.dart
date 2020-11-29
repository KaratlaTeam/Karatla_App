import 'package:flutter/cupertino.dart';

abstract class GetCodeEvent{
  const GetCodeEvent();
}

class GetCodeEventStart extends GetCodeEvent{
  const GetCodeEventStart({this.text, this.countryCode});
  final String text;
  final String countryCode;
}

class GetCodeEventCanStart extends GetCodeEvent{

}