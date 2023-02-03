import 'package:flutter/cupertino.dart';

class HomeTabPage extends StatefulWidget {
  final String name;

  const HomeTabPage({Key? key, required this.name}) : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(widget.name),
    );
  }
}
