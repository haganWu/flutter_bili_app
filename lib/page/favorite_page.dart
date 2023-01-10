import 'package:flutter/material.dart';

/// 收藏
class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FractionallySizedBox(
          heightFactor: 1,
          widthFactor: 1,
          child: Container(
            alignment: Alignment.center,
            child: const Text(
              "FavoritePage",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
