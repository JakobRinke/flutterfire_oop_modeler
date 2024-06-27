import 'package:flutterfire_oop_modeler/database_object.dart';

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

void main() async {}
