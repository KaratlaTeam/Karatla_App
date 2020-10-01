import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import './bloc.dart';
import '../ticker.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  TimerBloc(this.ticker,this.duration):
        assert(ticker != null),
        assert(duration != null),
        super(Ready(duration));
  
  final Ticker ticker;
  final int duration ;

  StreamSubscription<int> _tickerSubscription;

  @override
  void onTransition(Transition<TimerEvent, TimerState> transition) {
    print(transition.toString()+"${state.duration}");
    super.onTransition(transition);
  }

  @override
  Stream<TimerState> mapEventToState(TimerEvent event,) async* {
    if (event is Start) {
      yield* _mapStartToState(event);
    } else if (event is Pause) {
      yield* _mapPauseToState(event);
    } else if (event is Resume) {
      yield* _mapResumeToState(event);
    } else if (event is Reset) {
      yield* _mapResetToState(event);
    } else if (event is Tick) {
      yield* _mapTickToState(event);
    }
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  Stream<TimerState> _mapStartToState(Start start) async* {
    yield Running(start.duration);
    _tickerSubscription?.cancel();
    _tickerSubscription = ticker
        .tick(ticks: start.duration)
        .listen((duration) => add(Tick(duration: duration)));
  }

  Stream<TimerState> _mapPauseToState(Pause pause) async* {
    if (state is Running) {
      _tickerSubscription?.pause();
      yield Paused(state.duration);
    }
  }

  Stream<TimerState> _mapResumeToState(Resume resume) async* {
    if (state is Paused) {
      _tickerSubscription?.resume();
      yield Running(state.duration);
    }
  }

  Stream<TimerState> _mapResetToState(Reset reset) async* {
    _tickerSubscription?.cancel();
    yield Ready(duration);
  }

  Stream<TimerState> _mapTickToState(Tick tick) async* {
    yield tick.duration > 0 ? Running(tick.duration) : Finished();
  }
}