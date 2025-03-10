import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_oop_modeler/firebase_object_reference.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

/// An abstract class representing a database object.
abstract class DatabaseObject {
  DocumentReference? ref;

  /// Constructs a [DatabaseObject] with an optional [ref].
  DatabaseObject({this.ref});

  /// Creates a new document in the specified [CollectionReference] and sets the [ref] to the newly created document.
  Future<void> create(CollectionReference d) async {
    if (ref != null) {
      throw 'Document reference is already set';
    }
    ref = d.doc();
    await ref!.set(toMap());
  }

  /// Creates a new document in the specified collection path and sets the [ref] to the newly created document.
  Future<void> createInPath(String d) async {
    if (ref != null) {
      throw 'Document reference is null';
    }
    create(firestore.collection(d));
  }

  /// Creates a new document with the specified path and sets the [ref] to the newly created document.
  Future<void> createWithPath(String d) async {
    if (ref != null) {
      throw 'Document reference is null';
    }
    ref = firestore.doc(d);
    await ref!.set(toMap());
  }

  /// Reloads the data of the document referenced by [ref].
  Future<void> reload() async {
    if (ref == null) {
      throw 'Document reference is null';
    }
    DocumentSnapshot snapshot = await ref!.get();
    fromSnapshot(snapshot);
  }

  /// Updates the document referenced by [ref] with the current data.
  /// If [refe] is provided, it sets the [ref] to the new reference.
  Future<void> update([DocumentReference? refe]) async {
    if (refe != null) {
      if (ref != null) {
        throw 'Document reference is already set';
      }
      ref = refe;
    }
    if (ref == null) {
      throw 'Document reference is null';
    }
    await ref!.set(toMap());
  }

  /// Deletes the document referenced by [ref].
  Future<void> delete() async {
    if (ref == null) {
      throw 'Document reference is null';
    }
    await ref!.delete();
    ref = null;
  }

  /// Converts the object to a map representation.
  Map<String, dynamic> toMap();

  /// Populates the object from a map representation.
  void fromMap(Map<String, dynamic> d);

  /// Populates the object from a [DocumentSnapshot].
  void fromSnapshot(DocumentSnapshot d) {
    fromMap(d.data()! as Map<String, dynamic>);
  }

  /// Returns the string representation of the object.
  FirebaseObjectReference<T> toReference<T extends DatabaseObject>(
      T Function() create,
      [String? name]) {
    name ??= toMap()['name'] ?? ref!.id;
    return FirebaseObjectReference(ref!, name!, create);
  }

  @override
  String toString() {
    return ref!.id.toString();
  }

  @override
  bool operator ==(Object other) {
    if (other is DatabaseObject) {
      return ref == other.ref;
    }
    return false;
  }

  /// Loads a [DatabaseObject] from a [DocumentSnapshot] using a creator function.
  static T loadSnapshot<T extends DatabaseObject>(
      DocumentSnapshot d, T Function() creator) {
    T obj = creator();
    obj.ref = d.reference;
    obj.fromSnapshot(d);
    return obj;
  }

  /// Loads a [DatabaseObject] from a [DocumentReference] using a creator function.
  static Future<T> loadReference<T extends DatabaseObject>(
      DocumentReference ref, T Function() creator) {
    return ref.get().then((DocumentSnapshot snapshot) {
      return loadSnapshot<T>(snapshot, creator);
    });
  }

  /// Loads a [DatabaseObject] from a document path using a creator function.
  static Future<T> loadFromPath<T extends DatabaseObject>(
      String path, T Function() creator) {
    return loadReference(firestore.doc(path), creator);
  }

  /// Loads all [DatabaseObject]s from a [CollectionReference] using a creator function.
  static List<T> loadAllFromSnapshot<T extends DatabaseObject>(
      QuerySnapshot snapshot, T Function() creator) {
    List<T> list = [];
    for (var doc in snapshot.docs) {
      list.add(loadSnapshot<T>(doc, creator));
    }
    return list;
  }

  /// Loads all [DatabaseObject]s from a [Query] using a creator function.
  static Future<List<T>> loadAllFromQuery<T extends DatabaseObject>(
      Query query, T Function() creator) async {
    QuerySnapshot snapshot = await query.get();
    return loadAllFromSnapshot(snapshot, creator);
  }

  /// Loads all [DatabaseObject]s from a [CollectionReference] using a creator function.
  static Future<List<T>> loadAllFromCollection<T extends DatabaseObject>(
      CollectionReference collection, T Function() creator) {
    return loadAllFromQuery(collection, creator);
  }

  @override
  int get hashCode => ref!.id.hashCode;
}
