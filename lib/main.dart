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

enum TypeOfThings { animal, person }

@immutable
class Thing {
  final TypeOfThings type;
  final String name;

  const Thing({
    required this.type,
    required this.name,
  });
}

const things = [
  Thing(type: TypeOfThings.person, name: 'Foo'),
  Thing(type: TypeOfThings.person, name: 'Bar'),
  Thing(type: TypeOfThings.person, name: 'Baz'),
  Thing(type: TypeOfThings.animal, name: 'Bunz'),
  Thing(type: TypeOfThings.animal, name: 'Fluffers'),
  Thing(type: TypeOfThings.animal, name: 'Woofz'),
];

@immutable
class Bloc {
  final Sink<TypeOfThings?> setTypeOfThing;
  final Stream<TypeOfThings?> currentTypeOfThing;
  final Stream<Iterable<Thing>> things;

  const Bloc._({
    required this.setTypeOfThing,
    required this.currentTypeOfThing,
    required this.things,
  });

  void dispose() {
    setTypeOfThing.close();
  }

  factory Bloc({required Iterable<Thing> things}) {
    final typeOfThingSubject = BehaviorSubject<TypeOfThings?>();
    final filteredThings = typeOfThingSubject
        .debounceTime(const Duration(milliseconds: 300))
        .map<Iterable<Thing>>((typeOfThing) {
      if (typeOfThing != null) {
        return things.where((thing) => thing.type == typeOfThing);
      } else {
        return things;
      }
    }).startWith(things);
    return Bloc._(
      setTypeOfThing: typeOfThingSubject.sink,
      currentTypeOfThing: typeOfThingSubject.stream,
      things: filteredThings,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Bloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = Bloc(things: things);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FilterChip with RxDart'),
      ),
      body: Column(
        children: [
          StreamBuilder<TypeOfThings?>(
            stream: _bloc.currentTypeOfThing,
            builder: ((context, snapshot) {
              final selectedTypeOfThing = snapshot.data;
              return Wrap(
                children: TypeOfThings.values
                    .map(
                      (typeOfThing) => FilterChip(
                        label: Text(typeOfThing.name),
                        selectedColor: Colors.blue.withAlpha(50),
                        selected: selectedTypeOfThing == typeOfThing,
                        onSelected: (selected) {
                          final type = selected ? typeOfThing : null;
                          _bloc.setTypeOfThing.add(type);
                        },
                      ),
                    )
                    .toList(),
              );
            }),
          ),
          Expanded(
            child: StreamBuilder<Iterable<Thing>>(
              stream: _bloc.things,
              builder: ((context, snapshot) {
                final things = snapshot.data?.toList();
                return ListView.builder(
                  itemCount: things?.length ?? 0,
                  itemBuilder: (context, index) {
                    final thing = things?[index];
                    return Center(
                      child: ListTile(
                        title: Text(
                          thing?.type.name ?? '',
                          style: const TextStyle(color: Colors.black),
                        ),
                        subtitle: Text(
                          thing?.name ?? '',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
