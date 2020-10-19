import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:kpp01/bloc/getCodeBloc/bloc.dart';
import 'package:kpp01/bloc/internetCheckBloc/bloc.dart';
import 'package:kpp01/dataModel/httpModel.dart';
import 'package:kpp01/httpSource.dart';
import 'package:kpp01/myPlugin/timerPluginWithBloc/bloc/bloc.dart';

class GetCodeBloc extends Bloc<GetCodeEvent, GetCodeState>{
  GetCodeBloc({this.internetCheckBloc, this.timerBloc}):super(GetCodeStateFinish()){
    streamSubscription = internetCheckBloc.listen((InternetCheckState internetCheckState) {
      if(internetCheckState is InternetCheckStateGod && event is GetCodeEventStart){
        add(GetCodeEventCanStart());
      }
    });

  }

  InternetCheckBloc internetCheckBloc;
  GetCodeEvent event;
  StreamSubscription streamSubscription;
  TimerBloc timerBloc;

  @override
  Future<Function> close() {
    streamSubscription.cancel();
    return super.close();
  }

  @override
  Stream<GetCodeState> mapEventToState(GetCodeEvent event) async*{

    if(event is GetCodeEventCanStart){
      yield*_mapEventToStart(this.event);
      this.event = null;

    }else if(event is GetCodeEventStart){
      this.event = event;
      internetCheckBloc.add(InternetCheckEventCheck(context: event.context));

    }

  }

  Stream<GetCodeState> _mapEventToStart(GetCodeEventStart eventStart)async*{
    yield GetCodeStateProcess();

    try{

      if(eventStart.text == "" || eventStart.text.startsWith("0") || eventStart.text.startsWith("60")){
        yield GetCodeStateFail(text: "Please enter correct phone number, do no start with '0' and '60'. ");

      }else{
        timerBloc.add(Start(duration: 60));
        print("get code from: ${HttpSource.getCode + eventStart.countryCode + eventStart.text}");

        HttpSource httpSource = HttpSource();
        HttpModel  httpModel = await httpSource.requestGet(
          HttpSource.getCode + eventStart.countryCode + eventStart.text,
        );

        if(httpModel.code != 1801){
          yield GetCodeStateFail(text: "Please enter correct phone number, do no start with '0' and '60'. ");

        }

      }
      yield GetCodeStateFinish();
    }catch(e){
      yield GetCodeStateError(e: e)..backError();
    }

  }
  
}