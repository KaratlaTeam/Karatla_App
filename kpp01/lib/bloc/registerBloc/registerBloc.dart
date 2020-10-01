import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpp01/bloc/registerBloc/registerEvent.dart';
import 'package:kpp01/bloc/registerBloc/registerState.dart';
import 'package:http/http.dart' as http;
import 'package:kpp01/dataModel/httpModel.dart';
import 'package:kpp01/httpSource.dart';

class RegisterBloc extends Bloc<RegisterEvent,RegisterState>{
  RegisterBloc():super(RegisterStateRegisterFinished());

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async*{
    if(event is RegisterEventAccountRegister){
      yield RegisterStateRegisterStart();
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
          HttpModel  httpModel = await httpSource.requestPost(
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

    }else if(event is RegisterEventCodeRegister){
      yield RegisterStateRegisterStart();
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

}