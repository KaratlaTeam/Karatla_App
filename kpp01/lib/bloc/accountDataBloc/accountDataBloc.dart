import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:kpp01/bloc/accountDataBloc/bloc.dart';
import 'package:kpp01/dataModel/accountDataModel.dart';

class AccountDataBloc extends Bloc<AccountDataEvent,AccountDataState>{
  AccountDataBloc():super(AccountDataStateInitialDataDoing());

  AccountDataModel accountDataModel = AccountDataModel()..initialData();

  @override
  Stream<AccountDataState> mapEventToState(AccountDataEvent event)async* {
    if(event is AccountDataEventInitialData){
      yield AccountDataStateInitialDataDoing();
      try{

        accountDataModel = await AccountDataModel().getSharedPreferences(accountDataModel);

        if(accountDataModel.myState == "OFF"){
          yield AccountDataStateError(e: "state: OFF")..backError();
        }else{
          yield AccountDataStateFinish(accountDataModel: accountDataModel);
        }
      }catch(e){
        yield AccountDataStateError(e: e)..backError();
      }
    }else if(event is AccountDataEventChangeToFinish){

      yield AccountDataStateFinish(accountDataModel: accountDataModel);

    }
  }


}