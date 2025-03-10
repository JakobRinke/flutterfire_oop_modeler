import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_oop_modeler/database_object.dart';

/// A reference to a [DatabaseObject] stored in Firebase.
class FirebaseObjectReference<T extends DatabaseObject> {
  final DocumentReference documentReference;
  final String name;
  final T Function() create;

  FirebaseObjectReference(this.documentReference, this.name, this.create);

  T? _objectCache;

  /// Loads the [DatabaseObject] from the [DocumentReference] and caches it.
  Future<T> load() async {
    if (_objectCache != null) {
      return _objectCache!;
    }
    _objectCache =
        await DatabaseObject.loadReference(documentReference, create);
    return _objectCache!;
  }

  Map<String, dynamic> toMap() {
    return {
      'ref': documentReference,
      'name': name,
    };
  }

  /// Creates a new document in the specified [CollectionReference] and sets the [ref] to the newly created document.
  static Future<List<U>> loadAll<U extends DatabaseObject>(
      List<FirebaseObjectReference<DatabaseObject>> refs) async {
    List<Future<DatabaseObject>> futures = [];
    for (FirebaseObjectReference<DatabaseObject> ref in refs) {
      futures.add(ref.load());
    }
    List<DatabaseObject> objects = await Future.wait(futures);
    return List<U>.from(objects);
  }

  /// Creates a [FirebaseObjectReference] from a map.
  static FirebaseObjectReference<T> fromMap<T extends DatabaseObject>(
      Map<String, dynamic> map, T Function() create) {
    return FirebaseObjectReference<T>(
        map['ref'], map['name'], create);
  }

  static List<FirebaseObjectReference<T>> fromList<T extends DatabaseObject>(
      List<Map<String, dynamic>> d, T Function() create) {
    return d.map(
      (e) => fromMap(e, create),
    ).toList();
  } 

  @override
  int get hashCode => this.documentReference.id.hashCode;
  
  @override
  bool operator ==(Object other) {
    if (other is FirebaseObjectReference) {
      return this.documentReference.id == other.documentReference.id;
    } else if (other is DocumentReference) {
      return this.documentReference.id == other.id;
    }
    return false;
  }


}
