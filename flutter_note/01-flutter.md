## Dart

### Dart语言的特性？

1. **静态类型系统**: Dart是一种静态类型语言，它在编译时检查类型，可以提供更好的代码分析和错误检查，有助于代码质量的提高。
2. **扩展方法（Extension methods）**: Dart支持扩展方法，允许我们向已有的类添加新的方法，而无需修改原始类的源代码。
3. **混入（Mixins）**: Dart支持混入，允许一个类**通过继承多个`mixin`来获得多个类的功能**，从而实现代码的重用和组合。
4. **可选命名参数和可选位置参数**: Dart支持可选的命名参数和位置参数，可以让函数调用更灵活。
5. dart 是**单线程**的，通过**单线程+事件循环** 来处理耗时操作

### `const 、final`的区别

`final`和`const`都是用于定义常量的。

区别：

`const`定义常量时值时**编译时**就确定的，`const`作用构造函数时，可以共享对象，提高新能。

`final`值**运行时**确定，可以动态获取，比如可以赋值一个函数

### `Dart`的异步

`Dart`是单线程的。通过 单线程+事件循环 来完成耗时操作的， 调用执行之后，**当前线程不会停止执行**，只需要过一段时间来检查一下有没有结果返回即可。

事件循环：就是将需要处理的一系列事件（包括点击事件、IO事件、网络事件）放在一个事件队列（Event Queue）中，不断的从事件队列（Event Queue）中取出事件，并执行其对应需要执行的代码块，直到事件队列清空位置。

 **多核CPU的利用Isolate**：每个 Isolate 都有自己的 Event Loop 与 Queue，每个Isolate在Dart中都有一个独立的线程。Isolate是Dart中用于实现并发的基本单位，它相当于一个独立的执行线程，拥有自己的内存空间和执行堆栈。不同的Isolate之间是相互独立的，它们不会共享内存，因此在多Isolate的环境中，数据的共享需要通过消息传递来实现。

### Bloc 状态管理

核心原理：通过使用Streams（流）或Cubit来管理应用程序的状态，并通过事件（Events）和状态（States）之间的转换来实现数据的响应式更新。将业务逻辑和UI层分离。它特别适合在中大型应用中使用，能够帮助保持代码的可维护性和可测试性。

`rxdart`：一个强大的**响应式编程**库，提供了**Observables**和**操作**符等功能，用于处理**异步数据流**和**响应式编程**。

## Flutter 

Flutter利用Skia绘图引擎，直接通过CPG、GPU进行绘制，不需要依赖任何原生的控件，所以flutter在某些Android操作系统上甚至还要高于原生（因为原生Android中的skia必须随着操作系统进行更新，而flutter SDK总是保持最新的）

### Widget

**Flutter中万物皆Widget**；整个应用程序中`所看到的内容`几乎都是Widget，

- **statelessWidget：** 没有状态改变的Widget，通常这种Widget仅仅是做一些展示工作而已；当该widget第一次被插入到widget树或者父类状态改变时，build会重新渲染界面。
- **StatefulWidget：** 需要保存状态，并且可能出现状态改变的Widget；
- **定义到Widget中的数据一定是final**，因为@immutable注解。

### Widget分类

- 基础Widget：最基本的Widget，用于构建UI的基础组件，比如文本、按钮、图片、表单等
- 布局Widget： 用于进行布局和组织其他Widget的容器
  - 单子布局：Align、Center、Padding、Container（类似View）等
  - 多子布局：常用的多子布局组件是Row、Column、Stack（层叠），
- 滚动Widget： 用于实现可滚动的界面，例如ListView、GridView、ScrollView、Slivers（统一管理多个滚动视图）等。
- 手势：用于处理手势操作，例如点击、拖动、缩放等。

### 生命周期

- StatelessWidget可以由父Widget直接传入值，调用build方法来构建，整个过程非常简单；
- 而StatefulWidget需要通过State来管理其数据，并且还要监控状态的改变决定是否重新build整个Widget；

StatefulWidget本身由两个类组成的：`StatefulWidget`和`State`

1. 执行**StatefulWidget**中相关的方法：构造函数、`createState`
2. `createState`创建`State`对象时，执行State类的相关方法
   1. 执行State类的构造方法（Constructor）来创建State对象；
   2. 执行`initState`，我们通常会在这个方法中**执行一些数据初始化的操作**，或者也可能会发送网络请求；
3. 执行`didChangeDependencies`方法，这个方法在两种情况下会调用
   1. 情况一：调用initState会调用；
   2. 情况二：从其他对象中依赖一些数据发生改变时，InheritedWidget
4. 执行`build`方法，来看一下我们当前的Widget需要渲染哪些Widget；
5. 当前的Widget不再使用时，会调用**dispose**进行销毁；
6. 手动调用`setState`方法，会根据最新的状态（数据）来重新调用`build`方法，构建对应的Widgets；
7. 执行`didUpdateWidget`方法是在当父Widget触发重建（rebuild）时，系统会调用`didUpdateWidget`方法

### Widget-Element-RenderObject

创建过程：

Widget只是描述了配置信息：

- 其中包含createElement方法用于创建Element
- 也包含createRenderObject，但是不是自己在调用

Element是真正保存树结构的对象：

- 创建出来后会由framework调用mount方法；
- 在mount方法中会调用widget的createRenderObject对象；
- 并且Element对widget和RenderObject都有引用；

RenderObject是真正渲染的对象：

- 其中有`markNeedsLayout` `performLayout` `markNeedsPaint` `paint`等方法

### Widget的key

Key本身是一个抽象，不过它也有一个工厂构造器，创建出来一个ValueKey

直接子类主要有：LocalKey和GlobalKey

- LocalKey，它应用于具有相同父Element的Widget进行比较，也是diff算法的核心所在；
- GlobalKey，通常我们会使用GlobalKey某个Widget对应的Widget或State或Element

**LocalKey有三个子类**

ValueKey：

- ValueKey是当我们以特定的值作为key时使用，比如一个字符串、数字等等

ObjectKey：

- 如果两个学生，他们的名字一样，使用name作为他们的key就不合适了
- 我们可以创建出一个学生对象，使用对象来作为key

UniqueKey

- 如果我们要确保key的唯一性，可以使用UniqueKey；
- 比如我们之前使用随机数来保证key的不同，这里我们就可以换成UniqueKey；

#### GlobalKey

GlobalKey可以帮助我们访问某个Widget的信息，包括Widget或State或Element等对象

### Flutter路由导航

在Flutter中，路由管理主要有两个类：Route和Navigator

#### Route

Route：一个页面要想被路由统一管理，必须包装为一个Route

但是Route是一个抽象类，所以它是不能实例化的

可以使用MaterialPageRoute、CupertinoPageRoute

### Navigator

Navigator：管理所有的Route的Widget，通过一个Stack来进行管理的

### Flutter主题风格

Theme分为：全局Theme和局部Theme

主题有两个作用：

- 设置了主题之后，某些Widget会自动使用主题的样式（比如AppBar的颜色）
- 将某些样式放到主题中统一管理，在应用程序的其它地方直接引用

#### 全局Theme

全局Theme会影响整个app的颜色和字体样式。使用起来非常简单，只需要向MaterialApp构造器传入 `ThemeData` 即可。

- 如果没有设置Theme，Flutter将会使用预设的样式。
- 当然，我们可以对它进行定制。

#### 局部Theme

如果某个具体的Widget不希望直接使用全局的Theme，而希望自己来定义，应该如何做呢？

- 非常简单，只需要在Widget的父节点包裹一下Theme即可

创建另外一个新的页面，页面中使用新的主题：

- 在新的页面的Scaffold外，包裹了一个Theme，并且设置data为一个新的ThemeData

很多时候并不是想完全使用一个新的主题，而且在之前的主题基础之上进行修改：`Theme.of(context).copyWith`传入对应的参数进行修改。

### 屏幕适配

在进行Flutter开发时，我们通常不需要传入尺寸的单位，那么Flutter使用的是什么单位呢？

- Flutter使用的是类似于iOS中的点pt，也就是point。
- 所以我们经常说iPhone6的尺寸是375x667，但是它的分辨率其实是750x1334。
- 因为iPhone6的dpr（devicePixelRatio）是2.0，iPhone6plus的dpr是3.0

在Flutter开发中，我们使用的是对应的逻辑分辨率

#### Flutter设备信息

获取屏幕上的一些信息，可以通过MediaQuery查询，或者官方推荐的库：device_info

#### 适配方案

三方库： flutter_screenutil

