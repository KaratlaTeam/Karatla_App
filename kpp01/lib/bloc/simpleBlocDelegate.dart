
import 'package:bloc/bloc.dart';

class SimpleBlocObserver extends BlocObserver{

  @override
  void onEvent(Bloc bloc, Object event) {
    print("【${DateTime.now()}】 event: "+event.toString());
    super.onEvent(bloc, event);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    print("----⬇-----BlocDelegate error---⬇-----");
    print(error);
    print("----⬆--------⬆-----");
    print("----⬇-----BlocDelegate stackTrace---⬇-----");
    print(stackTrace);
    print("----⬆--------⬆-----");
    super.onError(cubit, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print("【${DateTime.now()}】 $transition");
    super.onTransition(bloc, transition);
  }
}