import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.orange,
    ),
    home: const HomePage(),
  ));
}

class Bloc {
  late final BehaviorSubject<String> firstNameSubject;
  late final BehaviorSubject<String> lastNameSubject;

  Bloc() {
    firstNameSubject = BehaviorSubject<String>()..startWith('');
    lastNameSubject = BehaviorSubject<String>()..startWith('');
  }
  final defaultMsg = 'Both must be provided First and Last names';
  Stream<String> get fullName =>
      Rx.combineLatest2(firstNameSubject.stream, lastNameSubject.stream,
          (firstName, lastName) {
        return firstName.isEmpty || lastName.isEmpty
            ? defaultMsg
            : '$firstName $lastName';
      }).startWith(defaultMsg);

  void dispose() {
    firstNameSubject.close();
    lastNameSubject.close();
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Bloc _bloc;
  final firstController = TextEditingController();
  final lastController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc = Bloc();
  }

  @override
  void dispose() {
    _bloc.dispose();
    firstController.dispose();
    lastController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Combine latest with RxDart'),
      ),
      body: StreamBuilder<String>(
          stream: _bloc.fullName,
          builder: (context, snapshot) {
            return Column(
              children: [
                TextField(
                  controller: firstController,
                  onChanged: ((value) {
                    _bloc.firstNameSubject.sink.add(value);
                  }),
                ),
                TextField(
                  controller: lastController,
                  onChanged: (value) {
                    _bloc.lastNameSubject.sink.add(value);
                  },
                ),
                Text(
                  snapshot.data ?? '',
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            );
          }),
    );
  }
}
