
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kpp01/bloc/checkLoginBloc/bloc.dart';
import 'package:kpp01/bloc/checkLoginBloc/checkLoginEvent.dart';
import 'package:kpp01/bloc/internetCheckBloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:kpp01/httpSource.dart';

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
      var req = await internetCheck();

      try{

        if(req == true){
          yield InternetCheckStateGod(context);

        }else{
          yield InternetCheckStateBad(context);

        }

      }catch(e){
        yield InternetCheckStateError(e: e,context: context)..backError();
      }

    }else if(event is InternetCheckEventToNoAction){
      yield InternetCheckStateNoAction(context);
    }
  }

  Future<bool> internetCheck()async{
    print("InternetChecking");

    try{
      await http.get("https://google.com");
      return true;

    }catch (e){
      try{
        await http.get("https://baidu.com");
        return true;

      }catch(e){
        return false;
      }

    }

  }

}