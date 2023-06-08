import 'package:demo/example/main_page.dart';
import 'package:demo/mj/01_smaple_list_page/list_page.dart';
import 'package:demo/example/counter/counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'example/components/components.dart';
import 'mj/02_counter/counter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MainPage();

    // return BlocSelector<>
  }
}
