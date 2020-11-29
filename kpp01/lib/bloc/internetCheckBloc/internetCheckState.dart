 import 'package:flutter/cupertino.dart';

abstract class InternetCheckState {
  const InternetCheckState();
}

 class InternetCheckStateChecking extends InternetCheckState{

 }

 class InternetCheckStateNoAction extends InternetCheckState{

 }

 class InternetCheckStateGod extends InternetCheckState{

 }

 //class InternetCheckStateBad extends InternetCheckState{
 //  const InternetCheckStateBad(this.context) : super(context);
 //  final BuildContext context;
//
 //}

 class InternetCheckStateError extends InternetCheckState{
   final e;
   const InternetCheckStateError({@required this.e});
   backError(){
     return print("InternetCheckStateError: \n"+e.toString());
   }
 }
