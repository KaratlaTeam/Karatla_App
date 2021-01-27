import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:PPM/bloc/internetCheckBloc/bloc.dart';
import 'package:PPM/bloc/registerBloc/registerEvent.dart';
import 'package:PPM/bloc/registerBloc/registerState.dart';
import 'package:PPM/dataModel/httpModel.dart';
import 'package:PPM/httpSource.dart';

class RegisterBloc extends Bloc<RegisterEvent,RegisterState>{
  RegisterBloc({this.internetCheckBloc}):super(RegisterStateRegisterFinished()){
   streamSubscription = internetCheckBloc.listen((InternetCheckState internetCheckState) {
     if(internetCheckState is InternetCheckStateGod && event is RegisterEventCodeRegister){
       add(RegisterEventCodeCanRegister());

     }else if(internetCheckState is InternetCheckStateGod && event is RegisterEventAccountRegister){
       add(RegisterEventAccountCanRegister());

     }
   });
  }

  InternetCheckBloc internetCheckBloc;
  RegisterEvent event;
  StreamSubscription streamSubscription;

  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async*{
    if(event is RegisterEventCodeCanRegister) {
      yield* _mapEventToCodeRegister(this.event);
      //this.event = null;

    }else if(event is RegisterEventAccountCanRegister) {
      yield* _mapEventToAccountRegister(this.event);
      //this.event = null;

    } else if(event is RegisterEventAccountRegister){
      this.event = event;
      internetCheckBloc.add(InternetCheckEventCheck());

    }else if(event is RegisterEventCodeRegister){
      this.event = event;
      internetCheckBloc.add(InternetCheckEventCheck());

    }
  }

  Stream<RegisterState> _mapEventToAccountRegister(RegisterEventAccountRegister event) async*{
    yield RegisterStateRegisterStart();
    this.event = null;
    try{
      if(event.passWord != event.confirmPassWord || event.passWord == "" || event.passWord.length < 8 || event.userName == "" || event.userName.length < 2 ){
        String failText = '';
        if(event.userName == ""){
          failText = "Name can not empty";
        }else if(event.userName.length < 2){
          failText = "Name minimum of 2 characters.";
        }else if(event.passWord != event.confirmPassWord){
          failText = "Password and confirm password not same";
        }else if(event.passWord == ""){
          failText = "Password can not empty";
        }else if(event.passWord.length < 8){
          failText = "Password minimum of 8 characters";
        }
        yield RegisterStateRegisterFail(text: failText);
      }else{

        Map body = {
          "code": 1100,
          "data": {
            "my_name": event.userName,
            "my_password": event.passWord,
            "my_phone": event.phone,
          }
        };

        HttpSource httpSource = HttpSource();
        //HttpModel  httpModel = 
        await httpSource.requestPost(
          body,
          HttpSource.register,
          HttpSource.headers,
        );

        yield RegisterStateRegisterSuccessful();
      }
      yield RegisterStateRegisterFinished();
    }catch(e){
      yield RegisterStateError(e: e)..backError();
    }
  }

  Stream<RegisterState> _mapEventToCodeRegister(RegisterEventCodeRegister event) async*{
    yield RegisterStateRegisterStart();
    this.event = null;
    try{
      if(event.code.length < 6){
        yield RegisterStateRegisterFail(text: "Please enter correct code");
      }else{

        Map body = {
          "code": 1900,
          "data": {
            "v_code": event.code.toString(),
          }
        };
        HttpSource httpSource = HttpSource();
        HttpModel  httpModel = await httpSource.requestPost(
          body,
          HttpSource.checkCode + event.phone,
          HttpSource.headers,
        );

        if(httpModel.code == 1901){
          yield RegisterStateRegisterSuccessful();
        }else if(httpModel.code == 1911){
          yield RegisterStateRegisterFail(text: httpModel.data["state"]);
        }else if(httpModel.code == 1912){
          yield RegisterStateRegisterFail(text: httpModel.data["state"]);
        }
      }


      yield RegisterStateRegisterFinished();
    }catch(e){
      yield RegisterStateError(e: e)..backError();
    }
  }

}