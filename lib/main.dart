import 'package:flutter/foundation.dart';
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

typedef AsyncSnapshotBuilerCallback<T> = Widget Function(
  BuildContext context,
  T? value,
);

class AcyncSnapshotBuilder<T> extends StatelessWidget {
  final Stream<T> stream;
  final AsyncSnapshotBuilerCallback<T>? onNone;
  final AsyncSnapshotBuilerCallback<T>? onWaiting;
  final AsyncSnapshotBuilerCallback<T>? onActive;
  final AsyncSnapshotBuilerCallback<T>? onDone;

  const AcyncSnapshotBuilder({
    super.key,
    required this.stream,
    this.onNone,
    this.onWaiting,
    this.onActive,
    this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            final callback = onNone ?? (_, __) => const SizedBox();
            return callback(
              context,
              snapshot.data,
            );
          case ConnectionState.waiting:
            final callback =
                onWaiting ?? (_, __) => const CircularProgressIndicator();
            return callback(context, snapshot.data);
          case ConnectionState.active:
            final callback = onActive ?? (_, __) => const SizedBox();
            return callback(
              context,
              snapshot.data,
            );
          case ConnectionState.done:
            final callback = onDone ?? (_, __) => const SizedBox();
            return callback(
              context,
              snapshot.data,
            );
        }
      },
    );
  }
}

@immutable
class Bloc {
  final Sink<String> setFirstName;
  final Sink<String> setLastName;
  final Stream<String> fullName;

  static const defaultMsg = 'Both must be provided First and Last names';

  const Bloc._({
    required this.setFirstName,
    required this.setLastName,
    required this.fullName,
  });

  factory Bloc() {
    final fns = BehaviorSubject<String>()..startWith('');
    final lns = BehaviorSubject<String>()..startWith('');
    Stream<String> fullName =
        Rx.combineLatest2(fns.stream, lns.stream, (firstName, lastName) {
      return firstName.isEmpty || lastName.isEmpty
          ? defaultMsg
          : '$firstName $lastName';
    }).startWith(defaultMsg);
    return Bloc._(
      setFirstName: fns.sink,
      setLastName: lns.sink,
      fullName: fullName,
    );
  }

  void dispose() {
    setFirstName.close();
    setLastName.close();
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
        body: Column(
          children: [
            TextField(
              controller: firstController,
              decoration: const InputDecoration(hintText: 'First name'),
              onChanged: ((value) {
                _bloc.setFirstName.add(value);
              }),
            ),
            TextField(
              controller: lastController,
              decoration: const InputDecoration(hintText: 'Last name'),
              onChanged: (value) {
                _bloc.setLastName.add(value);
              },
            ),
            AcyncSnapshotBuilder(
              stream: _bloc.fullName,
              onActive: (context, value) => Text(
                value!,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ));
  }
}
