import 'package:example/testobject.dart';
import 'package:flutter/material.dart';

Widget buildTestObjectView(TestObject testObject, Function reload, BuildContext context) {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  if (testObject.ref != null) {
    _nameController.text = testObject.name ?? '';
    _ageController.text = testObject.age?.toString() ?? '';
  }

  bool isCreate = testObject.ref == null;

  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
            ),
          ),
          TextField(
            controller: _ageController,
            decoration: InputDecoration(
              labelText: 'Age',
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              testObject.name = _nameController.text;
              testObject.age = int.tryParse(_ageController.text);
              if (isCreate) {
                await testObject.createInPath('testobjects');
                _nameController.text = '';
                _ageController.text = '';
                testObject = TestObject();
              } else {
                await testObject.update();
              }
              await reload();
            },
            child: Text(isCreate ? 'Create' : 'Save'),
          ),
          if (!isCreate)
            ElevatedButton(
              onPressed: () async {
                await testObject.delete();
                reload();
              },
              child: Text('Delete'),
            ),
        ],
      ),
    ),
  );
}
