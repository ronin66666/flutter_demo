## StatelessWidget、StatefulWidget、生命周期

首先定义到Widget中的数据都是不可变的，必须定义为final、或者const

- 这次因为Flutter在设计的时候就决定了一旦Widget中展示的数据发生变化，就重新构建整个Widget；
- Flutter通过一些机制来限定定义到Widget中的`成员变量`必须是`final`的；

**Flutter如何做到我们在开发中定义到Widget中的数据一定是final的呢？**

```
@immutable
abstract class Widget extends DiagnosticableTree {
	// ...省略代码
}
```

官方有对@immutable进行说明：

- **来源：** https://api.flutter.dev/flutter/meta/immutable-constant.html
- **说明：** 被@immutable注解标明的类或者子类都必须是不可变的

**结论：** 定义到Widget中的数据一定是不可变的，需要使用final来修饰

### StatelessWidget

StatelessWidget通常是一些没有状态（State，也可以理解成data）需要维护的Widget：

- 它们的数据通常是直接写死（放在Widget中的数据，必须被定义为final，为什么呢？我在下一个章节讲解StatefulWidget会讲到）；
- 从parent widget中传入的而且一旦传入就不可以修改；
- 从InheritedWidget获取来使用的数据（这个放到后面会讲解）；

**build方法的解析：**

- Flutter在拿到我们自己创建的StatelessWidget时，就会执行它的build方法；
- 我们需要在build方法中告诉Flutter，我们的Widget希望渲染什么元素，比如一个Text Widget；
- StatelessWidget没办法主动去执行build方法，当我们使用的数据发生改变时，build方法会被重新执行；

**build方法什么情况下被执行呢？：**

- 1、当我们的StatelessWidget第一次被插入到Widget树中时（也就是第一次被创建时）；
- 2、当我们的父Widget（parent widget）发生改变时，子Widget会被重新构建；
- 3、如果我们的Widget依赖InheritedWidget的一些数据，InheritedWidget数据发生改变时；

### StatefulWidget

因为Widget中的数据是不可变的，提供了一个StatefulWidget可用来维护状态，需要保存状态，并且可能出现状态改变的Widget，可以使用`StatefulWidget`

####  如何存储Widget状态？

既然Widget是不可变，那么StatefulWidget如何来存储可变的状态呢？

- StatelessWidget无所谓，因为它里面的数据通常是直接定义完后就不修改的。
- 但StatefulWidget需要有状态（可以理解成变量）的改变，这如何做到呢？

Flutter将StatefulWidget设计成了两个类：

- 也就是你创建StatefulWidget时必须创建两个类：
- 一个类继承自StatefulWidget，作为Widget树的一部分；
- 一个类继承自State，用于记录StatefulWidget会变化的状态，并且根据状态的变化，构建出新的Widget；

创建一个StatefulWidget，我们通常会按照如下格式来做：

- 当Flutter在构建Widget Tree时，会获取`State的实例`，并且它调用build方法去获取StatefulWidget希望构建的Widget；
- 那么，我们就可以将需要保存的状态保存在MyState中，因为它是可变的；

```dart

class MyStatefulWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // 将创建的State返回
    return MyState();
  }
}

class MyState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return <构建自己的Widget>;
  }
}
```

### StatefulWidget生命周期

Flutter小部件的生命周期：

- StatelessWidget可以由父Widget直接传入值，调用build方法来构建，整个过程非常简单；
- 而StatefulWidget需要通过State来管理其数据，并且还要监控状态的改变决定是否重新build整个Widget；
- 所以，我们主要讨论StatefulWidget的生命周期，也就是它**从创建到销毁的整个过程**；

StatefulWidget有哪些生命周期的回调呢？它们分别在什么情况下执行呢？

- 在下图中，灰色部分的内容是Flutter内部操作的，我们并不需要手动去设置它们；
- 白色部分表示我们可以去监听到或者可以手动调用的方法；

![640(5)](./img/640(5).png)

首先，执行**StatefulWidget**中相关的方法：

- 执行StatefulWidget的构造函数（Constructor）来创建出StatefulWidget；
- 执行StatefulWidget的createState方法，来创建一个维护StatefulWidget的State对象；

其次，调用createState创建State对象时，**执行State类的相关方法**：

1. 执行State类的构造方法（Constructor）来创建State对象；
2. 执行initState，我们通常会在这个方法中执行一些数据初始化的操作，或者也可能会发送网络请求；
   - 注意：这个方法是重写父类的方法，必须调用super，因为父类中会进行一些其他操作；
   - 并且如果你阅读源码，你会发现这里有一个注解（annotation）：@mustCallSuper
3. 执行didChangeDependencies方法，这个方法在两种情况下会调用
   - 情况一：调用initState会调用；
   - 情况二：从其他对象中依赖一些数据发生改变时，比如前面我们提到的InheritedWidget（这个后面会讲到）；
4. Flutter执行build方法，来看一下我们当前的Widget需要渲染哪些Widget；
5. 当前的Widget不再使用时，会调用dispose进行销毁；
6. 手动调用setState方法，会根据最新的状态（数据）来重新调用build方法，构建对应的Widgets；
7. 执行didUpdateWidget方法是在当父Widget触发重建（rebuild）时，系统会调用didUpdateWidget方法；

```dart

import 'package:flutter/material.dart';

main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("HelloWorld"),
        ),
        body: HomeBody(),
      ),
    );
  }
}


class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("HomeBody build");
    return MyCounterWidget();
  }
}


class MyCounterWidget extends StatefulWidget {
  
  MyCounterWidget() {
    print("执行了MyCounterWidget的构造方法");
  }
  
  @override
  State<StatefulWidget> createState() {
    print("执行了MyCounterWidget的createState方法");
    // 将创建的State返回
    return MyCounterState();
  }
}

class MyCounterState extends State<MyCounterWidget> {
  int counter = 0;
  
  MyCounterState() {
    print("执行MyCounterState的构造方法");
  }

  @override
  void initState() {
    super.initState();
    print("执行MyCounterState的init方法");
  }
  
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("执行MyCounterState的didChangeDependencies方法");
  }

  @override
  Widget build(BuildContext context) {
    print("执行执行MyCounterState的build方法");
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                color: Colors.redAccent,
                child: Text("+1", style: TextStyle(fontSize: 18, color: Colors.white),),
                onPressed: () {
                  setState(() {
                    counter++;
                  });
                },
              ),
              RaisedButton(
                color: Colors.orangeAccent,
                child: Text("-1", style: TextStyle(fontSize: 18, color: Colors.white),),
                onPressed: () {
                  setState(() {
                    counter--;
                  });
                },
              )
            ],
          ),
          Text("当前计数：$counter", style: TextStyle(fontSize: 30),)
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(MyCounterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("执行MyCounterState的didUpdateWidget方法");
  }

  @override
  void dispose() {
    super.dispose();
    print("执行MyCounterState的dispose方法");
  }
}
```

####  生命周期的复杂版

1. mounted是State内部设置的一个属性，事实上我们不了解它也可以，但是如果你想深入了解它，会对State的机制理解更加清晰；
   - 很多资料没有提到这个属性，是内部设置的，不需要我们手动进行修改；
2. dirty state的含义是脏的State
   - 它实际是通过一个Element的属性来标记的；
   - 将它标记为dirty会等待下一次的重绘检查，强制调用build方法来构建我们的Widget；
   - （有机会我专门写一篇关于StatelessWidget和StatefulWidget的区别，讲解一些它们开发中的选择问题）；
3. clean state的含义是干净的State
   - 它表示当前build出来的Widget，下一次重绘检查时不需要重新build