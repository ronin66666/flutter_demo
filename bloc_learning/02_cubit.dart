
import 'package:bloc/bloc.dart';

// void main(List<String> args) {
//   final cubit = CounterCubit();
//   print(cubit.state); //0
//   cubit.increment();
//   print(cubit.state); //1
//   cubit.decrement();
//   print(cubit.state); //0

// }

// Future<void> main(List<String> args) async {
//   final cubit = CounterCubit();
//   final subscription = cubit.stream.listen(print); //监听状态变化, 并打印
//   cubit.increment();  //1
//   cubit.decrement();  //0
//   await Future<void>.delayed(Duration.zero);
//   await subscription.cancel(); //取消监听，不再订阅新的状态
//   cubit.decrement();  //取消后，状态再次发生改变，但是不会再打印出新的状态

//   await cubit.close();
//   cubit.decrement();  //报错，Bad state: Cannot emit new states after calling close
// }

void main(List<String> args) {
  CounterCubit()
    ..increment() 
    ..close();
}

// 1.创建一个CounterCubit类, 继承Cubit, 并指定管理的状态类型为int
class CounterCubit extends Cubit<int> {
  //初始化状态
  CounterCubit({int? initialState}) : super(initialState ?? 0);

  //2.定义两个方法, 用于改变状态
  void increment() => emit(state + 1); //通过emit输出一个新的状态

  void decrement() => emit(state - 1);

  // 复写onChange方法, 用于监听所有的状态变化
  @override
  void onChange(Change<int> change) {
    super.onChange(change);
    print(change); 
  }
}



