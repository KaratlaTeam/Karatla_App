
import 'package:flutter/material.dart';
import 'package:PPM/bloc/drivingAcademyDataBloc/bloc.dart';

class DrivingAcademyDataEvent{
  const DrivingAcademyDataEvent();
}

class DrivingAcademyDataEventGetData extends DrivingAcademyDataEvent{
      final String systemLanguage;
      const DrivingAcademyDataEventGetData({
        @required this.systemLanguage,
      }):assert(systemLanguage != null);
}

class DrivingAcademyDataEventCheckInternetThenGet extends DrivingAcademyDataEvent{
      final String systemLanguage;
      const DrivingAcademyDataEventCheckInternetThenGet({
        @required this.systemLanguage,
      }):assert(systemLanguage != null);
}

class DrivingAcademyDataEventGetDataFromInternet extends DrivingAcademyDataEvent{}

class DrivingAcademyDataEventInternetErrorWithoutData extends DrivingAcademyDataEvent{}