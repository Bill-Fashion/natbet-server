import 'package:flutter/material.dart';
import 'package:natbet/services/room.dart';

class UpdateDialog extends StatefulWidget {
  final String? roomDocId;
  final String? gameDocId;

  const UpdateDialog({Key? key, this.roomDocId, this.gameDocId})
      : super(key: key);
  @override
  _UpdateDialogState createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  RoomService _roomService = RoomService();
  String? finalResult;
  final winner = ["Left", "Right"];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color.fromRGBO(26, 29, 33, 1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: DropdownButton<String>(
          hint: Text("Winner"),
          isExpanded: true,
          value: finalResult,
          items: winner
              .map((String type) => DropdownMenuItem(
                  value: type,
                  child: Text(
                    type,
                    style: TextStyle(),
                  )))
              .toList(),
          onChanged: (value) => setState(() {
                finalResult = value;
              })),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            // Do something like updating SharedPreferences or User Settings etc.
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Okay'),
          onPressed: () {
            if (finalResult != null) {
              _roomService.updateGame(
                "${widget.roomDocId}",
                "${widget.gameDocId}",
                "$finalResult",
              );
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
