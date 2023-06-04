
import 'package:demo/example/components/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("基础知识")),
        body: MainListPage(),
      ),
    );
  }
}

class MainListPage extends StatelessWidget {

  MainListPage({Key? key}) : super(key: key);

  final titles = ["组件"];

  Widget build(BuildContext context) {
    return ListView(
      children: titles.map((e) => MainListItem(e)).toList(),
    );
  }
}

class MainListItem extends StatelessWidget {
  final String title;
  const MainListItem(this.title, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(title, style: TextStyle(fontSize: 20)),
      onTap: () => {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ComponentsMain()))
        },
      );
  }
}



