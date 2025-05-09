import 'package:flutter/material.dart';
import 'package:flutterfire_oop_modeler/database_object.dart';

abstract class SimpleDatabaseListView<T extends DatabaseObject>
    extends StatefulWidget {
  const SimpleDatabaseListView({super.key});
}

abstract class SimpleDatabaseListViewState<T extends DatabaseObject,
    U extends SimpleDatabaseListView<T>> extends State<U> {
  List<T> objects = [];
  
  /// Loads the objects from the database
  void loadObjects();

  /// Removes the object from the list and calls setState
  void deleteObject(T obj) {
    objects.removeWhere((element) => element.ref == obj.ref);
    setState(() {});
  }

  /// Adds the object to the list and calls setState
  void addObject();

  @override
  void initState() {
    super.initState();
    loadObjects();
  }

  Widget itemBuilder(T t);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildTopbar(context),
        ...objects.reversed.map((e) => itemBuilder(e)),
      ],
    );
  }

  Widget buildTopbar(BuildContext context);
}
