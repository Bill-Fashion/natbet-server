import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Toast {
  Future showToast(String message) async {
    if (kIsWeb) {
      print(message);
      // running on the web!
    } else {
      // NOT running on the web! You can check for additional platforms here.
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
}
