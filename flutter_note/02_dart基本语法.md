动态类型（dynamic）、Object、范型的区别

1. dynamic： dynamic 是 Dart 中的一种特殊类型，它表示一个动态类型，即在运行时可以具有不同的类型。使用 dynamic 声明的变量可以接受任何类型的值，而且不会进行静态类型检查。dynamic 类型的变量可以调用任何方法、访问任何属性，但可能会导致类型错误和运行时异常。dynamic 主要用于与外部动态类型的代码进行交互，如 JSON 解析、动态插件等。
2. Object： Object 是 Dart 中的根类，它是所有类的基类。所有的对象都可以被视为 Object 类型，可以接受任何类型的值。Object 类型的变量可以调用一些通用的方法，如 toString()、hashCode() 等，但不能直接调用特定类型的方法和属性。Object 类型通常用于需要在不同类型之间进行通用操作的场景，如集合中的元素类型不确定时。
3. 范型（Generics）： 范型是 Dart 中的一种类型参数化机制，允许在类、函数或方法中使用参数化的类型。通过范型，可以在声明时指定类型的占位符，然后在实际使用时填充具体的类型。范型提供了类型安全和代码重用的好处，可以在编译时进行类型检查，避免类型错误，并提供更具表现力的代码。范型常用于集合类、异步操作、函数式编程等场景，可以更灵活地处理不同类型的数据。

总结一下使用场景：

- dynamic：主要用于与外部动态类型的代码进行交互，如 JSON 解析、动态插件等。
- Object：主要用于需要在不同类型之间进行通用操作的场景，如集合中的元素类型不确定时。
- 范型（Generics）：主要用于在类、函数或方法中使用参数化的类型，提供类型安全和代码重用的好处。常用于集合类、异步操作、函数式编程等场景。

需要注意的是，在使用 dynamic 和 Object 类型时，由于缺乏静态类型检查，可能会导致类型错误和运行时异常。而范型可以提供更好的类型安全性，并且在编译时能够进行类型检查。因此，在可预知类型的情况下，范型通常是更好的选择。



**dart中没有关键字定义接口，默认所有class都是隐式接口**



### 函数

dart中没有函数重载

只有可选参数才有默认值

### 函数是一等公民

可以将函数赋值给一个变量，也可以将函数作为参数传递给另外的函数

## 面向对象

### 类的构造函数

### 类的初始化列表

### 重定向构造函数

### 常量构造函数

目的多个地方初始化时，构造同一个对象（初始化时，初始化的值必须都相同）

### 工厂构造函数

### setter和getter

### 继承

### 抽象类

```dart
abstract class Shape {
	int getArea()
}
```

可以只有函数声明没有实现，

如果子类继承与抽象类，则子类必须实现抽象类中的抽象方法（没有函数实现的方法）

抽象类不能实例化，但是可以通过工厂构造函数实例化，比如Map类型

```dart
  final map = Map();
  print(map.runtimeType); // _InternalLinkedHashMap<dynamic, dynamic>
```

Map内部工厂构造
`external factory Map();` 

没有实现体，使用了external，将方法声明和实现分离，具体实现在源码中vm中实现的，好处就是可以根据不同的平台进行不同的实现

在源码中可以找到该实现

```dart
@patch
class Map<K,V>{
	
	@patch //使用@patch注解来补充实现，之前external修饰的方法
	factory Map() => new LinkedHashMap<K, V>();
}
```

### 隐式接口

dart中没有关键字定义接口，默认情况下所有的类都是隐式接口，当一个类当作接口时，实现类都必须全部重新实现接口的方法

### 混入的使用mixin

```dart

mixin Runner {
  void run() {
    print("run");
  }
}

mixin Flyer {
  void fly() {
    print("fly");
  }
  void run() {
    print("fly run");
  }
}

// flyer 中的run会覆盖Runner中的run方法，最终取决于靠后的实现
class SuperMan extends Person5 with Runner, Flyer {
  // @override
  // void run() {
  //   print("superman run");
  // }
}
```













