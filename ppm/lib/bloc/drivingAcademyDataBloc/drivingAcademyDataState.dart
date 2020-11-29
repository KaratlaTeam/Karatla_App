import 'package:flutter/material.dart';
import 'package:PPM/dataModel/drivingAcademyDataModel.dart';

abstract class DrivingAcademyDataState{

}

class DrivingAcademyDataStateGetting extends DrivingAcademyDataState{}

class DrivingAcademyDataStateGot extends DrivingAcademyDataState{
  DrivingAcademyDataStateGot({@required this.drivingAcademyDataModelList});
  final DrivingAcademyDataModelList drivingAcademyDataModelList;
}

class DrivingAcademyDataStateError extends DrivingAcademyDataState{
  DrivingAcademyDataStateError({@required this.e});
  final e;
  backError(){
    return print("DrivingAcademyDataStateError: \n"+e.toString());
  }
}