import 'package:flutter/cupertino.dart';
import 'package:kpp01/dataModel/accountDataModel.dart';

abstract class AccountDataState{

}

class AccountDataStateInitialDataDoing extends AccountDataState{}

class AccountDataStateFinish extends AccountDataState{
  AccountDataStateFinish({@required this.accountDataModel});
  final AccountDataModel accountDataModel;
}

class AccountDataStateError extends AccountDataState{
  AccountDataStateError({@required this.e});
  final e;
  backError(){
    return print("AccountDataStateError: \n"+e.toString());
  }
}