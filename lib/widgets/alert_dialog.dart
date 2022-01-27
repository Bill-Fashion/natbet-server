import 'dart:ui';
import 'package:flutter/material.dart';

class BlurryDialogWidget extends StatelessWidget {
  String? title;
  String? content;
  VoidCallback? continueCallBack;

  BlurryDialogWidget(
      {required this.title, required this.content, this.continueCallBack});
  TextStyle textStyle = TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          backgroundColor: Color.fromRGBO(26, 29, 33, 1),
          title: new Text(
            title!,
            style: textStyle,
          ),
          content: new Text(
            content!,
            style: textStyle,
          ),
          actions: <Widget>[
            new TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new TextButton(
              child: new Text("Continue"),
              onPressed: () {
                continueCallBack!();
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }
}
