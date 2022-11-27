Stream<int> intStream(int count) async* {
  for (int i in Iterable.generate(count)) {
    yield i + 1;
    await Future.delayed(const Duration(
      milliseconds: 50,
    ));
  }
}

Future<int> countStream(Stream<int> stream) async {
  int res = 0;
  await for (int i in stream) {
    res += i;
    print(res);
  }
  return res;
}

void main(List<String> args) async {
  final stream = intStream(36);

  final sum = await countStream(stream);

  print('result: $sum');
}
