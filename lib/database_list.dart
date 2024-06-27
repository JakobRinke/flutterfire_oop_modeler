import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_oop_modeler/database_object.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;


class DatabaseList<T extends DatabaseObject> { 

  CollectionReference? ref;
  List<T> _list;

  /// use refS for a string reference to the collection or ref for direct reference
  DatabaseList({this.ref, String? refS, QuerySnapshot? d,T Function()? create}): _list = [] {
    if (ref == null && refS != null) {
      ref = firestore.collection(refS);
    }
    if (ref==null) {
      throw 'Collection reference is null';
    }

    if (d != null && create != null) {
      _list = d.docs.map((e) => loadSnapshot(e, create)).toList();
    }
  }


  int get length => _list.length;

  /// Reloads all Objects in the list and adds new ones if they are not in the list
  Future<void> reloadComplete(T Function() create) async {
    QuerySnapshot snapshot = await ref!.get();
    _list = snapshot.docs.map((e) => loadSnapshot(e, create)).toList();
  }

  /// Reloads all Objects in the list, does not add new ones
  Future<void> reloadCurrent() async {
    for (var element in _list) {
      element.reload();
    }
  }

  /// Load a snapshot into a DatabaseObject  - Not reccomended to use this method directly
  Future<void> updateAll() async {
    for (var element in _list) {
      element.update();
    }
  }

  
  T operator [](int index) => _list[index];

  
  void add(T value) {
    DatabaseObject obj = value;
    obj.create(ref!);
    _list.add(value);
  }


  bool contains (T value) {
    for (var element in _list) {
      if (element.ref!.path == value.ref!.path) {
        return true;
      }
    }
    return false;
  }

  /// Will compare the reference.path of the objects and remove the object with the same path
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


  void addAll(Iterable<T> values) {
    for (var element in values) {
      add(element);
    }
  }

  /// map function
  Iterable<E> map<E>(E Function(T e) f) {
    return _list.map(f);
  }

  List<T> get list => _list;

}


Future<DatabaseList<T>> fromQuerySnapshot<T extends DatabaseObject>(CollectionReference ref, QuerySnapshot snapshot, T Function() creator) async {
  return DatabaseList<T>(ref: ref, d: snapshot, create: creator);
}

Future<DatabaseList<T>> loadCollection<T extends DatabaseObject>(CollectionReference ref, T Function() creator) async {
  DatabaseList<T> list = DatabaseList<T>(ref: ref);
  await list.reloadComplete(creator);
  return list;
}

Future<DatabaseList<T>> loadAllFromPath<T extends DatabaseObject>(String path, T Function() creator) {
  return loadCollection(firestore.collection(path), creator);
}
  