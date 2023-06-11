
// event
// TimerStarted
// TimerPaused
// TimerResumed 暂停后恢复事件
// TimerReset
// TimerTicked
// part of 'timer_bloc.dart';
part of 'timer_bloc.dart';

class TimerEvent {
  const TimerEvent();
}

class TimerStarted extends TimerEvent {
  final int duration;
  const TimerStarted({required this.duration});
}

class TimerPaused extends TimerEvent {
  const TimerPaused();
}

class TimerResumed extends TimerEvent {
  const TimerResumed();
}

class TimerReset extends TimerEvent {
  const TimerReset();
}

class _TimerTicked extends TimerEvent {
  final int duration;

  const _TimerTicked({required this.duration});
}