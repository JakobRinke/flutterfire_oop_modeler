import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_oop_modeler/database_object.dart';

/// A widget that loads a database object and shows it
abstract class LoadNShowObject<T extends DatabaseObject>
    extends StatefulWidget {
  final T Function() creator;
  final DocumentReference objRef;

  const LoadNShowObject(
      {super.key, required this.creator, required this.objRef});
}

/// A stateful widget that loads a database object and shows it
abstract class LoadNShowObjectState<T extends DatabaseObject>
    extends State<LoadNShowObject<T>> {
  T? loadedObject;

  void loadDBObject() async {
    loadedObject =
        await DatabaseObject.loadReference<T>(widget.objRef, widget.creator);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadDBObject();
  }

  @override
  Widget build(BuildContext context) {
    if (loadedObject == null) {
      return const CircularProgressIndicator();
    } else {
      return show(context, loadedObject!);
    }
  }

  Widget show(BuildContext context, T object);
}
