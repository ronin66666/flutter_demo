

import 'package:demo/example/counter/bloc/counter_cubit.dart';
import 'package:demo/example/counter/view/counter_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => CounterCubit(),
        child: const CounterPageView(),
      ),
    );
  }
}