import 'package:flutter/cupertino.dart';

abstract class GetCodeEvent{
  const GetCodeEvent();
}

class GetCodeEventStart extends GetCodeEvent{
  const GetCodeEventStart({this.context, this.text, this.countryCode});
  final BuildContext context;
  final String text;
  final String countryCode;
}

class GetCodeEventCanStart extends GetCodeEvent{

}