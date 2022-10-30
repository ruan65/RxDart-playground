import 'dart:convert';
import 'dart:io';

import 'package:testing_rxdart_examples/models/animal.dart';
import 'package:testing_rxdart_examples/models/person.dart';
import 'package:testing_rxdart_examples/models/thing.dart';

typedef SeachTerm = String;

class Api {
  List<Animal>? _animals;
  List<Person>? _persons;
  Api();

  Future<List<Thing>> search(SeachTerm seachTerm) async {
    final cachedResults = _extractThingsUsingSearchTerm(seachTerm);

    if (cachedResults != null) {
      return cachedResults;
    }

    final persons = await _getJson('http://127.0.0.1:5500/api/animals.json')
        .then((json) => json.map((value) => Person.fromJson(value)));
    _persons = persons.toList();

    final animals = await _getJson('http://127.0.0.1:5500/api/persons.json')
        .then((json) => json.map((value) => Animal.fromJson(value)));
    _animals = animals.toList();

    return _extractThingsUsingSearchTerm(seachTerm) ?? [];
  }

  List<Thing>? _extractThingsUsingSearchTerm(SeachTerm term) {
    final cachedAnimals = _animals;
    final cachedPersons = _persons;
    final List<Thing> result = [];

    if (cachedAnimals != null && cachedPersons != null) {
      for (final animal in cachedAnimals) {
        if (animal.name.trimmedContaines(term) ||
            animal.type.name.trimmedContaines(term)) {
          result.add(animal);
        }
      }
      for (final person in cachedPersons) {
        if (person.name.trimmedContaines(term) ||
            person.age.toString().trimmedContaines(term)) {
          result.add(person);
        }
      }
      return result;
    }
    return null;
  }

  Future<List<dynamic>> _getJson(String url) => HttpClient()
      .getUrl(Uri.parse(url))
      .then((req) => req.close())
      .then((value) => value.transform(utf8.decoder).join())
      .then((jsonString) => json.decode(jsonString) as List<dynamic>);
}

extension TrimmedCaseInsenciteveContain on String {
  bool trimmedContaines(String other) =>
      trim().toLowerCase().contains(other.trim().toLowerCase());
}
