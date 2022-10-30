import 'package:flutter/foundation.dart';
import 'package:testing_rxdart_examples/models/thing.dart';

@immutable
class Person extends Thing {
  final int age;

  const Person({
    required this.age,
    required String name,
  }) : super(name);

  Person.fromJson(Map<String, dynamic> json)
      : age = json['age'] as int,
        super(json['name'] as String);

  @override
  String toString() => 'Person, name: $name, age: $age';
}
