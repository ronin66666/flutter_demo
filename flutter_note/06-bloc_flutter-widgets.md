## Bloc Widgets

### BlocBuilder

`blocBuilder`是flutter的一个`widgets`，用于**订阅`Bloc`的状态流**，并在状态发生变化时**重新构建UI**。它接收一个`Bloc`实例和一个`builder`函数，用于构建UI并根据最新的状态更新UI。

如果省略了`bloc`参数，`BlocSelector`将自动使用`BlocProvider`和当前的`BuildContext`进行查找。

```dart
BlocBuilder<BlocA, BlocAState>(
 //...省略bloc
  builder: (context, state) {
    // return widget here based on BlocA's state
  }
)
```

如果您希望提供一个范围**限定为单个`widget`**并且无法通过父 `BlocProvider` 和当前 `BuildContext` 访问的 `bloc`，则仅指定 `bloc`。

```dart
BlocBuilder<BlocA, BlocAState>(
  bloc: blocA, // provide the local bloc instance， 不从父BlockProvider访问bloc
  builder: (context, state) {
    // return widget here based on BlocA's state
  }
)
```

对于**何时调用**构建器函数的细粒度控制，可以提供可选的 `buildWhen`。 `buildWhen` 获取前一个 `bloc` 状态和当前 `bloc` 状态并返回一个布尔值。 如果 `buildWhen` 返回 `true`，将使用`state`， `widget`将重建。 如果 `buildWhen` 返回 `false`，则不会使用`state`，也不会发生重建。

```dart
BlocBuilder<BlocA, BlocAState>(
  buildWhen: (previousState, state) {
    // return true/false to determine whether or not
    // to rebuild the widget with state
  },
  builder: (context, state) {
    // return widget here based on BlocA's state
  }
)
```

### BlocSelector

`BlocSelector`是Flutter的一个小部件，类似于`BlocBuilder`，但允许开发人员根据当前的bloc状态选择一个新值来过滤更新。如果选择的值没有发生变化，则可以防止不必要的重建。需要注意的是，所选的值必须是不可变的，以便`BlocSelector`能够准确地确定是否应该再次调用builder函数。

同样如果省略了bloc参数，`BlocSelector`将自动使用`BlocProvider`和当前的`BuildContext`进行查找。

```dart
BlocSelector<BlocA, BlocAState, SelectedState>(
  selector: (state) {
    // return selected state based on the provided state.
  },
  builder: (context, state) {
    // return widget here based on the selected state.
  },
)
```

### BlocProvider

`BlocProvider`是一个`Flutter`的`widget`，用于在`widget`树中提供`Bloc`实例（通过`BlocProvider.of<T>(context)`）的**依赖注入**。它可以确保在`wideget`树中的所有子`widgets`都可以访问到**相同**的`Bloc`实例。

```dart
BlocProvider(
  create: (BuildContext context) => BlocA(),
  child: ChildA(),
);	
```

默认情况下，`BlocProvider` 通过懒加载创建的，意思是当通过`BlocProvider.of<BlocA>(context)`执行查找时`Create`方法才执行

如果将`lazy`设置为`false`则会强制立即执行

```dart
BlocProvider(
  lazy: false, //如果设置为false，则会立即创建
  create: (BuildContext context) => BlocA(),
  child: ChildA(),
);
```

在某些情况下，`BlockProvider`可以用于将现有的`bloc`提供给`widget`树中的新部分，这种情况最常见的是在需要将现有的`bloc`提供给新的路由时使用，在这种情况下，`BlocProvider`不会自动关闭`bloc`,因为它并没有创建该`bloc`

1. 创建要在路由之间共享的bloc实例

   ```dart
   final blocA = BlocA();
   ```

2. 使用`BlocProvider.value`将现有的bloc实例提供给新的部分widget树

   ```dart
   BlockProvider.value(
   	value: blocA,
   	child: NewRouteWidget(),
   )
   ```

3. 在`NewRouteWidget`中，使用`BlocProvider.of(BlocA)(context)`访问bloc

   ```dart
   final blocA = BlocProvider.of<BlocA>(context);
   ```

   或者使用新的扩展在当前 `BuildContext` 中获取特定类型的 `BlocA` 实例。

   ```dart
   final blocA = context.read<BlocA>();
   ```

### MultiBlocProvider

MultiBlocProvider 是一个 Flutter 小部件，它将多个 BlocProvider 小部件合并为一个。 MultiBlocProvider 提高了可读性并消除了嵌套多个 BlocProvider 的需要。 通过使用 MultiBlocProvider 我们可以从：

```dart
BlocProvider<BlocA>(
  create: (BuildContext context) => BlocA(),
  child: BlocProvider<BlocB>(
    create: (BuildContext context) => BlocB(),
    child: BlocProvider<BlocC>(
      create: (BuildContext context) => BlocC(),
      child: ChildA(),
    )
  )
)
```

改为：

```dart
MultiBlocProvider(
  providers: [
    BlocProvider<BlocA>(
      create: (BuildContext context) => BlocA(),
    ),
    BlocProvider<BlocB>(
      create: (BuildContext context) => BlocB(),
    ),
    BlocProvider<BlocC>(
      create: (BuildContext context) => BlocC(),
    ),
  ],
  child: MyWidget(),
)
```

通过这种方式，`MultiBlocProvider` 可以同时提供多个不同类型的 `bloc` 实例给 `MyWidget` 及其所有的子部件。在 `MyWidget` 及其子部件中，我们可以使用 `BlocProvider.of<BlocA>(context)` 和 `BlocProvider.of<BlocB>(context)` 来获取相应的 `bloc` 实例。

### BlocListener

`BlocListener` 是一个 `Flutter` 小部件，它采用 `BlocWidgetListener` 和一个可选的 `Bloc` 并调用侦听器以响应 `bloc` 中的状态变化。 它应该用于每次状态更改**需要发生一次的功能**，例如导航、显示 SnackBar、显示对话框等...

与 `BlocBuilder` 中的构建器不同，每次状态更改（不包括初始状态）仅调用一次侦听器，并且是一个无效函数。

#### **省略 `bloc` 参数**，

`BlocListener` 将使用 `BlocProvider` 和当前的 `BuildContext` 自动执行查找。

```dart
BlocListener<BlocA, BlocAState>(
  listener: (context, state) {
    // 在状态变化时执行相应操作
    if (state is SuccessState) {
      // 执行成功状态下的操作
    } else if (state is ErrorState) {
      // 执行错误状态下的操作
    }
  },
  child: MyWidget(),
)

```

- `BlocListener<BlocA, BlocAState>`：创建一个 `BlocListener` 小部件的实例，并指定要监听的 `bloc` 类型为 `BlocA`，以及该 `bloc` 所使用的状态类型为 `BlocAState`。
- `listener`：`listener` 参数是一个回调函数，用于定义在状态变化时要执行的操作。它接收两个参数：`context` 和 `state`。在回调函数中，您可以根据不同的 `state` 值执行不同的操作。
- `context`：当前的 `BuildContext` 对象，可用于访问其他小部件或执行导航等操作。
- `state`：当前 `bloc` 的最新状态。根据状态的类型，您可以执行不同的操作。
- `child: MyWidget()`：`BlocListener` 的子部件，即我们希望将状态监听应用到的小部件。

通过这种方式，`BlocListener` 将会监听 `BlocA` 的状态变化。每当 `BlocA` 的状态发生变化时，`listener` 中定义的回调函数将会被触发，并根据不同的状态执行相应的操作。

需要注意的是，`BlocListener` 是一个无需构建界面的小部件，它的主要目的是在特定的 `bloc` 状态变化时执行副作用操作。如果您需要在界面构建时根据 `bloc` 的状态来更新界面，可以考虑使用 `BlocBuilder` 小部件。

#### 使用指定的`bloc`

```dart
BlocListener<BlocA, BlocAState>(
  bloc: blocA,
  listener: (context, state) {
    // do stuff here based on BlocA's state
  },
  child: Container()
)
```

#### `listenWhen`

对于何时调用侦听器函数的细粒度控制，可以提供可选的 `listenWhen`。 `listenWhen` 获取前一个 `bloc` 状态和当前 `bloc` 状态并返回一个布尔值。 如果 `listenWhen` 返回 `true`，将调用带有状态的侦听器。 如果 `listenWhen` 返回 `false`，则不会调用带有状态的侦听器。

```dart
BlocListener<BlocA, BlocAState>(
  listenWhen: (previousState, state) {
    // return true/false to determine whether or not
    // to call listener with state
  },
  listener: (context, state) {
    // do stuff here based on BlocA's state
  },
  child: Container(),
)
```



#### `BlocListener`与`BlocBuilder` 的区别

`BlocListener` 和 `BlocBuilder` 是 `bloc` 库中用于处理 `bloc` 状态变化的两个不同的小部件，它们之间有以下区别：

1. **目的不同**：`BlocListener` 的主要目的是在特定 `bloc` 的状态变化时执行副作用操作，例如显示弹出窗口、导航到其他页面、更新界面等。它通常用于处理一次性的操作，而不是用于构建界面。`BlocBuilder` 的主要目的是在 `bloc` 的状态变化时重新构建界面，并根据不同的状态值构建不同的界面。
2. **返回值不同**：`BlocListener` 的 `linstener` 回调函数不返回任何小部件，因为其主要任务是执行副作用操作。它通过 `listener` 回调函数来处理状态变化。相反，`BlocBuilder` 的 `builder` 回调函数需要返回一个小部件，用于构建界面。
3. **更新频率不同**：`BlocListener` 只会在状态变化时执行一次副作用操作，并不会根据状态变化重新构建界面。它适用于处理一次性操作或具有副作用的操作。而 `BlocBuilder` 会在每次状态变化时重新构建界面，并根据不同的状态值动态更新界面。它适用于需要根据 `bloc` 的状态来更新界面的场景。
4. **使用场景不同**：`BlocListener` 适用于需要监听 `bloc` 状态并执行相应操作的场景，如显示通知、弹出对话框、执行导航等。它通常与具有副作用的操作结合使用。`BlocBuilder` 适用于需要根据 `bloc` 的状态来构建动态界面的场景，根据不同的状态值构建不同的界面，如显示不同的加载状态、错误状态或成功状态。

虽然 `BlocListener` 和 `BlocBuilder` 有一些不同之处，但它们也可以在一起使用，以实现更复杂的逻辑。例如，可以在 `BlocListener` 中执行副作用操作，然后在操作完成后使用 `BlocBuilder` 更新界面。根据具体的需求，可以灵活地选择使用适当的小部件或它们的组合。

### MultiBlocListener

将`BlockListener`改造为`MultiBlocListener`

```dart
BlocListener<BlocA, BlocAState>(
  listener: (context, state) {},
  child: BlocListener<BlocB, BlocBState>(
    listener: (context, state) {},
    child: BlocListener<BlocC, BlocCState>(
      listener: (context, state) {},
      child: ChildA(),
    ),
  ),
)
```

to：

```dart
MultiBlocListener(
  listeners: [
    BlocListener<BlocA, BlocAState>(
      listener: (context, state) {},
    ),
    BlocListener<BlocB, BlocBState>(
      listener: (context, state) {},
    ),
    BlocListener<BlocC, BlocCState>(
      listener: (context, state) {},
    ),
  ],
  child: ChildA(),
)
```

### BlocConsumer

`BlocConsumer` 公开了一个构建器和一个监听器，以便对新状态做出反应。它结合了 `BlocBuilder` 和 `BlocListener` 的功能，可以同时处理 `bloc` 的**状态变化**和**执行副作用操作**。 `BlocConsumer` 只应在需要重建 UI 和对 bloc 中的状态更改执行其他反应时使用。 `BlocConsumer` 采用必需的 `BlocWidgetBuilder` 和 `BlocWidgetListener` 以及可选的 `bloc`、`BlocBuilderCondition` 和 `BlocListenerCondition`。

`BlocConsumer` 提供了以下功能：

1. **监听状态变化**：`BlocConsumer` 会监听指定的 `bloc` 的状态变化，并根据不同的状态值执行相应的操作。
2. **构建界面**：根据 `bloc` 的状态值，`BlocConsumer` 可以构建不同的界面。它使用 `builder` 回调函数返回小部件，并在每次状态变化时重新构建界面。
3. **执行副作用操作**：`BlocConsumer` 可以在特定的 `bloc` 状态变化时执行副作用操作。它使用 `listener` 回调函数来处理状态变化，例如显示通知、导航到其他页面、执行网络请求等。

#### 省略 bloc 参数

如果省略 bloc 参数，BlocConsumer 将使用 BlocProvider 和当前的 BuildContext 自动执行查找。

```
BlocConsumer<BlocA, BlocAState>(
  listener: (context, state) {
    // 在状态变化时执行副作用操作
    if (state is SuccessState) {
      // 执行成功状态下的操作
    } else if (state is ErrorState) {
      // 执行错误状态下的操作
    }
  },
  builder: (context, state) {
    // 根据状态构建界面
    return Text('Current state: $state');
  },
)
```

#### listenWhen和buildWhen

```dart
BlocConsumer<BlocA, BlocAState>(
  listenWhen: (previous, current) {
    // return true/false to determine whether or not
    // to invoke listener with state
  },
  listener: (context, state) {
    // do stuff here based on BlocA's state
  },
  buildWhen: (previous, current) {
    // return true/false to determine whether or not
    // to rebuild the widget with state
  },
  builder: (context, state) {
    // return widget here based on BlocA's state
  }
)
```

### RepositoryProvider

RepositoryProvider 是一个 Flutter 小部件，它通过 RepositoryProvider.of<T>(context) 为其子组件提供存储库。 它用作依赖注入 (DI) 小部件，以便可以将存储库的**单个实例提供给子树中的多个小部件**。 BlocProvider 应该用于提供 bloc，而 RepositoryProvider 应该只用于存储库。

```dart
RepositoryProvider<RepositoryA>(
  create: (context) {
    // 创建 RepositoryA 的实例
    return RepositoryA();
  },
  child: MyApp(),
)
```

在子部件中获取`RepositoryA`实例

```dart
// 使用扩展获取
final repository = context.read<RepositoryA>();

// 不使用扩展
final repository = RepositoryProvider.of<RepositoryA>(context)
```

### MultiRepositoryProvider

将多个嵌套`RespositoryProvider`改为`MultiRespositoryProvider`

```dart
RepositoryProvider<RepositoryA>(
  create: (context) => RepositoryA(),
  child: RepositoryProvider<RepositoryB>(
    create: (context) => RepositoryB(),
    child: RepositoryProvider<RepositoryC>(
      create: (context) => RepositoryC(),
      child: ChildA(),
    )
  )
)
```

to：

```dart
MultiRepositoryProvider(
  providers: [
    RepositoryProvider<RepositoryA>(
      create: (context) => RepositoryA(),
    ),
    RepositoryProvider<RepositoryB>(
      create: (context) => RepositoryB(),
    ),
    RepositoryProvider<RepositoryC>(
      create: (context) => RepositoryC(),
    ),
  ],
  child: ChildA(),
)
```



## Extsentsion Methods

### **context.read<T>()**

`context.read<T>()`，  方法用于获取特定类型 `T` 的`Bloc`实例，而不会订阅状态的变化。相当于`BlocProvider.of<T>(context, listen: false)`

```dart
onPressed() {
  context.read<CounterBloc>().add(CounterIncrementPressed()),
}
```

使用场景：当只需要获取当前状态而不需要订阅状态变化时，可以使用 `context.read<T>()`。例如，获取一个全局状态、获取一个不会发生变化的静态数据等。

### **context.watch<T>()**

功能：`context.watch<T>()` 方法用于订阅特定类型 `T` 的状态变化，并在状态发生变化时触发小部件的重建。

使用 BlocBuilder 不使用 context.watch 来明确范围重建。

```dart
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      body: BlocBuilder<MyBloc, MyState>(
        builder: (context, state) {
          // Whenever the state changes, only the Text is rebuilt.
          return Text(state.value);
        },
      ),
    ),
  );
}
```

或者，使用 Builder 来确定重建范围。

```dart
@override
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) {
          // Whenever the state changes, only the Text is rebuilt.
          final state = context.watch<MyBloc>().state;
          return Text(state.value);
        },
      ),
    ),
  );
}
```

使用`builder`和`context.watch()` 作为`MultiBlocBuilder`

```dart
Builder(
  builder: (context) {
    final stateA = context.watch<BlocA>().state;
    final stateB = context.watch<BlocB>().state;
    final stateC = context.watch<BlocC>().state;

    // return a Widget which depends on the state of BlocA, BlocB, and BlocC
  }
);
```

使用场景：当希望在状态发生变化时更新小部件，并且只需要订阅状态变化而不需要选择特定的状态属性时，可以使用 `context.watch<T>()`。例如，根据全局状态更新小部件的样式、根据网络请求状态显示加载指示器等。

### **context.select<T>()**：

`context.select<T>()` 方法用于选择特定类型 `T` 的状态属性，并在状态属性发生变化时触发小部件的重建。

使用场景：当只需要监听状态特定属性的变化时，可以使用 `context.select<T>()`。该方法接受一个回调函数，该函数接收 `T` 类型的状态并返回一个选择的属性。只有选择的属性发生变化时，相关的小部件才会被重建。这对于避免不必要的小部件重建以提高性能很有用。

```dart
Widget build(BuildContext context) {
  final name = context.select((ProfileBloc bloc) => bloc.state.name);
  return Text(name);
}
```

使用BlocSelector 代替 context.select 指定重建范围

```dart
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      body: BlocSelector<ProfileBloc, ProfileState, String>(
        selector: (state) => state.name,
        builder: (context, name) {
          // Whenever the state.name changes, only the Text is rebuilt.
          return Text(name);
        },
      ),
    ),
  );
}
```

或者使用builder开重建范围

```dart
@override
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) {
          // Whenever state.name changes, only the Text is rebuilt.
          final name = context.select((ProfileBloc bloc) => bloc.state.name);
          return Text(name);
        },
      ),
    ),
  );
}
```

