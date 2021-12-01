import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:natbet/services/logic.dart';
import 'package:natbet/services/room.dart';
import 'package:natbet/services/user.dart';
import 'package:natbet/widgets/alert_dialog.dart';
import 'package:natbet/widgets/coin_input.dart';
import 'package:natbet/widgets/updategame_diaglog.dart';

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
                            stream: _roomService.getCurrentUserBetting(
                                widget.roomDocId, gameDocument.id),
                            builder: (BuildContext context,
                                AsyncSnapshot userBettingSnapshot) {
                              if (!userBettingSnapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
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
                                    
                                    return Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "${gameData['gameType']}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                  Row(
                                                    children: [
                                                      if (gameData['creator'] ==
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid)
                                                        PopupMenuButton(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                          ),
                                                          icon: Icon(Icons
                                                              .more_vert_rounded),
                                                          color: Colors.black,
                                                          itemBuilder:
                                                              (context) => [
                                                            PopupMenuItem<int>(
                                                              onTap: () {
                                                                _showCloseBetDialog(
                                                                    context,
                                                                    widget
                                                                        .roomDocId,
                                                                    gameDocument
                                                                        .id);
                                                              },
                                                              value: 0,
                                                              child: Text(
                                                                "Close",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                            if (gameDocument[
                                                                    'winner'] ==
                                                                'none')
                                                              PopupMenuItem<
                                                                  int>(
                                                                onTap: () {
                                                                  showSettingGameDialog(
                                                                      context,
                                                                      gameDocument
                                                                          .id);
                                                                },
                                                                value: 0,
                                                                child: Text(
                                                                  "Setting",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            PopupMenuItem<int>(
                                                              value: 1,
                                                              onTap: () {
                                                                _showDeleteDialog(
                                                                    context,
                                                                    widget
                                                                        .roomDocId,
                                                                    gameDocument
                                                                        .id);
                                                              },
                                                              child: Text(
                                                                "Delete",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                            ),
                                                          ],
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
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Flexible(
                                                        flex: 4,
                                                        child: Column(
                                                          children: [
                                                            if (gameData[
                                                                    'winner'] ==
                                                                'Left')
                                                              Text(
                                                                "WIN",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900,
                                                                    color: Colors
                                                                            .amber[
                                                                        400],
                                                                    letterSpacing:
                                                                        2),
                                                              ),
                                                            if (gameData[
                                                                    'winner'] ==
                                                                'Right')
                                                              Text(
                                                                "LOSE",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900,
                                                                    color: Colors
                                                                        .red,
                                                                    letterSpacing:
                                                                        2),
                                                              ),
                                                            Text(
                                                                "${gameData['leftValue']}",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            // if (gameData['closed'] ==
                                                            //     false)
                                                            ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary: Colors
                                                                    .red[400],
                                                              ),
                                                              onPressed:
                                                                  () async => {
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
                                                                            currentPlayerSnapshot:
                                                                                userBettingSnapshot.data,
                                                                            roomDocId:
                                                                                widget.roomDocId,
                                                                            button:
                                                                                0,
                                                                            currentUserCoins:
                                                                                currentUserSnapshot.data['coins'],
                                                                          );
                                                                        })
                                                                    : null
                                                              },
                                                              child: Container(
                                                                  child: Text(
                                                                      "${gameData['leftBudget']}",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                      ))),
                                                            ),
                                                            Text(
                                                                "Odds: ${leftOdds.toStringAsFixed(2)}"),
                                                          ],
                                                        ),
                                                      ),
                                                      Flexible(
                                                        flex: 1,
                                                        child:
                                                            Column(children: [
                                                          Text("VS",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      25)),
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle),
                                                            child: Text(
                                                                "${gameData['condition']}"),
                                                          ),
                                                        ]),
                                                      ),
                                                      Flexible(
                                                        flex: 4,
                                                        child: Column(
                                                          children: [
                                                            if (gameData[
                                                                    'winner'] ==
                                                                'Right')
                                                              Text(
                                                                "WIN",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900,
                                                                    color: Colors
                                                                            .amber[
                                                                        400],
                                                                    letterSpacing:
                                                                        2),
                                                              ),
                                                            if (gameData[
                                                                    'winner'] ==
                                                                'Left')
                                                              Text(
                                                                "LOSE",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900,
                                                                    color: Colors
                                                                        .red,
                                                                    letterSpacing:
                                                                        2),
                                                              ),
                                                            Text(
                                                                "${gameData['rightValue']}",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            
                                                            ElevatedButton(
                                                              onPressed:
                                                                  () async => {
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
                                                                            currentPlayerSnapshot:
                                                                                userBettingSnapshot.data,
                                                                            roomDocId:
                                                                                widget.roomDocId,
                                                                            button:
                                                                                1,
                                                                            currentUserCoins:
                                                                                currentUserSnapshot.data['coins'],
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
                                                                          Colors
                                                                              .blue),
                                                            ),
                                                            Text(
                                                                "Odds: ${rightOdds.toStringAsFixed(2)}"),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              Divider(
                                                thickness: 2,
                                              ),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                            "Prize pool: ${gameDocument['leftBudget'] + gameDocument['rightBudget']}"),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0),
                                                          child: Icon(
                                                            CupertinoIcons
                                                                .money_dollar_circle_fill,
                                                            color: Colors.amber,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    if (gameDocument[
                                                            'closed'] ==
                                                        true)
                                                      Container(
                                                        
                                                        decoration: BoxDecoration(
                                                            color: Colors.red
                                                                .withOpacity(
                                                                    0.10),
                                                            border:
                                                                Border.all(),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            20))),
                                                        child: Text(
                                                          'Closed',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.red),
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
                      });
                }).toList());
          }
        });
  }

  _showCloseBetDialog(
      BuildContext context, String roomDocId, String gameDocId) {
    VoidCallback continueCallBack = () async => {
          _roomService.closeGame(roomDocId, gameDocId),
        };
    BlurryDialog alert = BlurryDialog(
        title: "Close",
        content: "Are you sure you want to close this game",
        continueCallBack: continueCallBack);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _showDeleteDialog(BuildContext context, String roomDocId, String gameDocId) {
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
