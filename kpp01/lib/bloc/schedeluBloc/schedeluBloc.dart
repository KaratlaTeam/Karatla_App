import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpp01/bloc/schedeluBloc/bloc.dart';
import 'package:kpp01/dataModel/accountDataModel.dart';

class SchedeluBloc extends Bloc<SchedeluEvent,SchedeluState>{
  SchedeluBloc({this.accountDataModel}):super(SchedeluStateChanged(schedeluModel: accountDataModel.schedeluModel));

  AccountDataModel accountDataModel ;

  @override
  Stream<SchedeluState> mapEventToState(SchedeluEvent event)async* {
    if(event is SchedeluEventChange){
      yield SchedeluStateChanging();
      try{
        accountDataModel.schedeluModel = event.schedeluModel;
        this.accountDataModel.setSharePSchedule();
        yield SchedeluStateChanged(schedeluModel: this.accountDataModel.schedeluModel);

      }catch(e){
        yield SchedeluStateError(e: e)..backError();

      }
    }else if(event is SchedeluEventChangeToFinish){

      yield SchedeluStateChanged(schedeluModel: this.accountDataModel.schedeluModel);

    }
  }


}