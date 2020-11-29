import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:PPM/bloc/accountDataBloc/bloc.dart';
import 'package:PPM/bloc/internetCheckBloc/bloc.dart';
import 'package:PPM/bloc/loginBloc/bloc.dart';
import 'package:PPM/dataModel/accountDataModel.dart';
import 'package:PPM/dataModel/httpModel.dart';
import 'package:PPM/httpSource.dart';

class LoginBloc extends Bloc<LoginEvent,LoginState>{
  LoginBloc(this.accountDataBloc, this.internetCheckBloc):super(LoginStateSignOutFinished()){
    streamSubscription = internetCheckBloc.listen((InternetCheckState internetCheckState) {
      if(internetCheckState is InternetCheckStateGod && event is LoginEventSignIn){
        add(LoginEventSignInCanSignIn());

      }
    });
  }

  StreamSubscription streamSubscription;
  AccountDataBloc accountDataBloc;
  InternetCheckBloc internetCheckBloc;
  LoginEvent event ;

  @override
  Future<void> close() {
    accountDataBloc.close();
    streamSubscription.cancel();
    return super.close();
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event)async* {

    if(event is LoginEventSignInChangeToSuccessful){
      yield LoginStateSignSuccessful();

    } else if(event is LoginEventSignInCanSignIn) {
      yield* _mapToLogin(this.event);
      this.event = null;

    } else if(event is LoginEventSignIn){
      this.event = event;
      internetCheckBloc.add(InternetCheckEventCheck());

    }else if(event is LoginEventSignOut){
      yield LoginStateSignOutProcess();

      try{
        await accountDataBloc.accountDataModel.setSharePLogOut();

        Map body = {
          "code":1700,
          "data":{
            "my_uuid": accountDataBloc.accountDataModel.myUuid,
          }
        };

        HttpSource httpSource = HttpSource();
       // HttpModel  httpModel = 
        await httpSource.requestPost(
          body,
          HttpSource.logout,
          HttpSource.headers,
        );

        yield LoginStateSignOutFinished();
        
      }catch(e){
        yield LoginStateSignOutError(e: e)..backError();
        
      }
    }
  }

  Stream<LoginState> _mapToLogin(LoginEventSignIn event)async*{
    yield LoginStateSignProcess();
    if(event.password == "" || event.loginAccount == ""){
      yield LoginStateSignFail(text: "account or password can not empty!");
      yield LoginStateSignOutFinished();
    }else if(event.password.length < 8){
      yield LoginStateSignFail(text: "Password minimum of 8 characters");
      yield LoginStateSignOutFinished();
    }else if(event.loginType == "PHONE" && (event.loginAccount.startsWith("600") || event.loginAccount.startsWith("6060") || event.loginAccount.length < 5)){
      yield LoginStateSignFail(text: "Please enter correct phone number, do no start with '0' and '60' . ");
      yield LoginStateSignOutFinished();
    }else{
      try{

        print("login type "+event.loginType.toString());
        Map body = {
          "code":1500,
          "data":{
            "my_login_type": event.loginType,
            "my_device_id_now": event.myDeviceIdNow,
            "my_password": event.password,
            "login_account": event.loginAccount,
          }
        };

        HttpSource httpSource = HttpSource();
        HttpModel  httpModel = await httpSource.requestPost(
          body,
          HttpSource.login,
          HttpSource.headers,
        );

        String myUuid = httpModel.data["my_uuid"];
        print(httpModel.code);

        if(httpModel.code == 1501){

          Map body = {
            "code":1400,
            "data":{
              "my_uuid": myUuid,
            }
          };

          HttpSource httpSource = HttpSource();
          HttpModel  httpModel = await httpSource.requestPost(
            body,
            HttpSource.getAccount,
            HttpSource.headers,
          );

          accountDataBloc.accountDataModel = await AccountDataModel().setSharedPreferences(httpModel, accountDataBloc.accountDataModel);
          accountDataBloc.add(AccountDataEventChangeToFinish());

          yield LoginStateSignSuccessful();

        }else if(httpModel.code == 1512){
          yield LoginStateSignFail(text: "Password wrong");
          yield LoginStateSignOutFinished();
        }else{
          yield LoginStateSignFail(text: "Login fail, please check and try again");
          yield LoginStateSignOutFinished();
        }
      }catch(e){
        yield LoginStateSignError(e: e)..backError();
      }
    }

  }

}