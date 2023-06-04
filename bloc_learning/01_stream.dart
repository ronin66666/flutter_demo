

//Stream官方文档 https://dart.dev/tutorials/language/streams
void main(List<String> args) async {
  //初始化一个Stream 
   Stream<int> stream = countStream(10);
   //计算Stream中的数据总和
   int sum = await sumStream(stream);

   print(sum); //45
}

Stream<int> countStream(int max) async* {
  for (int i = 0; i < max; i++) {
    yield i; // 向Stream中添加数据
  }
}

Future<int> sumStream(Stream<int> stream) async {
  int sum = 0;
  await for (int value in stream) { //从stream中取出数据
    sum += value;
  }
  return sum;
}