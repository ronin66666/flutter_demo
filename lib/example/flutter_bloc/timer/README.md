

知识点：

- 使用BlocObserver全局观察状态
- 使用BlocProvider提供Bloc
- BlocBuilder响应新的状态，刷新界面
- 使用 Equatable 库， 防止不必要的重建。
- 在Bloc中学习使用`StreamSubscription`
- 使用buildWhen防止不必要的重建

添加依赖

```yaml
name: flutter_timer
description: A new Flutter project.
version: 1.0.0+1
publish_to: none

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  bloc: ^8.1.0
  equatable: ^2.0.3
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.1

dev_dependencies:
  bloc_test: ^9.0.0
  flutter_test:
    sdk: flutter
  mocktail: ^0.3.0

flutter:
  uses-material-design: true
```

项目结构

```
├── lib
|   ├── timer
│   │   ├── bloc
│   │   │   └── timer_bloc.dart
|   |   |   └── timer_event.dart
|   |   |   └── timer_state.dart
│   │   └── view
│   │   |   ├── timer_page.dart
│   │   ├── timer.dart
│   ├── app.dart
│   ├── ticker.dart
│   └── main.dart
├── pubspec.lock
├── pubspec.yaml
```





