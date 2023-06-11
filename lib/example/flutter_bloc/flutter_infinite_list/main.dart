

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import 'app.dart';
import 'simple_bloc_observer.dart';

void main() {
  Bloc.observer = const SimpleBlocObserver();
  runApp(const App());
}
