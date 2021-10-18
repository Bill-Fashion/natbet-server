import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:natbet/services/room.dart';
import 'package:natbet/services/toast.dart';
import 'package:natbet/services/user.dart';

class InputCoinForm extends StatefulWidget {
  final int button;
  final DocumentSnapshot gameDocument;
  final DocumentSnapshot currentPlayerSnapshot;
  final String roomDocId;
  final int currentUserCoins;
  InputCoinForm(
      {Key? key,
      required this.gameDocument,
      required this.currentPlayerSnapshot,
      required this.roomDocId,
      required this.button,
      required this.currentUserCoins})
      : super(key: key);

  @override
  _InputCoinFormState createState() => _InputCoinFormState();
}

class _InputCoinFormState extends State<InputCoinForm> {
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  TextEditingController _textEditingController1 = TextEditingController();

  RoomService _roomService = RoomService();

  var coinEnter;

  var currentTotalLeftInput;
  var currentTotalRightInput;
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: AlertDialog(
          backgroundColor: Color.fromRGBO(26, 29, 33, 1),
          content: Form(
            key: _formKey2,
            child: TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: _textEditingController1,
              validator: (value) {
                return value!.isNotEmpty ? null : "Invalid input";
              },
              onChanged: ((value) {
                setState(() => coinEnter = value);
              }),
              decoration: InputDecoration(hintText: "Enter coins"),
            ),
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
                var intCoinEnter = int.parse(coinEnter);
                var currentTotalGameLeftBudget =
                    widget.gameDocument['leftBudget'];
                var currentTotalGameRightBudget =
                    widget.gameDocument['rightBudget'];
                var newTotalGameLeftBudget;
                var newTotalGameRightBudget;
                if (!widget.currentPlayerSnapshot.exists) {
                  if (widget.button == 0) {
                    currentTotalLeftInput = intCoinEnter;
                    currentTotalRightInput = 0;
                    newTotalGameLeftBudget =
                        currentTotalGameLeftBudget + intCoinEnter;
                    newTotalGameRightBudget = currentTotalGameRightBudget;
                  }
                  if (widget.button == 1) {
                    currentTotalLeftInput = 0;
                    currentTotalRightInput = intCoinEnter;
                    newTotalGameLeftBudget = currentTotalGameLeftBudget;
                    newTotalGameRightBudget =
                        currentTotalGameRightBudget + intCoinEnter;
                  }
                } else {
                  var currentPlayerLeftBudget =
                      widget.currentPlayerSnapshot['leftBetBudget'];
                  var currentPlayerRightBudget =
                      widget.currentPlayerSnapshot['rightBetBudget'];

                  if (widget.button == 0) {
                    currentTotalLeftInput =
                        intCoinEnter + currentPlayerLeftBudget;
                    currentTotalRightInput = currentPlayerRightBudget;
                    newTotalGameLeftBudget =
                        currentTotalGameLeftBudget + intCoinEnter;
                    newTotalGameRightBudget = currentTotalGameRightBudget;
                  }
                  if (widget.button == 1) {
                    currentTotalLeftInput = currentPlayerLeftBudget;
                    currentTotalRightInput =
                        intCoinEnter + currentPlayerRightBudget;
                    newTotalGameLeftBudget = currentTotalGameLeftBudget;
                    newTotalGameRightBudget =
                        currentTotalGameRightBudget + intCoinEnter;
                  }
                }

                if (widget.currentUserCoins >= intCoinEnter) {
                  if (_formKey2.currentState!.validate()) {
                    _roomService.playerBetting(
                      widget.roomDocId,
                      widget.gameDocument.id,
                      newTotalGameLeftBudget,
                      newTotalGameRightBudget,
                      currentTotalLeftInput,
                      currentTotalRightInput,
                    );
                    UserService()
                        .deductUserCoins(widget.currentUserCoins, intCoinEnter);
                    Navigator.of(context).pop();
                  }
                } else {
                  Toast().showToast("Not enough coins");
                }
              },
            ),
          ],
        ));
  }
}
