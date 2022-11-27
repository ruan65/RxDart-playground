Stream<int> intStream(int count) async* {
  for (int i in Iterable.generate(count)) {
    if (i == -1) {
      throw Exception('Intentional exception');
    } else {
      yield i + 1;
      await Future.delayed(const Duration(
        milliseconds: 50,
      ));
    }
  }
}

Future<int> countStream(Stream<int> stream) async {
  int res = 0;
  try {
    await for (int i in stream) {
      res += i;
      print(res);
    }
  } catch (ex) {
    return -1;
  }
  return res;
}

void main(List<String> args) async {
  final stream = intStream(36);

  // print(await stream.reduce((a, b) => a + b));

  var subs = stream.listen(
    print,
    onDone: () => print('done....'),
  );

  subs.onData((data) {
    print('data: $data');
  });

  await Future.delayed(const Duration(milliseconds: 200));
  subs.pause();
  await Future.delayed(const Duration(milliseconds: 1200));
  subs.resume();

  // final sum = await countStream(stream);

  // print('result: $sum');
}
