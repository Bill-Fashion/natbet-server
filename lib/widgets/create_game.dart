import 'package:flutter/material.dart';
import 'package:natbet/services/room.dart';

class CreateGame extends StatefulWidget {
  final String? creator;
  final String? roomDocId;
  final String? gameDocId;
  final bool? selectedUpdate;
  const CreateGame(
      {Key? key,
      this.creator,
      this.roomDocId,
      this.selectedUpdate,
      this.gameDocId})
      : super(key: key);
  @override
  _CreateGameState createState() => _CreateGameState();
}

class _CreateGameState extends State<CreateGame> {
  RoomService _roomService = RoomService();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final TextEditingController _nameTextEditingController1 =
      TextEditingController();
  TextEditingController _nameTextEditingController2 = TextEditingController();
  TextEditingController _nameTextEditingController3 = TextEditingController();
  TextEditingController _nameTextEditingController4 = TextEditingController();
  String? finalType;
  String? description;
  String? leftValue;
  String? rightValue;
  String? condition;

  bool? isChecked = false;
  @override
  Widget build(BuildContext context) {
    final gameTypes = ["Sic bo", "Win - Lose"];

    return AlertDialog(
      backgroundColor: Color.fromRGBO(26, 29, 33, 1),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      content: SingleChildScrollView(
        child: Form(
            key: _formKey1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                    hint: Text("Game type"),
                    isExpanded: true,
                    value: finalType,
                    items: gameTypes
                        .map((String type) => DropdownMenuItem(
                            value: type,
                            child: Text(
                              type,
                              style: TextStyle(),
                            )))
                        .toList(),
                    onChanged: (value) => setState(() {
                          finalType = value;
                        })),
                TextFormField(
                  controller: _nameTextEditingController1,
                  validator: (value) {
                    return value!.isNotEmpty ? null : "Can\'t be empty";
                  },
                  onChanged: ((value) => setState(() => description = value)),
                  decoration: InputDecoration(hintText: "Description"),
                ),
                TextFormField(
                  controller: _nameTextEditingController2,
                  validator: (value) {
                    return value!.isNotEmpty ? null : "Can\'t be empty";
                  },
                  onChanged: ((value) => setState(() => leftValue = value)),
                  decoration: InputDecoration(hintText: "Left value"),
                ),
                TextFormField(
                  controller: _nameTextEditingController3,
                  validator: (value) {
                    return value!.isNotEmpty ? null : "Can\'t be empty";
                  },
                  onChanged: ((value) => setState(() => rightValue = value)),
                  decoration: InputDecoration(hintText: "Right value"),
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
                    Text("Condition")
                  ],
                ),
                if (isChecked!)
                  TextFormField(
                    controller: _nameTextEditingController4,
                    validator: (value) {
                      return value != '' ? null : "Can\'t be empty";
                    },
                    onChanged: ((value) => setState(() => condition = value)),
                    decoration: InputDecoration(hintText: "Condition"),
                  ),
              ],
            )),
      ),
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
            if (_formKey1.currentState!.validate() &&
                widget.selectedUpdate == false) {
              _roomService.createGame("${widget.roomDocId}", "$finalType",
                  "$description", "$leftValue", "$rightValue", "$condition");
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
