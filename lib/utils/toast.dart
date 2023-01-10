import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


void showToast(String msg) {
  Fluttertoast.showToast(msg: msg,toastLength: Toast.LENGTH_SHORT);
}

void showWarnToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.yellow,
      textColor: Colors.white);
}

void showErrorToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.red,
      textColor: Colors.white);
}