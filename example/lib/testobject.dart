import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_oop_modeler/database_object.dart';

class TestObject extends DatabaseObject {
  String? name;
  int? age;

  TestObject({this.name, this.age, DocumentReference? ref}) : super(ref: ref);

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