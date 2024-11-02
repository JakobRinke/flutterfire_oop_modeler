<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

A Object Like Model put on Firebase Firestore Database to make Modelling Databases easier and faster

## Features


## Getting started
Install the with `flutter pub add flutterfire_oop_modeler`

## Usage

Create an DatabaseObject with input and output function it will be 1:1 representet in your Database
```dart
class TestObject extends DatabaseObject {
  String? name;
  int? age;

  TestObject({this.name, this.age, super.ref});

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
    };
  }

  @override
  void fromMap(Map<String, dynamic> d) {
    name = d['name'];
    age = d['age'];
  }
}
```

### Loading data from Firebase
You can load Objects of a Type from the database with the following functions:
```dart
TestObject to = loadSnapshot(DocumentSnapshot d, TestObject.new);
TestObject to = await loadReference(DocumentReference d, TestObject.new);
TestObject to = await loadAllFromPath("users/user1", TestObject.new);
```

### Collection API
You can scan Collections with the following functions:
```dart
// Not Reccomended
DatabaseList<TestObject> lo = fromQuerySnapshot(CollectionReference d, QuerySnapshot l, TestObject.new);

DatabaseList<TestObject> lo = loadCollection(CollectionReference d, TestObject.new);

DatabaseList<TestObject> lo = loadAllFromPath("user", TestObject.new);

```



