import 'package:flutter/material.dart';

class RankingTabPage extends StatefulWidget {
  final String tabName;

  const RankingTabPage({Key? key, required this.tabName}) : super(key: key);

  @override
  State<RankingTabPage> createState() => _RankingTabPageState();
}

class _RankingTabPageState extends State<RankingTabPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        widget.tabName,
        style: const TextStyle(fontSize: 20, color: Colors.redAccent),
      ),
    );
  }
}
