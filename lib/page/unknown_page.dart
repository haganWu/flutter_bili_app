import 'package:flutter/material.dart';

class UnKnownPage extends StatefulWidget {
  const UnKnownPage({Key? key}) : super(key: key);

  @override
  State<UnKnownPage> createState() => _UnKnownPageState();
}

class _UnKnownPageState extends State<UnKnownPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: const Text('404'),
      ),
    );
  }
}
