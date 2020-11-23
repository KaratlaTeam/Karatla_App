
import 'package:flutter/material.dart';
import 'package:kpp01/bloc/drivingAcademyDataBloc/bloc.dart';

class DrivingAcademyDataEvent{
  const DrivingAcademyDataEvent();
}

class DrivingAcademyDataEventGetData extends DrivingAcademyDataEvent{
      final String systemLanguage;
      const DrivingAcademyDataEventGetData({
        @required this.systemLanguage,
      }):assert(systemLanguage != null);
}

class DrivingAcademyDataEventGetDataFromInternet extends DrivingAcademyDataEvent{
        final String systemLanguage;
      const DrivingAcademyDataEventGetDataFromInternet({
        @required this.systemLanguage,
      }):assert(systemLanguage != null);
}