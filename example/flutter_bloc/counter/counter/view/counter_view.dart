
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/counter_cubit.dart';

class CounterView extends StatelessWidget {

  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text("Counter"),),
      body: Center(
        child: BlocBuilder<CounterCubit, int>( //状态改变后重新构建界面
          builder: (context, state) {
            return Text('$state', style: textTheme.displayMedium);
          },
        ),
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(padding: EdgeInsets.symmetric(vertical: 10),
            child: FloatingActionButton(
              onPressed: () => context.read<CounterCubit>().increment(),
              child: Icon(Icons.add),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: FloatingActionButton(
              onPressed: () => context.read<CounterCubit>().decrement(),
              child: Icon(Icons.remove),
            ),
          )
        ],
      ),
    );
  }
}


