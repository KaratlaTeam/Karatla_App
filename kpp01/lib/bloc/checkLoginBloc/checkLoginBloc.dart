
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:kpp01/bloc/accountDataBloc/accountDataBloc.dart';
import 'package:kpp01/bloc/checkLoginBloc/bloc.dart';
import 'package:kpp01/bloc/loginBloc/bloc.dart';
import 'package:kpp01/dataModel/httpModel.dart';
import 'package:kpp01/httpSource.dart';
import 'package:http/http.dart' as http;

class CheckLoginBloc extends Bloc<CheckLoginEvent, CheckLoginState>{
  CheckLoginBloc(this.accountDataBloc, this.loginBloc):super(CheckLoginStateGood());

  AccountDataBloc accountDataBloc;
  LoginBloc loginBloc;

  @override
  Stream<CheckLoginState> mapEventToState(CheckLoginEvent event) async*{


    if(event is CheckLoginEventChangeToGood){
      yield CheckLoginStateGood();

    } else if(event is CheckLoginEventCheck){

      try{
        Map body = {
          "code":1600,
          "data": {
            "my_uuid": accountDataBloc.accountDataModel.myUuid,
            "my_device_id_now": accountDataBloc.accountDataModel.myDeviceIdNow,
            "my_phone": accountDataBloc.accountDataModel.myPhone,
          }
        };

        HttpSource httpSource = HttpSource();
        HttpModel  httpModel = await httpSource.requestPost(
          body,
          HttpSource.checkLogin,
          HttpSource.headers,
        );

        if(httpModel.code == 1601){
          yield CheckLoginStateGood();

        } else {
          loginBloc.add(LoginEventSignOut());
          yield CheckLoginStateBad();

        }

      }catch(e){
        print("CheckLoginStateError: $e");
        loginBloc.add(LoginEventSignOut());
        yield CheckLoginStateBad();

      }
    }

  }
}