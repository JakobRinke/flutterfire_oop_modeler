import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;


abstract class DatabaseObject {

  DocumentReference? ref;

  DatabaseObject({this.ref});

  Future<void> create (CollectionReference d) async {
    if (ref != null) {
      throw 'Document reference is already set';
    }
    ref = d.doc();
    await ref!.set(toMap());
  }

  Future<void> createInPath(String d) async {
    if (ref != null) {
      throw 'Document reference is null';
    }
    create(firestore.collection(d));
  }

  Future<void> createWithPath(String d) async {
    if (ref != null) {
      throw 'Document reference is null';
    }
    ref = firestore.doc(d);
    await ref!.set(toMap());
  }

  Future<void> reload() async {
    if (ref == null) {
      throw 'Document reference is null';
    }
    DocumentSnapshot snapshot = await ref!.get();
    fromSnapshot(snapshot);
  }

  Future<void> update([refe]) async {
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

  Future<void> delete() async {
    if (ref == null) {
      throw 'Document reference is null';
    }
    await ref!.delete();
  }

  Map<String, dynamic> toMap();

  void fromMap(Map<String, dynamic> d);
  
  void fromSnapshot(DocumentSnapshot d) {
    fromMap(d.data()! as Map<String, dynamic>);
  }


}

T loadSnapshot<T extends DatabaseObject>(DocumentSnapshot d, T Function() creator) {
    T obj = creator();
    obj.ref = d.reference;
    obj.fromSnapshot(d);
    return obj;
  } 

Future<T> loadReference<T extends DatabaseObject>(DocumentReference ref, T Function() creator) {
  return ref.get().then((DocumentSnapshot snapshot) {
    return loadSnapshot<T>(snapshot, creator);
  });
}

Future<T> loadFromPath<T extends DatabaseObject>(String path, T Function() creator) {
    return loadReference(firestore.doc(path), creator);
}


