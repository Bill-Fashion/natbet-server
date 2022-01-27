import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:natbet/services/api_management.dart';
import 'package:natbet/services/room.dart';

class CloseDialogWidget extends StatefulWidget {
  String? title;
  String? content;
  String? roomId;
  String? gameId;

  CloseDialogWidget(
      {required this.title, required this.content, this.gameId, this.roomId});

  @override
  State<CloseDialogWidget> createState() => _CloseDialogWidgetState();
}

class _CloseDialogWidgetState extends State<CloseDialogWidget> {
  bool? isChecked = false;
  TextStyle textStyle = TextStyle(color: Colors.white);
  DateTime dateTimePicker = DateTime.now();
  RoomService _roomService = RoomService();
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          backgroundColor: Color.fromRGBO(26, 29, 33, 1),
          title: new Text(
            widget.title!,
            style: textStyle,
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  widget.content!,
                  style: textStyle,
                ),
                Row(
                  children: [
                    Checkbox(
                        value: isChecked,
                        onChanged: (checked) {
                          setState(() {
                            isChecked = checked;
                          });
                        }),
                    Text("Set close with timer")
                  ],
                ),
                if (isChecked!)
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(26, 29, 33, 1),
                          shadowColor: Color.fromRGBO(26, 30, 33, 1)),
                      onPressed: () {
                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            theme:
                                DatePickerTheme(backgroundColor: Colors.white),
                            onChanged: (date) {
                              // dateTimeString = date.toString();
                              print('change $date in time zone ' +
                                  date.timeZoneOffset.inHours.toString());
                            },
                            minTime: DateTime.now(),
                            onConfirm: (date) {
                              setState(() {
                                dateTimePicker = date;
                                print(dateTimePicker);
                                print(dateTimePicker.millisecondsSinceEpoch);
                              });
                            },
                            currentTime: DateTime.now());
                      },
                      child: Text(
                        dateTimePicker.toString(),
                        style: TextStyle(color: Colors.red),
                      )),
              ],
            ),
            // ),
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
                if (isChecked!) {
                  print(dateTimePicker);
                  print(dateTimePicker.millisecondsSinceEpoch);
                  print(isChecked);
                  RoomService()
                      .setCloseGameInProgress(widget.roomId!, widget.gameId!);
                  ApiManagement().setCloseTimer(widget.roomId!, widget.gameId!,
                      dateTimePicker.millisecondsSinceEpoch);
                } else {
                  _roomService.closeGame(widget.roomId, widget.gameId);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }
}
