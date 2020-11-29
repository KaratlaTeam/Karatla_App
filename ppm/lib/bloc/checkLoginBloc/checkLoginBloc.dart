
import 'package:bloc/bloc.dart';
import 'package:PPM/bloc/accountDataBloc/accountDataBloc.dart';
import 'package:PPM/bloc/checkLoginBloc/bloc.dart';
import 'package:PPM/bloc/internetCheckBloc/bloc.dart';
import 'package:PPM/bloc/loginBloc/bloc.dart';
import 'package:PPM/dataModel/httpModel.dart';
import 'package:PPM/httpSource.dart';

class CheckLoginBloc extends Bloc<CheckLoginEvent, CheckLoginState>{
  CheckLoginBloc(this.accountDataBloc, this.loginBloc,this.internetCheckBloc):super(CheckLoginStateGood());

  AccountDataBloc accountDataBloc;
  LoginBloc loginBloc;
  InternetCheckBloc internetCheckBloc;

  @override
  Stream<CheckLoginState> mapEventToState(CheckLoginEvent event) async*{


    if(event is CheckLoginEventChangeToGood){
      yield CheckLoginStateGood();

    } else if(event is CheckLoginEventCheck){

      yield* _mapEventCheckLogin(event);

    }

  }

  Stream<CheckLoginState> _mapEventCheckLogin(CheckLoginEventCheck eventCheck)async*{
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