

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kpp01/bloc/internetCheckBloc/bloc.dart';
import 'package:http/http.dart' as http;

class InternetCheckBloc extends Bloc<InternetCheckEvent,InternetCheckState>{
  InternetCheckBloc({this.context,}):super(InternetCheckStateNoAction(context));

  BuildContext context ;

  @override
  Stream<InternetCheckState> mapEventToState(InternetCheckEvent event) async*{
    if(event is InternetCheckEventToGod){

      yield InternetCheckStateGod(context);

    }else if(event is InternetCheckEventCheck){
      yield InternetCheckStateChecking(context);

      context = event.context;
      print("InternetChecking");

      try{
        await http.get("https://karatla.com/api/account/get/all");
        yield InternetCheckStateGod(context);

      }catch(e){
        //yield InternetCheckStateBad(context);
        yield InternetCheckStateError(e: e,context: context)..backError();
      }

    }else if(event is InternetCheckEventToNoAction){
      yield InternetCheckStateNoAction(context);
    }
  }

}