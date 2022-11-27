import 'dart:async';

Stream<int> timedCounter(Duration interval, [int? maxCount]) async* {
  int i = 0;

  while (true) {
    await Future.delayed(interval);
    yield i++;
    if (i == maxCount) break;
  }
}

void main(List<String> args) {
  // final counterStream =
  // Stream<int>.periodic(const Duration(milliseconds: 150), (v) => v).take(5);

  final counterStream = timedCounter(const Duration(seconds: 1));
  late final StreamSubscription subscription;
  subscription = counterStream.listen((event) {
    print(event);

    if (event == 11) subscription.cancel();
  });
}
