import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_oop_modeler/database_object.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

/// A generic class representing a list of database objects.
class DatabaseList<T extends DatabaseObject> {
  CollectionReference? ref;
  List<T> _list;

  /// Constructs a DatabaseList instance.
  ///
  /// The [ref] parameter is used for direct reference to the collection.
  /// The [refS] parameter is used for a string reference to the collection.
  /// The [d] parameter is a QuerySnapshot used to initialize the list.
  /// The [create] parameter is a function that creates an instance of T.
  DatabaseList({this.ref, String? refS, QuerySnapshot? d, T Function()? create})
      : _list = [] {
    if (ref == null && refS != null) {
      ref = firestore.collection(refS);
    }
    if (ref == null) {
      throw 'Collection reference is null';
    }

    if (d != null && create != null) {
      _list = d.docs.map((e) => loadSnapshot(e, create)).toList();
    }
  }

  /// Returns the length of the list.
  int get length => _list.length;

  /// Reloads all objects in the list and adds new ones if they are not in the list.
  Future<void> reloadComplete(T Function() create) async {
    QuerySnapshot snapshot = await ref!.get();
    _list = snapshot.docs.map((e) => loadSnapshot(e, create)).toList();
  }

  /// Reloads all objects in the list, does not add new ones.
  Future<void> reloadCurrent() async {
    for (var element in _list) {
      element.reload();
    }
  }

  /// Loads a snapshot into a DatabaseObject.
  ///
  /// This method is not recommended to be used directly.
  Future<void> updateAll() async {
    for (var element in _list) {
      element.update();
    }
  }

  /// Returns the object at the specified [index].
  T operator [](int index) => _list[index];

  /// Adds a value to the list.
  void add(T value) {
    DatabaseObject obj = value;
    obj.create(ref!);
    _list.add(value);
  }

  /// Checks if the list contains the specified [value].
  bool contains(T value) {
    for (var element in _list) {
      if (element.ref!.path == value.ref!.path) {
        return true;
      }
    }
    return false;
  }

  /// Removes the object with the same path as the specified [value].
  ///
  /// Returns true if the object was removed, otherwise throws an exception.
  bool remove(T value) {
    T? found;
    for (var element in _list) {
      if (element.ref!.path == value.ref!.path) {
        found = element;
        break;
      }
    }
    if (found == null) {
      throw 'Element not found in list';
    }
    found.delete();
    _list.remove(found);
    return true;
  }

  /// Adds all values from the specified [values] iterable to the list.
  void addAll(Iterable<T> values) {
    for (var element in values) {
      add(element);
    }
  }

  /// Applies the function [f] to each element of the list and returns an iterable of the results.
  Iterable<E> map<E>(E Function(T e) f) {
    return _list.map(f);
  }

  /// Returns the list of objects.
  List<T> get list => _list;
}

/// Creates a DatabaseList instance from a QuerySnapshot.
Future<DatabaseList<T>> fromQuerySnapshot<T extends DatabaseObject>(
    CollectionReference ref,
    QuerySnapshot snapshot,
    T Function() creator) async {
  return DatabaseList<T>(ref: ref, d: snapshot, create: creator);
}

/// Loads a DatabaseList instance from a CollectionReference.
Future<DatabaseList<T>> loadCollection<T extends DatabaseObject>(
    CollectionReference ref, T Function() creator) async {
  DatabaseList<T> list = DatabaseList<T>(ref: ref);
  await list.reloadComplete(creator);
  return list;
}

/// Loads a DatabaseList instance from a path.
Future<DatabaseList<T>> loadAllFromPath<T extends DatabaseObject>(
    String path, T Function() creator) {
  return loadCollection(firestore.collection(path), creator);
}
