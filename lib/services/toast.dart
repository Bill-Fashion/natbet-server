import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toast {
  Future showToast(String message) async {
    await Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        // toastDuration: Duration(seconds: 2),
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
