import 'package:flutter/foundation.dart';
import 'package:testing_rxdart_examples/models/thing.dart';

enum AnimalType { dog, cat, rabbit, unknown }

@immutable
class Animal extends Thing {
  final AnimalType type;

  const Animal({
    required this.type,
    required String name,
  }) : super(name);

  @override
  String toString() => 'Animal, name: $name, type: $type';

  factory Animal.fromJson(Map<String, dynamic> json) {
    final jstr = json;
    print(jstr);
    late final AnimalType type;
    switch ((json["type"] as String).toLowerCase().trim()) {
      case "rabbit":
        type = AnimalType.rabbit;
        break;
      case "cat":
        type = AnimalType.cat;
        break;
      case "dog":
        type = AnimalType.dog;
        break;
      default:
        type = AnimalType.unknown;
    }
    return Animal(type: type, name: json['name']);
  }
}
