
import 'package:flutter/material.dart';
class ComponentsMain extends StatelessWidget {

  const ComponentsMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text("组件"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
        ),
        body: ComponentsList(),
      ),
    );
  }
}

class ComponentsList extends StatelessWidget {

  const ComponentsList({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    final titles = ["组件"];

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
        print("tap")
      },
    );
  }
}


