

项目结构

使用功能驱动的项目结构

```
├── lib
│   ├── app.dart
│   ├── counter
│   │   ├── counter.dart
│   │   ├── cubit
│   │   │   └── counter_cubit.dart
│   │   └── view
│   │       ├── counter_page.dart
│   │       └── counter_view.dart
│   ├── counter_observer.dart
│   └── main.dart
├── pubspec.lock
├── pubspec.yaml
```

相关知识点：

- 使用`BlocObserver`观察状态的改变
- `BlocProvider`，提供bloc
- `BlocProvider`在有新的状态时构建widget
- 使用Cubit来管理处理业务逻辑（事件和状态的交互）
- 使用`context.read`方法来触发事件



