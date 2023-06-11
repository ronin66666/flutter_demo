import 'package:flutter/material.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ListHomePage(),
    );
  }
}

class ListHomePage extends StatelessWidget {
  const ListHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('商品列表')),
      body: const ListHomeContent()
    );
  }
}

class ListHomeContent extends StatelessWidget {
  const ListHomeContent({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      children:  const <Widget> [
        HomeProductItem("Apple1", "macbook1", "https://t7.baidu.com/it/u=2291349828,4144427007&fm=193&f=GIF"),
        HomeProductItem("Apple2", "macbook2", "https://t7.baidu.com/it/u=963301259,1982396977&fm=193&f=GIF"),
        HomeProductItem("Apple3", "macbook3", "https://t7.baidu.com/it/u=4240641596,3235181048&fm=193&f=GIF"),
      ],
    );
  }
}

class HomeProductItem extends StatelessWidget {

  const HomeProductItem(this.title, this.desc, this.imageURL, {super.key});

  final String title;
  final String desc;
  final String imageURL;
  final style1 = const TextStyle(fontSize: 24, color: Colors.red);
  final style2 = const TextStyle(fontSize: 20, color: Colors.red);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10), //设置内边距
      margin: const EdgeInsets.all(8),  //设置外边距
      decoration: BoxDecoration(
        border: Border.all(
          width: 5, //设置边框宽度
          color: Colors.pink //设置边框颜色
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          Text(title, style: style1),
          const SizedBox(height: 8),
          Text(desc, style: style2),
          const SizedBox(height: 8),
          Image.network(imageURL, fit: BoxFit.scaleDown),
        ],
      ),
    );
  }
}