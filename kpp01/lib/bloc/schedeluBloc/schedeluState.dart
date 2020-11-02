import 'package:flutter/material.dart';
import 'package:kpp01/dataModel/scheduleModel.dart';

abstract class SchedeluState{

}

class SchedeluStateChanging extends SchedeluState{}

class SchedeluStateChanged extends SchedeluState{
  SchedeluStateChanged({@required this.schedeluModel});
  final SchedeluModel schedeluModel;
}

class SchedeluStateError extends SchedeluState{
  SchedeluStateError({@required this.e});
  final e;
  backError(){
    return print("SchedeluStateError: \n"+e.toString());
  }
}