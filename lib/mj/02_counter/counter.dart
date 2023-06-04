

import 'package:flutter/material.dart';

class MyCounterHomePage extends StatelessWidget {
  const MyCounterHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red,
        body: SafeArea(child: const MyCounterWidget()),
      ),
    );
  }
}


class MyCounterWidget extends StatefulWidget {
  const MyCounterWidget({Key? key}) : super(key: key);

  @override
  State<MyCounterWidget> createState() => _MyCounterWidgetState();
}

class _MyCounterWidgetState extends State<MyCounterWidget> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    print("build");
    final buttonStyle = ButtonStyle(shape: MaterialStateProperty.all<OutlinedBorder>(
      const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero
      )
    ));
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: buttonStyle,
                  onPressed: () =>  setState(() => counter++),

                  child: const Text('+', style: TextStyle(fontSize: 20, color: Colors.red),)),
              ElevatedButton(
                style: buttonStyle,
                  onPressed: () =>  setState(() => counter--),
                  child: const Text('-', style: TextStyle(fontSize: 20, color: Colors.red),))
            ],
          ),
          Text('计数器：$counter', style: TextStyle(fontSize: 20, color: Colors.blue),),
        ],
      ),
    );
  }

}
