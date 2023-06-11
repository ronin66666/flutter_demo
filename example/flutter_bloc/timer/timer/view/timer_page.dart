


import 'package:demo/example/flutter_bloc/timer/ticker.dart';
import 'package:demo/example/flutter_bloc/timer/timer/bloc/timer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerBloc(ticker: Ticker()),
      child: const TimerView(),
    );
  }
}


class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Flutter Timer"),),
      body: const Stack(
        children: [
          Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(padding: EdgeInsets.symmetric(vertical: 100.0),
              child: Center(child: TimerText(),),
              ),
              Actions()
            ],
          )
        ],
      ),
    );
  }
}


class TimerText extends StatelessWidget {
  const TimerText({super.key});

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final minutesStr = ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');

    return Text('$minutesStr:$secondsStr', style: Theme.of(context).textTheme.headlineLarge,);
  }
}

class Actions extends StatelessWidget {
  const Actions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (pre, state) => pre.runtimeType != state.runtimeType,
      builder: (context,state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: childrenWidgets(context, state)
          );
      },
    );
  }

   List<Widget> childrenWidgets(BuildContext context, TimerState state) {
    switch (state.runtimeType) {
      case TimerInitial:
        return [
          FloatingActionButton(
              child: const Icon(Icons.play_arrow),
              onPressed: () => context.read<TimerBloc>().add(TimerStarted(duration: state.duration))
          )
        ];
      case TimerRunInProgress:
        return [
          FloatingActionButton(
            child: const Icon(Icons.pause),
              onPressed: () => context.read<TimerBloc>().add(const TimerPaused())
          ),
          FloatingActionButton(
              child: const Icon(Icons.replay),
              onPressed: () => context.read<TimerBloc>().add(const TimerPaused())
          )
        ];
      case TimerRunInPause:
        return [
          FloatingActionButton(
              child: const Icon(Icons.play_arrow),
              onPressed: () => context.read<TimerBloc>().add(const TimerResumed())),
          FloatingActionButton(
              child: const Icon(Icons.replay),
              onPressed: () => context.read<TimerBloc>().add(const TimerReset())),
        ];
      case TimerRunComplete: {
        return [
          FloatingActionButton(
              child: const Icon(Icons.replay),
              onPressed: () => context.read<TimerBloc>().add(const TimerReset())),
        ];
      }
    }
    return [const Placeholder()];
  }
}



class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade50,
            Colors.blue.shade500,
          ],
        ),
      ),
    );
  }
}
