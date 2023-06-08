
import 'dart:async';

import 'package:demo/example/flutter_bloc/timer/ticker.dart';
import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc/bloc.dart';

part 'timer_state.dart';
part 'timer_event.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState>{

  final Ticker _ticker; //数据源

  static const int _duration = 60;

  StreamSubscription<int>? _tickerSubscription;

  TimerBloc({required Ticker ticker})
        :_ticker = ticker,
        super(TimerInitial(_duration)) {
    // TODO: implement event handlers
    on<TimerStarted>(_onStarted); //接收start事件
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerReset>(_onReset);

    on<_TimerTicked>(_onTicked); // 处理_TimerTicked事件

  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel(); //当bloc关闭时，取消ticker订阅
    return super.close();
  }

  // 处理开始事件，
  // 提交一个TimerRunInProgress状态
  // 订阅ticker数据流，并触发一个带剩余时间的一个事件
  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    emit(TimerRunInProgress(event.duration)); //开始事件中提交了一个TimerRunInProgress状态
    _tickerSubscription?.cancel(); //如果已经有打开的则先取消
    _tickerSubscription = _ticker
        .tick(ticks: event.duration) //获取数据流
        .listen((duration) => add(_TimerTicked(duration: duration))); //监听定时器数据流，并触发剩余时间的_TimerTicked事件
  }


  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    if (state is TimerRunInProgress) {
      _tickerSubscription?.pause(); //暂停订阅
      emit(TimerRunInPause(state.duration)); //提交一个暂停状态
    }
  }

  void _onResumed(TimerResumed event, Emitter<TimerState> emit) {
    if (state is TimerRunInPause) {
      _tickerSubscription?.resume();
      emit(TimerRunInProgress(state.duration));
    }
  }

  void _onReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(const TimerInitial(_duration));
  }


  //处理_TimerTicked 事件
  void _onTicked(_TimerTicked event, Emitter<TimerState> emit) {
    // 如果剩余时间 > 0 , 提交一个TimerRunInProgress状态，否则提交一个TimerRunComplete完成状态
    emit(event.duration > 0 ? TimerRunInProgress(event.duration) : TimerRunComplete());
  }








}