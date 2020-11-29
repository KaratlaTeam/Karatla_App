import 'package:flutter/cupertino.dart';
import 'package:PPM/dataModel/bottomNavigationDataModel.dart';

abstract class BottomNavigationState{
  const BottomNavigationState();
}

class BottomNavigationStatePageChanging extends BottomNavigationState{
  const BottomNavigationStatePageChanging();
}

class BottomNavigationStatePageChanged extends BottomNavigationState{
  const BottomNavigationStatePageChanged(this.bottomNavigationDataModel);
  final BottomNavigationDataModel bottomNavigationDataModel;
}

class BottomNavigationStateError extends BottomNavigationState{
  final e;
  const BottomNavigationStateError({@required this.e});
  backError(){
    return print("BottomNavigationStateError: \n"+e.toString());
  }
}