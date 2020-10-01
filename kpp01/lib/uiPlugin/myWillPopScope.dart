import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpp01/myPlugin/timerPluginWithBloc/bloc/bloc.dart';

class MyWillPopScope extends StatelessWidget{

  const MyWillPopScope({
    Key key,
    this.text: const Text("Do you want to leave ?"),
    @required this.pause,
    @required this.flatButtonL,
    @required this.flatButtonR,
    @required this.child,
}):super(key:key);

  final Widget child;
  final FlatButton flatButtonL;
  final FlatButton flatButtonR;
  final Text text;
  final bool pause;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: ()async{
            if(pause == true){
              BlocProvider.of<TimerBloc>(context).add(Pause());
            }
        showDialog(context: context,builder: (build){
          return WillPopScope(
            onWillPop: ()async{return false;},
            child: SimpleDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: text,
              children: <Widget>[
                flatButtonL,
                flatButtonR,
              ],
            ),
          );
        });
        return false;
      },
      child: child,
    );
  }
}