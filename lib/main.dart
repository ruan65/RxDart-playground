import 'dart:async';

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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final StreamController streamController;
  late final Stream<String> streamOfStrings;

  @override
  void initState() {
    super.initState();
    streamController = StreamController<DateTime>();
    streamOfStrings =
        streamController.stream.switchMap((dateTime) => Stream.periodic(
              const Duration(seconds: 1),
              (count) => 'Stream count = $count, dateTime = $dateTime',
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          const Spacer(),
          StreamBuilder<String>(
              stream: streamOfStrings,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.requireData);
                } else {
                  return const Text('Waiting for press....');
                }
              }),
          const Spacer(),
          TextButton(
            onPressed: () {
              streamController.add(DateTime.now());
            },
            child: const Center(
              child: Text(
                'Start the stream',
                style: TextStyle(fontSize: 33),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }
}
