import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:natbet/services/room.dart';
import 'package:natbet/services/toast.dart';
import 'package:natbet/services/user.dart';

class InputCoinForm extends StatefulWidget {
  final int button;
  final DocumentSnapshot gameDocument;
  final AsyncSnapshot userSnapshot;
  final String roomDocId;
  final int currentUserCoins;
  InputCoinForm(
      {Key? key,
      required this.gameDocument,
      required this.userSnapshot,
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
  UserService _userService = UserService();
  // var stringCoinEnter;

  var coinEnter;

  @override
  Widget build(BuildContext context) {
    int currentLeftUserBetting = 0;
    int currentRightUserBetting = 0;
    if (widget.gameDocument['leftBudget'] != 0) {
      Map<String, dynamic> leftPlayers =
          widget.gameDocument['leftPlayers'] as Map<String, dynamic>;
      // print(leftPlayers['${FirebaseAuth.instance.currentUser!.uid}']);
      leftPlayers['${FirebaseAuth.instance.currentUser!.uid}'] != null
          ? currentLeftUserBetting =
              leftPlayers['${FirebaseAuth.instance.currentUser!.uid}']
          : currentLeftUserBetting = 0;
    }
    if (widget.gameDocument['rightBudget'] != 0) {
      Map<String, dynamic> rightPlayers =
          widget.gameDocument['rightPlayers'] as Map<String, dynamic>;
      rightPlayers['${FirebaseAuth.instance.currentUser!.uid}'] != null
          ? currentRightUserBetting =
              rightPlayers['${FirebaseAuth.instance.currentUser!.uid}']
          : currentRightUserBetting = 0;
    }

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
                print(widget.currentUserCoins);
                var intCoinEnter = int.parse(coinEnter);
                // print(players['${FirebaseAuth.instance.currentUser!.uid}']);
                if (widget.currentUserCoins >= intCoinEnter) {
                  if (_formKey2.currentState!.validate() &&
                      widget.button == 0) {
                    // print(widget.gameDocument['leftBudget'].runtimeType);
                    // print(coinEnter.runtimeType);

                    _roomService.leftBetting(
                        widget.roomDocId,
                        widget.gameDocument.id,
                        intCoinEnter + currentLeftUserBetting,
                        widget.gameDocument['leftBudget'] + intCoinEnter);
                    UserService()
                        .deductUserCoins(widget.currentUserCoins, intCoinEnter);
                    Navigator.of(context).pop();
                  }
                  if (_formKey2.currentState!.validate() &&
                      widget.button == 1) {
                    // print(widget.gameDocument['leftBudget'].runtimeType);
                    // print(coinEnter.runtimeType);

                    _roomService.rightBetting(
                        widget.roomDocId,
                        widget.gameDocument.id,
                        intCoinEnter + currentRightUserBetting,
                        widget.gameDocument['rightBudget'] + intCoinEnter);
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
