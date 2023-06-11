环境安装：

检测环境

```
flutter doctor
```

项目创建

```
flutter create flutter_demo //注意项目名必须全部小写或者用下划线
```

运行

```
cd flutter_demo  
flutter run
```

添加依赖

```
dart pub add bloc
```

vscode环境

安装dart和flutter插件, 

提高效率Awesome Flutter Snippets插件

左下角可以选择需要运行的设备

flutter - native - rn 的区别

Flutter利用Skia绘图引擎，直接通过CPG、GPU进行绘制，不需要依赖任何原生的控件，所以flutter在某些Android操作系统上甚至还要高于原生（因为原生Android中的skia必须随着操作系统进行更新，而flutter SDK总是保持最新的）

![image-20230603094132478](/Users/a123/Library/Application Support/typora-user-images/image-20230603094132478.png)

Flutter绘制过程：

1. 构建 Widget 树： Flutter 应用程序的界面是通过 Widget 树来构建的。Widget 树表示应用程序的界面结构，由不同类型的 Widget 组成，包括容器、布局、文本、图片等。
2. 创建 Element 树： 在构建 Widget 树后，Flutter 会创建相应的 Element 树。每个 Widget 对象都有一个相应的 Element 对象，它们一一对应，并形成一个 Element 树。
3. 布局计算： 一旦 Widget 树和 Element 树创建完成，Flutter 会进行布局计算。布局计算过程涉及 Widget 的大小和位置的计算，以确定界面上各个元素的准确位置。
4. 绘制图层： Flutter 使用 Skia 图形库进行绘制。在绘制阶段，Flutter 将布局计算的结果转换为一组图层，并将其传递给 Skia 进行渲染
5. 绘制更新： 当 Widget 状态发生变化时，只有受影响的部分会被标记为"脏"，需要进行更新。Flutter 使用基于比较的算法来确定哪些部分需要重新绘制，以提高性能。
6. 异步渲染： Flutter 使用 Dart 的异步机制来进行渲染。在每个绘制帧中，Flutter 将 UI 更新任务添加到事件队列中，并在主事件循环中进行处理。这种异步渲染机制确保界面的响应性和流畅性。
7. GPU 加速： Flutter 利用现代图形处理器 (GPU) 的能力来加速界面的渲染。它使用 Skia 图形库将绘制图层传递给 GPU，并利用 GPU 的硬件加速特性来加快渲染速度。

绘制原理

- GPU将信号同步到UI线程
- UI线程用Dart来构建图层树
- 图层树在GPU线程进行合成
- 合成后的视图数据提供给Skia引擎
- Skia引擎通过OpenGL或者Vulkan将显示内容提供给GPU

![image-20230603094928681](/Users/a123/Library/Application Support/typora-user-images/image-20230603094928681.png)

因此Flutter是自己完成了组件渲染的闭环



### 渲染引擎skia

Skia 是一个跨平台的图形库，用于进行2D图形渲染和绘制。它是由Google开发和维护的，被广泛应用于多个开源项目中，其中包括 Flutter、Android、Chrome 等。

Skia 引擎在 Flutter 中起着关键的作用，它负责将 Flutter 的界面描述转化为可视化的图形，并在屏幕上进行渲染。以下是 Skia 引擎的一些关键特点和功能：

1. 跨平台支持： Skia 是一个C++编写的跨平台的图形库，可以在多个操作系统上运行，包括 Android、iOS、Windows、Linux 等。这使得 Flutter 在不同平台上能够提供一致的用户界面和渲染效果。
2. 2D 图形渲染： Skia 提供了丰富的 2D 图形绘制功能，包括绘制基本形状（如线条、矩形、圆形）、图像绘制、文字绘制等。Flutter 使用 Skia 来绘制应用程序的界面元素，如文本、图标、图像等。
3. GPU 加速： Skia 引擎支持利用现代图形处理器（GPU）进行硬件加速的渲染。通过与 GPU 的协作，Skia 可以高效地进行图形绘制和渲染，提供更高的性能和流畅的用户体验。
4. 矢量图形和图像处理： Skia 提供了强大的矢量图形和图像处理能力，包括路径绘制、颜色管理、滤镜效果、像素操作等。这使得 Flutter 可以处理复杂的图形和图像效果，如渐变、阴影、蒙版等。
5. 轻量高效： Skia 被设计为轻量级和高效的图形库，具有较小的内存占用和快速的渲染速度。这对于移动设备和嵌入式系统等资源有限的环境非常重要，可以保证 Flutter 的性能和响应性。

Skia 引擎作为 Flutter 的底层图形渲染引擎，为 Flutter 提供了强大的图形绘制和渲染能力。它与 Flutter 的 Widget 和 Element 树结合使用，将抽象的界面描述转化为具体的图形，并通过 GPU 加速进行渲染，从而实现了 Flutter 应用程序的高性能和可视化效果。

对于iOS平台来说，由于Skia是跨平台的，因此Flutter iOS渲染引擎被嵌入到Flutter的iOS SDK中，替代了iOS闭源的Core Graphics/Core Animation/Core Text，这也正是Flutter iOS SDK打包的App 包提及比Android要大一些的原因。