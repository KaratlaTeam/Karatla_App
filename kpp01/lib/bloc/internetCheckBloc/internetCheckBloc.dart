
import 'package:bloc/bloc.dart';
import 'package:kpp01/bloc/internetCheckBloc/bloc.dart';

class InternetCheckBloc extends Bloc<InternetCheckEvent,InternetCheckState>{
  InternetCheckBloc():super(InternetCheckStateChecking());

  @override
  Stream<InternetCheckState> mapEventToState(InternetCheckEvent event) async*{
    if(event is InternetCheckEventToGod){
      yield InternetCheckStateGod();

    }else if(event is InternetCheckEventCheck){
      yield InternetCheckStateChecking();

      try{

        if(true){
          yield InternetCheckStateGod();

        }else{
          yield InternetCheckStateBad();

        }

      }catch(e){
        yield InternetCheckStateError(e: e)..backError();
      }

    }
  }
}