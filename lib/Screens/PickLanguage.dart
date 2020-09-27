import 'package:flutter/material.dart';

class PickLanguage extends StatefulWidget {
  @override
  _PickLanguageState createState() => _PickLanguageState();
}

class _PickLanguageState extends State<PickLanguage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: const Text('New entry'),
        actions: [],
      ),
      body: new Text("Foo"),
    );
  }
}
