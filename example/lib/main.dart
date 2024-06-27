import 'package:example/firebase_options.dart';
import 'package:example/testobject.dart';
import 'package:example/testobjectview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterfire_oop_modeler/database_list.dart';

void main() async {
  // init firebase
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseList<TestObject> testObjects =
      DatabaseList<TestObject>(refS: 'testobjects');
  bool isLoading = true;

  void initiState() {
    super.initState();
  }

  Future<void> _loadTestObjects() async {
    isLoading = false;
    await testObjects.reloadComplete(TestObject.new);
    // print("reloaded");
    // print(testObjects.map((e) => {e.name}).toList());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      _loadTestObjects();
    }
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildTestObjectView(TestObject(), _loadTestObjects, context),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: testObjects.length,
                itemBuilder: (context, index) {
                  return buildTestObjectView(
                      testObjects[index], _loadTestObjects, context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
