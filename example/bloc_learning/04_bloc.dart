import 'package:bloc/bloc.dart';

abstract class CounterEvent {}

// 增加事件
class CounterIncrementPressed extends CounterEvent {}
// 减少事件
class CounterDecrementPressed extends CounterEvent {}

// bloc好处事件分离，状态管理分离， 描述更清楚
class CounterBloc extends Bloc<CounterEvent, int> {

  CounterBloc({int? initialState}) : super(initialState ?? 0) {

    on<CounterIncrementPressed>((event, emit) {

        // 处理 `CounterIncrementPressed` event
        emit(state + 1);
      },
      // transformer: (events, mapper) {
      //   // 可以在这里做一些处理
      //   return events.where((event) => event is CounterIncrementPressed);
      // }, 
    );
    
    on<CounterDecrementPressed>((event, emit) {
      
       emit(state - 1);
    });
  }

  @override
  void onChange(Change<int> change) {
    // TODO: implement onChange
    super.onChange(change);
    print(change);
  }

  @override
  void onTransition(Transition<CounterEvent, int> transition) {
    super.onTransition(transition);
    // 在状态转换时调用，可以用于记录或处理状态转换。
    print(transition);
  }

  // onEvent 事件, bloc中特有的回调
  @override
  void onEvent(CounterEvent event) {
    super.onEvent(event);
    print(event);
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    // TODO: implement onChange
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('${bloc.runtimeType} $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('${bloc.runtimeType} $event');
  }
}


// Future<void> main(List<String> args) async {
//   final bloc = CounterBloc();
//   final subscription = bloc.stream.listen(print);
//   bloc.add(CounterIncrementPressed()); //1
//   bloc.add(CounterDecrementPressed()); //0
//   await Future<void>.delayed(Duration.zero);
//   await subscription.cancel();
//   await bloc.close();
// }




void main(List<String> args) {
  Bloc.observer = SimpleBlocObserver();
  CounterBloc()
    ..add(CounterIncrementPressed())
    ..close();
}