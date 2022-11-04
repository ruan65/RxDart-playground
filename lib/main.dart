import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.orange,
    ),
    home: const HomePage(),
  ));
}

void testIt() async {
  final stream1 = Stream.periodic(const Duration(milliseconds: 1500),
      (count) => 'Stream 1, count = $count');
  final stream2 = Stream.periodic(const Duration(milliseconds: 1900),
      (count) => 'Stream 2, count = $count');

  final result = stream1.mergeWith([stream2]);

  await for (final value in result) {
    value.log();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    testIt();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Container(),
    );
  }
}
