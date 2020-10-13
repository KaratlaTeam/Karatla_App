 import 'package:flutter/cupertino.dart';

abstract class InternetCheckState {
  const InternetCheckState(this.context);
  final BuildContext context;
}

 class InternetCheckStateChecking extends InternetCheckState{
   const InternetCheckStateChecking(this.context) : super(context);
   final BuildContext context;
 }

 class InternetCheckStateNoAction extends InternetCheckState{
   const InternetCheckStateNoAction(this.context) : super(context);
   final BuildContext context;
 }

 class InternetCheckStateGod extends InternetCheckState{
   const InternetCheckStateGod(this.context) : super(context);
   final BuildContext context;

 }

 class InternetCheckStateBad extends InternetCheckState{
   const InternetCheckStateBad(this.context) : super(context);
   final BuildContext context;

 }

 class InternetCheckStateError extends InternetCheckState{
   final BuildContext context;
   final e;
   const InternetCheckStateError({@required this.e,this.context }): super(context);
   backError(){
     return print("InternetCheckStateError: \n"+e.toString());
   }
 }
