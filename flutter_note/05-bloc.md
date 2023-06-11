Bloc 官方文档：https://bloclibrary.dev/#/

## Stream

stream 可在 dart的官方文档中查看：*Stream官方文档 https://dart.dev/tutorials/language/streams*

简单理解：Stream比作管道，水比异步数据。

创建Stream

```dart
Stream<int> countStream(int max) async* {
  for (int i = 0; i < max; i++) {
    yield i; // 向Stream中添加数据
  }
}
```

读取流中的数据，并将数据求和

```dart
Future<int> sumStream(Stream<int> stream) async {
  int sum = 0;
  await for (int value in stream) { //从stream中取出数据
    sum += value;
  }
  return sum;
}
```

函数调用

```dart
void main(List<String> args) async {
  //初始化一个Stream 
   Stream<int> stream = countStream(10);
   //计算Stream中的数据总和
   int sum = await sumStream(stream);
   print(sum); //45
}

```

## [Cubit](https://bloclibrary.dev/#/coreconcepts?id=cubit)

Cubit继承BlocBase，并且可以通过扩展来管理任何类型的State

![cubit_architecture_full](https://bloclibrary.dev/assets/cubit_architecture_full.png)



可以调用Cubit的暴露的方法来追踪state的改变

State是 Cubit 的输出，代表应用程序状态的一部分。 可以通知 UI 组件状态并根据当前状态重绘它们自己的部分。

### 创建Cubit

```dart
// 1.创建一个CounterCubit类, 继承Cubit, 并指定管理的状态类型为int
class CounterCubit extends Cubit<int> {
  //初始化状态
  CounterCubit({int? initialState}) : super(initialState ?? 0);

  //2.定义两个方法, 用于改变状态
  void increment() => emit(state + 1); //通过emit输出一个新的状态

  void decrement() => emit(state - 1);
}
```

### Basic 使用

```dart
void main(List<String> args) {
  final cubit = CounterCubit();
  print(cubit.state); //0
  cubit.increment();
  print(cubit.state); //1
  cubit.decrement();
  print(cubit.state); //0
}
```

### Stream 使用

Cubit暴露了一个Stream，可以让我们接收实时的状态更新

```dart
Future<void> main(List<String> args) async {
  final cubit = CounterCubit();
  final subscription = cubit.stream.listen(print); //监听状态变化, 并打印
  cubit.increment();  //1
  cubit.decrement();  //0
  await Future<void>.delayed(Duration.zero);
  await subscription.cancel(); //取消监听，不再订阅新的状态
  cubit.decrement();  //取消后，状态再次发生改变，但是不会再打印出新的状态

  await cubit.close();
  cubit.decrement();  //报错，Bad state: Cannot emit new states after calling close
}

```

### bserving a Cubit

Cubit复写onChange方法，可以观察到所有的状态改变，可以在状态改变时做一些事

```dart
class CounterCubit extends Cubit<int> {

  CounterCubit({int? initialState}) : super(initialState ?? 0);
  void increment() => emit(state + 1); 
  void decrement() => emit(state - 1);

  // 复写onChange方法, 用于监听所有的状态变化
  @override
  void onChange(Change<int> change) {
    super.onChange(change);
    print(change);
  }
}

void main(List<String> args) {
  CounterCubit()
    ..increment() //Change { currentState: 0, nextState: 1 }
    ..close();
}
```

#### BlocObserver

`BlocObserver` 是一个观察者模式的类，用于监听 `Bloc` 和 `Cubit` 的状态变化。`BlocObserver` 提供了一组回调方法，可以在特定事件发生时被调用，以便你可以在这些事件发生时执行自定义的逻辑。以便你可以在这些事件发生时执行自定义的逻辑。

要监听状态变化，你需要创建一个自定义的 `BlocObserver` 类，并重写其中的回调方法来处理特定的事件。以下是一些常用的回调方法：

1. `onEvent`：在触发事件时调用，可以用于记录或处理事件。
2. `onTransition`：在状态转换时调用，可以用于记录或处理状态转换。
3. `onChange`：在状态发生变化时调用，可以用于记录或处理状态变化。
4. `onError`：在发生错误时调用，可以用于处理错误或进行异常处理。

这些回调方法提供了灵活的机制，让你能够观察和响应 `Bloc` 和 `Cubit` 的状态变化。你可以根据需要选择重写其中的方法，并在方法中编写自定义的逻辑。

使用 bloc 库的一个额外好处是我们可以**在一个地方访问所有更改**，即使在这个应用程序中我们只有一个Cubit，在大型应用程序中，**让许多 Cubits 管理应用程序状态的不同部分**是相当普遍的。

如果我们希望能够对所有更改做出响应，我们可以简单地创建我们自己的 BlocObserver。

```dart
class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }
}

void main(List<String> args) {
  Bloc.observer = SimpleBlocObserver();
  CounterCubit()
    ..increment()
    ..close();
}
```

输出

```
CounterCubit Change { currentState: 0, nextState: 1 }
Change { currentState: 0, nextState: 1 }
```

会先通知`BlockObserver`中的`onChange`再通知`Cubit`中的`onChange`，但是错误回调`onError`则是先走`Cubit`中的错误

## Bloc

`Bloc` 是一个更高级的类，它依赖于事件而不是函数来触发状态变化。 `Bloc` 还扩展了 `BlocBase`，这意味着它具有与 `Cubit` 类似的公共 `API`。 但是，`Bloc` 不是在 `Bloc` 上调用函数并直接发出新`state`，而是接收`events`并将输入`events`转换为输出`states`。

![bloc_architecture_full](https://bloclibrary.dev/assets/bloc_architecture_full.png)

### 创建 Bloc

```dart
import 'package:bloc/bloc.dart';

abstract class CounterEvent {}

// 增加事件
class CounterIncrementPressed extends CounterEvent {}
// 减少事件
class CounterDecrementPressed extends CounterEvent {}

class CounterBloc extends Bloc<CounterEvent, int> {

  CounterBloc({int? initialState}) : super(initialState ?? 0) {

    on<CounterIncrementPressed>((event, emit) {
      // 处理 `CounterIncrementPressed` event
      emit(state + 1);
    });
    
    on<CounterDecrementPressed>((event, emit) {
      
       emit(state - 1);
    });
  }
}


Future<void> main(List<String> args) async {
  final bloc = CounterBloc();
  final subscription = bloc.stream.listen(print);
  bloc.add(CounterIncrementPressed()); //发送事件，print打印1
  bloc.add(CounterDecrementPressed()); 
  await Future<void>.delayed(Duration.zero);
  await subscription.cancel();
  await bloc.close();
}
```

### Observing a Bloc

```dart
abstract class CounterEvent {}
class CounterIncrementPressed extends CounterEvent {}
class CounterDecrementPressed extends CounterEvent {}

class CounterBloc extends Bloc<CounterEvent, int> {

  CounterBloc({int? initialState}) : super(initialState ?? 0) {

    on<CounterIncrementPressed>((event, emit) {
      // 处理 `CounterIncrementPressed` event
      emit(state + 1);
    });
    
    on<CounterDecrementPressed>((event, emit) {
      
       emit(state - 1);
    });
  }

  @override
  void onChange(Change<int> change) {
    // TODO: implement onChange
    super.onChange(change);
    print(change);
  }
  
  @override
  void onTransition(Transition<CounterEvent, int> transition) {
    super.onTransition(transition);
    // 在状态转换时调用，可以用于记录或处理状态转换。
    print(transition);
  }
}

void main(List<String> args) {
  CounterBloc()
    ..add(CounterIncrementPressed())
    ..close();
}
```

#### BlocObserver

和之前一样，我们可以在自定义 BlocObserver 中覆盖 onTransition 以观察从一个地方发生的所有转换。

```dart

class CounterBloc extends Bloc<CounterEvent, int> {
	// ...
  CounterBloc() : super(0) {
    on<CounterIncrementPressed>((event, emit) {
      // addError(Exception('increment error!'), StackTrace.current); 抛出错误
      emit(state + 1);
    });
  }
  // onEvent 事件, bloc中特有的回调
  @override
  void onEvent(CounterEvent event) {
    super.onEvent(event);
    print(event);
  }
   @override
  void onError(Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(error, stackTrace);
  }
}

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    // TODO: implement onChange
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print('${bloc.runtimeType} $transition');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print('${bloc.runtimeType} $event');
  }
}

void main(List<String> args) {
  Bloc.observer = SimpleBlocObserver();
  CounterBloc()
    ..add(CounterIncrementPressed())
    ..close();
}
```

输出

```
CounterBloc Instance of 'CounterIncrementPressed' Instance of 'CounterIncrementPressed'
CounterBloc Transition { currentState: 0, event: Instance of 'CounterIncrementPressed', nextState: 1 }
Transition { currentState: 0, event: Instance of 'CounterIncrementPressed', nextState: 1 }
CounterBloc Change { currentState: 0, nextState: 1 }
Change { currentState: 0, nextState: 1 }
```

## Cubit vs. Bloc

在 Flutter 中，Cubit 和 Bloc 都是用于状态管理的库，它们都是基于 BLoC 设计模式的实现。虽然它们的目标是相同的，但在某些方面有一些区别。

1. 简单性和复杂性：Cubit 是一个更简单的状态管理解决方案，它专注于处理简单的状态。它没有复杂的事件和转换机制，更适合用于处理简单的场景。Bloc 则提供了更多的功能和灵活性，它使用事件来触发状态的转换，适用于更复杂的业务逻辑和状态管理。

2. 事件和状态：Cubit 使用状态作为其唯一的输出，而 Bloc 使用事件来触发状态的转换。Cubit 只有一个输出流，而 Bloc 有两个流：一个用于事件输入，一个用于状态输出。这种区别导致在使用上有些微妙的差异。

3. 异步操作：Bloc 内置了异步操作的支持，可以在事件处理过程中执行异步操作，例如网络请求或数据库查询。Bloc 提供了对 Futures 和 Streams 的良好集成，使得处理异步操作变得更加方便。Cubit 则更加专注于同步操作，不直接支持异步操作。

4. 状态订阅：在 Bloc 中，可以使用 StreamBuilder 或 BlocBuilder 来订阅状态的变化，并根据状态的变化来更新用户界面。Cubit 则更适合用于手动管理状态的订阅和更新。

5. 额外功能：Bloc 提供了一些额外的功能，如中间件（Middleware）和 BlocDelegate，用于在 Bloc 的事件和状态转换过程中执行自定义逻辑。这使得 Bloc 可以实现更高级的功能，如日志记录、异常处理等。

综上所述，Cubit 更适合简单的状态管理，而 Bloc 则更适合复杂的业务逻辑和状态管理。选择使用哪个库取决于你的项目需求和复杂度，以及你对状态管理的偏好和习惯。无论是使用 Cubit 还是 Bloc，它们都提供了一种结构化和可测试的方式来管理应用程序的状态。
