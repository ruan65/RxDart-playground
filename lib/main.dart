import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const HomePage(),
    ),
  );
}

Stream<String> getNames({
  required String filePath,
}) {
  final names = rootBundle.loadString(filePath);
  return Stream.fromFuture(names).transform(const LineSplitter());
}

Stream<String> getAllNames() => getNames(filePath: 'assets/texts/cats.txt')
    .concatWith([getNames(filePath: 'assets/texts/dogs.txt')]);

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: FutureBuilder<List<String>>(
          future: getAllNames().toList(),
          builder: (context, snapshot) {
            final names = snapshot.requireData;
            return Column(
              children: names.map((e) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.done:
                    return ListTile(
                      title: Text(
                        e,
                        style: const TextStyle(color: Colors.black),
                      ),
                    );
                }
              }).toList(),
            );
          }),
    );
  }
}
