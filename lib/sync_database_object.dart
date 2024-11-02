import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_oop_modeler/database_object.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

/// An abstract class representing a database object.
abstract class DuplicateDatabaseObject extends DatabaseObject {
  DocumentReference? mainObjectRef;
  List<DocumentReference> duplicateRefs = [];

  bool get isMainObject => ref == mainObjectRef && ref != null;

  // Updates the document referenced by [ref] with the current data.
  /// If [refe] is provided, it sets the [ref] to the new reference.
  /// Also updates all duplicates.
  @override
  Future<void> update([refe]) async {
    if (!isMainObject) {
      throw 'Only main object can update';
    }
    await super.update(refe);
    // Update duplicates
    await Future.wait(duplicateRefs.map((e) => e.set(toMap())));
  }

  Future<T> createDuplicate<T extends DuplicateDatabaseObject>(
      DocumentReference r, T Function() creator) async {
    if (!isMainObject) {
      throw 'Only main object can create duplicates';
    }
    T duplicate = creator();
    duplicate.fromMap(toMap());
    await duplicate.update(r);
    duplicateRefs.add(duplicate.ref!);
    await ref!.update({'duplicateRefs': duplicateRefs});
    return duplicate;
  }

  Future<T> createDuplicateIn<T extends DuplicateDatabaseObject>(
      CollectionReference c, T Function() creator) async {
    if (!isMainObject) {
      throw 'Only main object can create duplicates';
    }
    T duplicate = creator();
    duplicate.fromMap(toMap());
    await duplicate.create(c);
    duplicateRefs.add(duplicate.ref!);
    await ref!.update({'duplicateRefs': duplicateRefs});
    return duplicate;
  }

  @override
  Future<void> delete() async {
    if (!isMainObject) {
      throw 'Only main object can delete';
    }
    await Future.wait(duplicateRefs.map((e) => e.delete()))
        .then((_) => ref!.delete());
    await super.delete();
  }

  Future<void> deleteDuplicate(DocumentReference r) async {
    if (!isMainObject) {
      throw 'Only main object can delete duplicates';
    }
    await r.delete();
    duplicateRefs.remove(r);
    await ref!.update({'duplicateRefs': duplicateRefs});
  }

  @override
  void fromMap(Map<String, dynamic> d) {
    mainObjectRef = d['mainObjectRef'];
    mainObjectRef ??= ref;
    duplicateRefs = d['duplicateRefs'];
    if (duplicateRefs.contains(mainObjectRef)) {
      duplicateRefs.remove(mainObjectRef);
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'mainObjectRef': mainObjectRef ?? ref,
      'duplicateRefs': duplicateRefs,
    };
  }

  @override
  operator ==(Object other) {
    if (other is DuplicateDatabaseObject) {
      return mainObjectRef == other.mainObjectRef;
    }
    return false;
  }

  @override
  int get hashCode => mainObjectRef.hashCode;
}
