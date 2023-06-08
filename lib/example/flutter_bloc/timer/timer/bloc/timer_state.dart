
// 消费数据源
part of 'timer_bloc.dart'; //使用part来与timer_bloc.dart文件共享同样的库，该文件中所需的库必须全部定义在timer_bloc.dart文件中

class TimerState extends Equatable {

  final int duration; //记录倒计时时间

  const TimerState(this.duration);

  @override
  List<Object?> get props => [duration];

}

class TimerInitial extends TimerState {

  const TimerInitial(super.duration);

  @override
  String toString() => 'TimerInitial {duration: $duration}';

}

class TimerRunInPause extends TimerState {
  const TimerRunInPause(super.duration);
  @override
  String toString() {
    // TODO: implement toString
    return 'TimerRunInPause {duration: $duration}';
  }
}


// 正在运行状态
class TimerRunInProgress extends TimerState {
  const TimerRunInProgress(super.duration);

  @override
  String toString() => 'TimerRunInProgress { duration: $duration }';
}

// 结束状态
class TimerRunComplete extends TimerState {
  const TimerRunComplete() : super(0);
  @override
  String toString() => 'TimerRunComplete';
}














