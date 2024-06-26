import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reflectable/reflectable.dart';
import 'package:json_annotation/json_annotation.dart';


FirebaseFirestore firestore = FirebaseFirestore.instance;


@JsonSerializable(explicitToJson: true)
class DatabaseObject {

  DocumentReference? ref;

  DatabaseObject({this.ref});



  Future<void> save() async {
    if (ref == null) {
      
    }
    await ref!.set(toMap());
  }

  Future<void> delete() async {
    await ref!.delete();
  }

  Map<String, dynamic> toMap() {
    var map = this.jsify() as Map<String, dynamic>;
    map.remove('ref');
    return map;
  }

  factory DatabaseObject.fromJson(Map<String, dynamic> json) =>
      _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);//Replace 'Person' with your class name

}
