

// 观察所有的状态改变

import 'package:flutter_bloc/flutter_bloc.dart';

class CounterObserver extends BlocObserver {
  const CounterObserver();

  @override
  void onChange(BlocBase bloc, Change change) {
    // TODO: implement onChange
    super.onChange(bloc, change);
    print('${bloc.runtimeType}, $change');
  }
}