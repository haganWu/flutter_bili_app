import 'package:flutter/material.dart';
import 'package:flutter_bili_app/constant/color.dart';
import 'package:flutter_bili_app/db/hi_cache.dart';
import 'package:flutter_bili_app/page/registration_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HiCache.preInit();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: white,
      ),
      home: const RegistrationPage(),
    );
  }
}