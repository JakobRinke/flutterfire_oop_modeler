import 'package:example/testobject.dart';
import 'package:flutter/material.dart';

Widget buildTestObjectView(
    TestObject testObject, Function reload, BuildContext context) {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  if (testObject.ref != null) {
    nameController.text = testObject.name ?? '';
    ageController.text = testObject.age?.toString() ?? '';
  }

  bool isCreate = testObject.ref == null;

  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
          ),
          TextField(
            controller: ageController,
            decoration: const InputDecoration(
              labelText: 'Age',
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              testObject.name = nameController.text;
              testObject.age = int.tryParse(ageController.text);
              if (isCreate) {
                await testObject.createInPath('testobjects');
                nameController.text = '';
                ageController.text = '';
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
              child: const Text('Delete'),
            ),
        ],
      ),
    ),
  );
}
