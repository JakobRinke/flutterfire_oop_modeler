import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_oop_modeler/database_object.dart';

/// A widget that allows the user to select an object from a list of objects
class Objektauswahl<T extends DatabaseObject> extends StatefulWidget {
  final String? selectedId;
  final Function(T) onSelect;
  final T Function() create;
  final String Function(T) display;
  final CollectionReference path;
  final bool nullable;

  /// Creates a new instance of [Objektauswahl]
  const Objektauswahl(
      {super.key,
      required this.selectedId,
      required this.onSelect,
      required this.path,
      required this.create,
      required this.display,
      this.nullable = false});

  @override
  ObjektauswahlState<T> createState() => ObjektauswahlState<T>();
}

/// The state of the [Objektauswahl] widget
class ObjektauswahlState<T extends DatabaseObject>
    extends State<Objektauswahl<T>> {
  late String? _currentSelectedId;

  List<T> objekte = [];

  void loadKunden() async {
    objekte =
        await DatabaseObject.loadAllFromCollection(widget.path, widget.create);
    T neuesObjekt = widget.create();
    objekte.add(neuesObjekt);
    setState(() {});
  }

  T? getKundeById(String? id) {
    if (id == null) {
      if (widget.nullable) {
        return objekte.firstWhere((element) => element.ref == null);
      } else {
        return null;
      }
    }
    try {
      return objekte.firstWhere((element) => element.ref!.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _currentSelectedId = widget.selectedId;
    loadKunden();
  }

  @override
  Widget build(BuildContext context) {
    return objekte.isEmpty
        ? const CircularProgressIndicator()
        : DropdownButton<T>(
            value: getKundeById(_currentSelectedId),
            items: objekte.map((T kunde) {
              return DropdownMenuItem<T>(
                value: kunde,
                child: Text(widget.display(kunde)),
              );
            }).toList(),
            onChanged: (T? newValue) async {
              if (newValue == null) return;
              if (newValue.ref == null && !widget.nullable) {
                T k = widget.create();
                await k.create(widget.path);
                objekte.add(k);
                newValue = k;
              }
              widget.onSelect(newValue);
              _currentSelectedId = newValue.ref?.id;
              setState(() {});
            },
          );
  }
}
