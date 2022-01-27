import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:natbet/services/room.dart';
import 'package:natbet/widgets/history_user.dart';

class BetsHistory extends StatefulWidget {
  // final HistoryProvider chatsProvider;
  final String? roomDocId;
  const BetsHistory({Key? key, this.roomDocId}) : super(key: key);
  @override
  _BetsHistoryState createState() => _BetsHistoryState();
}

class _BetsHistoryState extends State<BetsHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(26, 29, 33, 1),
      body: StreamBuilder<QuerySnapshot>(
          stream: RoomService().getHistoriesByRoom(widget.roomDocId),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> gameSnapshot) {
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
                        stream: RoomService().getUsersBettingHistory(
                            widget.roomDocId, gameDocument.id),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> userSnapshot) {
                          if (userSnapshot.hasError) {
                            return Text('Something went wrong');
                          }
                          if (userSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text("Loading");
                          }

                          return ExpansionTile(
                            expandedAlignment: Alignment.centerLeft,
                            expandedCrossAxisAlignment:
                                CrossAxisAlignment.start,
                            title: Text(
                              "${gameData['gameType']}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "${gameData['description']}",
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 15, color: Colors.white60),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("${gameData['leftValue']}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    if (gameData['winner'] == 'Left')
                                      Text("WIN",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.amber,
                                          )),
                                    if (gameData['winner'] == 'Right')
                                      Text("LOSE",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          )),
                                    Text(
                                        "Odds: ${gameData['leftOdds'].toStringAsFixed(2)}")
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: userSnapshot.data!.docs
                                        .map((DocumentSnapshot gameDocument) {
                                      Map<String, dynamic> userData =
                                          gameDocument.data()!
                                              as Map<String, dynamic>;
                                      return Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: HistoryUser(
                                          userData: userData,
                                          gameDocument: gameDocument,
                                          sideWin: gameData['winner'] == 'Left'
                                              ? 0
                                              : 1,
                                        ),
                                      );
                                    }).toList()),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("${gameData['rightValue']}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    if (gameData['winner'] == 'Right')
                                      Text("WIN",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.amber,
                                          )),
                                    if (gameData['winner'] == 'Left')
                                      Text("LOSE",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          )),
                                    Text(
                                        "Odds: ${gameData['rightOdds'].toStringAsFixed(2)}")
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: userSnapshot.data!.docs
                                        .map((DocumentSnapshot gameDocument) {
                                      Map<String, dynamic> userData =
                                          gameDocument.data()!
                                              as Map<String, dynamic>;
                                      return Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: HistoryUser(
                                          userData: userData,
                                          gameDocument: gameDocument,
                                          sideWin: gameData['winner'] == 'Left'
                                              ? 1
                                              : 0,
                                        ),
                                      );
                                    }).toList()),
                              ),
                            ],
                          );
                        });
                  }).toList());
            }
          }),
    );
  }
}
