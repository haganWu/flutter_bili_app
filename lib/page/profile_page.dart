import 'package:flutter/material.dart';

/// 我的
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
              "ProfilePage",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}
