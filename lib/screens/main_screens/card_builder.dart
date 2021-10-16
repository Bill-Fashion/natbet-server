import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:natbet/services/logic.dart';
import 'package:natbet/services/room.dart';
import 'package:natbet/services/user.dart';
import 'package:natbet/widgets/alert_dialog.dart';
import 'package:natbet/widgets/coin_input.dart';
import 'package:natbet/widgets/create_game.dart';
import 'package:natbet/widgets/updategame_diaglog.dart';
import 'package:provider/provider.dart';

class CardBuider extends StatefulWidget {
  final String roomDocId;
  const CardBuider({Key? key, required this.roomDocId}) : super(key: key);
  @override
  State<CardBuider> createState() => _CardBuiderState();
}

class _CardBuiderState extends State<CardBuider> {
  RoomService _roomService = RoomService();
  UserService _userService = UserService();
  LogicService _logicService = LogicService();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _roomService.getGamesByRoom(widget.roomDocId),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> gameSnapshot) {
          if (gameSnapshot.hasError) {
            return Text('Something went wrong');
          }

          if (gameSnapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          } else {
            return ListView(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                children: gameSnapshot.data!.docs
                    .map((DocumentSnapshot gameDocument) {
                  Map<String, dynamic> gameData =
                      gameDocument.data()! as Map<String, dynamic>;

                  return StreamBuilder(
                      stream: _userService.getUserInfo(gameData['creator']),
                      builder: (BuildContext context,
                          AsyncSnapshot creatorUserSnapshot) {
                        if (!creatorUserSnapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        var leftOdds = _logicService.calculateOdds(
                            gameDocument['leftBudget'],
                            gameDocument['rightBudget'],
                            0);
                        var rightOdds = _logicService.calculateOdds(
                            gameDocument['leftBudget'],
                            gameDocument['rightBudget'],
                            1);
                        return StreamBuilder(
                            stream: _userService.getUserInfo(
                                FirebaseAuth.instance.currentUser!.uid),
                            builder: (BuildContext context,
                                AsyncSnapshot currentUserSnapshot) {
                              if (!currentUserSnapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              Map<String, dynamic> leftPlayers =
                                  gameDocument['leftPlayers']
                                      as Map<String, dynamic>;
                              var currentLeftUserBetBudget = leftPlayers[
                                  FirebaseAuth.instance.currentUser!.uid];
                              Map<String, dynamic> rightPlayers =
                                  gameDocument['rightPlayers']
                                      as Map<String, dynamic>;
                              var currentRightUserBetBudget = rightPlayers[
                                  FirebaseAuth.instance.currentUser!.uid];
                              // Check winner
                              if (gameDocument['winner'] == 'Left' &&
                                  currentLeftUserBetBudget != 0) {
                                int prize = _logicService.calculatePrize(
                                    leftOdds, currentLeftUserBetBudget);
                                _userService.addUserCoins(
                                    currentUserSnapshot.data['coins'], prize);
                                _roomService.updateCurrentUserLeftBetCoin(
                                    widget.roomDocId, gameDocument.id);
                              }
                              if (gameDocument['winner'] == 'Right') {
                                int prize = _logicService.calculatePrize(
                                    leftOdds, currentRightUserBetBudget);
                                _userService.addUserCoins(
                                    currentUserSnapshot.data['coins'], prize);
                                _roomService.updateCurrentUserRightBetCoin(
                                    widget.roomDocId, gameDocument.id);
                              }
                              // print("GameDocument: ${gameDocument['creator']}");
                              // print("GameData: ${gameData['creator']}");
                              return Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                                color: Color.fromRGBO(26, 29, 33, 1)
                                    .withOpacity(0.25),
                                child: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "${gameData['gameType']}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "${creatorUserSnapshot.data['name']}",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                if (creatorUserSnapshot
                                                        .data['uid'] ==
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid)
                                                  PopupMenuButton(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                    ),
                                                    icon: Icon(Icons
                                                        .more_vert_rounded), //don't specify icon if you want 3 dot menu
                                                    color: Colors.black,
                                                    itemBuilder: (context) => [
                                                      PopupMenuItem<int>(
                                                        onTap: () {
                                                          showSettingGameDialog(
                                                              context,
                                                              gameDocument.id);
                                                        },
                                                        value: 0,
                                                        child: Text(
                                                          "Setting",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                      PopupMenuItem<int>(
                                                        value: 1,
                                                        onTap: () {
                                                          _showDialog(
                                                              context,
                                                              widget.roomDocId,
                                                              gameDocument.id);
                                                        },
                                                        child: Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ),
                                                    ],
                                                    onSelected: (item) =>
                                                        {print(item)},
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "• ${gameData['description']}",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Flexible(
                                                flex: 4,
                                                child: Column(
                                                  children: [
                                                    Text(
                                                        "${gameData['leftValue']}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    // if (gameData['closed'] ==
                                                    //     false)
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary:
                                                            Colors.red[400],
                                                      ),
                                                      onPressed: () async => {
                                                        gameData['closed'] ==
                                                                false
                                                            ? await showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return InputCoinForm(
                                                                    gameDocument:
                                                                        gameDocument,
                                                                    userSnapshot:
                                                                        creatorUserSnapshot,
                                                                    roomDocId:
                                                                        widget
                                                                            .roomDocId,
                                                                    button: 0,
                                                                    currentUserCoins:
                                                                        currentUserSnapshot
                                                                            .data['coins'],
                                                                  );
                                                                })
                                                            : null
                                                      },
                                                      child: Container(
                                                          child: Text(
                                                              "${gameData['leftBudget']}",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ))),
                                                    ),
                                                    Text("Odds: $leftOdds"),
                                                  ],
                                                ),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: Column(children: [
                                                  Text("VS",
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 25)),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle),
                                                    child: Text(
                                                        "${gameData['condition']}"),
                                                  ),
                                                ]),
                                              ),
                                              Flexible(
                                                flex: 4,
                                                child: Column(
                                                  children: [
                                                    Text(
                                                        "${gameData['rightValue']}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    // if (gameData['closed'] ==
                                                    //     false)
                                                    ElevatedButton(
                                                      onPressed: () async => {
                                                        gameData['closed'] ==
                                                                false
                                                            ? await showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return InputCoinForm(
                                                                    gameDocument:
                                                                        gameDocument,
                                                                    userSnapshot:
                                                                        creatorUserSnapshot,
                                                                    roomDocId:
                                                                        widget
                                                                            .roomDocId,
                                                                    button: 1,
                                                                    currentUserCoins:
                                                                        currentUserSnapshot
                                                                            .data['coins'],
                                                                  );
                                                                })
                                                            : null
                                                      },
                                                      child: Container(
                                                        child: Text(
                                                            "${gameData['rightBudget']}"),
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary:
                                                                  Colors.blue),
                                                    ),
                                                    Text("Odds: $rightOdds"),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          thickness: 2,
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                      "Prize pool: ${gameDocument['leftBudget'] + gameDocument['rightBudget']}"),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Icon(
                                                      CupertinoIcons
                                                          .money_dollar_circle_fill,
                                                      color: Colors.amber,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              if (gameDocument['closed'] ==
                                                  true)
                                                Container(
                                                  // margin: EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                      color: Colors.red
                                                          .withOpacity(0.10),
                                                      border: Border.all(),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))),
                                                  child: Text(
                                                    'Closed',
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.red),
                                                  ),
                                                ),
                                            ])
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      });
                }).toList());
          }
        });
  }

  _showDialog(BuildContext context, String roomDocId, String gameDocId) {
    VoidCallback continueCallBack = () async => {
          _roomService.deleteGame(roomDocId, gameDocId),
        };
    BlurryDialog alert = BlurryDialog(
        title: "Delete",
        content: "Are you sure you want to delete this game",
        continueCallBack: continueCallBack);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showSettingGameDialog(BuildContext context, String gameDocId) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return UpdateDialog(
            roomDocId: widget.roomDocId,
            gameDocId: gameDocId,
          );
        });
  }
}
