import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:PPM/bloc/systemLanguage/bloc.dart';
import 'package:PPM/dataModel/systemLanguageModel.dart';

class SystemLanguageBloc extends Bloc<SystemLanguageEvent,SystemLanguageState>{
  SystemLanguageBloc():super(SystemLanguageStateProcessing());

  SystemLanguageModel systemLanguageModel = SystemLanguageModel()..initialData();

  @override
  Stream<SystemLanguageState> mapEventToState(SystemLanguageEvent event)async*{
    if(event is SystemLanguageEventChange){
      yield SystemLanguageStateProcessing();
      try{
        this.systemLanguageModel.systemLanguageCode = event.systemLanguageCode;
        yield SystemLanguageStateJustChanged(systemLanguageModel: this.systemLanguageModel);
        yield SystemLanguageStateFinished(systemLanguageModel: this.systemLanguageModel);

      }catch(e){
        yield SystemLanguageStateError(e: e)..backError();

      }
    }
  }

}