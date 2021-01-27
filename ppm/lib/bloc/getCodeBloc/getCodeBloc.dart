import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:PPM/bloc/getCodeBloc/bloc.dart';
import 'package:PPM/bloc/internetCheckBloc/bloc.dart';
import 'package:PPM/dataModel/httpModel.dart';
import 'package:PPM/httpSource.dart';
import 'package:PPM/myPlugin/timerPluginWithBloc/bloc/bloc.dart';

class GetCodeBloc extends Bloc<GetCodeEvent, GetCodeState>{
  GetCodeBloc({this.internetCheckBloc, this.timerBloc}):super(GetCodeStateFinish()){
    streamSubscription = internetCheckBloc.listen((InternetCheckState internetCheckState) {
      if(internetCheckState is InternetCheckStateGod && event is GetCodeEventStart){
        add(GetCodeEventCanStart());
      }
    });

    //streamSubscription2 = timerBloc.listen((TimerState timerState) {
    //  print(canDelete);
    //  if( timerState is Finished ){
    //    print(1);
    //    //add(GetCodeEventCanDeleteCode());
    //  }
    //});

  }

  InternetCheckBloc internetCheckBloc;
  GetCodeEvent event;
  StreamSubscription streamSubscription;
  TimerBloc timerBloc;
  int timeS = 60;

  //String countryCode, phoneN;
  //bool canDelete = false;


  @override
  Future<void> close() {
    streamSubscription.cancel();
    return super.close();
  }

  @override
  Stream<GetCodeState> mapEventToState(GetCodeEvent event) async*{

    if(event is GetCodeEventCanStart){
      yield*_mapEventToStart(this.event);
      //this.event = null;

      //await Future.delayed(Duration(seconds: timeS ));
      //print("times up $timeS");
      //if(canDelete){
      //  add(GetCodeEventDeleteCode(countryCode: this.countryCode, text: this.phoneN));
      //}

    }else if(event is GetCodeEventStart){
      this.event = event;
      internetCheckBloc.add(InternetCheckEventCheck());

    }
    //else if(event is GetCodeEventDeleteCode){
    //  yield* _mapEventToDelete(event);
    //  this.canDelete = false;
//
    //}

  }

  Stream<GetCodeState> _mapEventToStart(GetCodeEventStart eventStart)async*{
    yield GetCodeStateProcess();

    try{
      this.event = null;
      if(eventStart.text == "" || eventStart.text.startsWith("0") || eventStart.text.startsWith("60")){
        yield GetCodeStateFail(text: "Please enter correct phone number, do no start with '0' and '60'. ");

      }else{
        timerBloc.add(Start(duration: timeS));
        print("get code from: ${HttpSource.getCode + eventStart.countryCode + eventStart.text}");

        HttpSource httpSource = HttpSource();
        HttpModel  httpModel = await httpSource.requestGet(
          HttpSource.getCode + eventStart.countryCode + eventStart.text,
        );

        if(httpModel.code != 1801){
          yield GetCodeStateFail(text: "send code fail");

        }
        //else {
        //  this.countryCode = eventStart.countryCode;
        //  this.phoneN = eventStart.text;
        //  this.canDelete = true;
        //}

      }
      yield GetCodeStateFinish();
    }catch(e){
      yield GetCodeStateError(e: e)..backError();
    }

  }

  //Stream<GetCodeState> _mapEventToDelete(GetCodeEventDeleteCode deleteCode)async*{
  //  yield GetCodeStateProcess();
//
  //  try{
  //    print("delete validation code , phone number: ${HttpSource.deleteValidationCode+deleteCode.countryCode+deleteCode.text}");
  //    Map body = {
  //      "code":1850,
  //      "data": {
  //        "phone":deleteCode.countryCode+deleteCode.text,
  //      },
  //    };
  //    HttpSource httpSource = HttpSource();
  //    HttpModel  httpModel = await httpSource.requestPost(
  //      body,
  //      HttpSource.deleteValidationCode+deleteCode.countryCode+deleteCode.text,
  //      HttpSource.headers,
  //    );
//
  //    if(httpModel.code == 1852){
  //      yield GetCodeStateFail(text: "delete fail ");
//
  //    }else if(httpModel.code == 1853){
  //      yield GetCodeStateFail(text: "request code wrong");
//
  //    }
  //    yield GetCodeStateFinish();
//
  //  }catch(e){
  //    yield GetCodeStateError(e: e)..backError();
  //  }
  //}
  
}