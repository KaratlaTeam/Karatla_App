
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kpp01/bloc/internetCheckBloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:kpp01/httpSource.dart';

class InternetCheckBloc extends Bloc<InternetCheckEvent,InternetCheckState>{
  InternetCheckBloc():super(InternetCheckStateNoAction());


  @override
  Stream<InternetCheckState> mapEventToState(InternetCheckEvent event) async*{
    if(event is InternetCheckEventToGod){

      yield InternetCheckStateGod();

    }else if(event is InternetCheckEventCheck){
      yield InternetCheckStateChecking();

      print("InternetChecking");

      try{
        await http.get(HttpSource.checkInternet);
        yield InternetCheckStateGod();

      }catch(e){
        //yield InternetCheckStateBad(context);
        yield InternetCheckStateError(e: e)..backError();
      }

    }else if(event is InternetCheckEventToNoAction){
      yield InternetCheckStateNoAction();
    }
  }

}