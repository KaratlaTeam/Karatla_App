 import 'package:flutter/cupertino.dart';

abstract class InternetCheckState {
  const InternetCheckState();
}

 class InternetCheckStateChecking extends InternetCheckState{

 }

 class InternetCheckStateGod extends InternetCheckState{

 }

 class InternetCheckStateBad extends InternetCheckState{

 }

 class InternetCheckStateError extends InternetCheckState{
   final e;
   const InternetCheckStateError({@required this.e});
   backError(){
     return print("InternetCheckStateError: \n"+e.toString());
   }
 }
