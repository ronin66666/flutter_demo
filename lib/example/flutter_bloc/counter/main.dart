

import 'package:demo/example/flutter_bloc/counter/counter_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';

void main() {

  Bloc.observer = const CounterObserver();
  runApp(const CounterApp());

}

