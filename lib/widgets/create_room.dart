import 'package:flutter/material.dart';
import 'package:natbet/services/room.dart';

class CreateRoomDialog {
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();

  Future<void> showRoomCreationDialog(BuildContext context) async {
    String? roomName = '';
    String? roomPassword = '';
    return await showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _nameTextEditingController =
              TextEditingController();
          final TextEditingController _passwordTextEditingController =
              TextEditingController();
          bool? isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Color.fromRGBO(26, 29, 33, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              content: Form(
                  key: _formKey1,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _nameTextEditingController,
                        validator: (value) {
                          return value!.isNotEmpty ? null : "Invalid Field";
                        },
                        onChanged: ((value) =>
                            setState(() => roomName = value)),
                        decoration: InputDecoration(hintText: "Room name"),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                              value: isChecked,
                              onChanged: (checked) {
                                setState(() {
                                  isChecked = checked;
                                });
                              }),
                          Text("Password"),
                        ],
                      ),
                      if (isChecked!)
                        TextFormField(
                          controller: _passwordTextEditingController,
                          validator: (value) {
                            return value!.isNotEmpty
                                ? null
                                : "Password must not empty";
                          },
                          onChanged: ((value) =>
                              setState(() => roomPassword = value)),
                          decoration: InputDecoration(hintText: "Password"),
                        ),
                    ],
                  )),
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
                    if (_formKey1.currentState!.validate()) {
                      // Do something like updating SharedPreferences or User Settings etc.
                      RoomService().createRoom(roomName!, roomPassword);
                      // print(roomName);
                      // print(roomPassword);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          });
        });
  }
}
