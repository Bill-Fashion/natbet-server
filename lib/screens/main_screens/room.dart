import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:natbet/services/chat_provider.dart';
import 'package:natbet/services/room.dart';
import 'package:natbet/screens/main_screens/card_builder.dart';
import 'package:natbet/widgets/bet_history.dart';
import 'package:natbet/widgets/create_game.dart';
import 'package:natbet/widgets/list_chat.dart';
import 'package:provider/provider.dart';

class RoomScreen extends StatefulWidget {
  final String? roomDocId;
  const RoomScreen({Key? key, this.roomDocId}) : super(key: key);
  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  RoomService _roomService = RoomService();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _roomService.getRoomById(widget.roomDocId),
        initialData: null,
        builder: (BuildContext context, AsyncSnapshot roomSnapshot) {
          if (roomSnapshot.hasError) {
            return Text('Something went wrong');
          }

          if (roomSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return Scaffold(
            backgroundColor: Color.fromRGBO(26, 29, 33, 1),
            floatingActionButton: SpeedDial(
              spacing: 5,
              spaceBetweenChildren: 10,
              // animatedIcon: AnimatedIcons.,
              onPress: () => showChatDialog(context),
              icon: Icons.chat,
            ),

            //1
            body: CustomScrollView(
              slivers: <Widget>[
                //2
                SliverAppBar(
                  // expandedHeight: 100.0,
                  floating: true,
                  centerTitle: true,
                  actions: [
                    IconButton(
                      onPressed: () => showHistoryDialog(context),
                      icon: Icon(
                        Icons.history_edu_rounded,
                        color: Colors.red,
                      ),
                    ),
                    IconButton(
                      onPressed: () => showCreateGameDialog(context),
                      icon: Icon(
                        Icons.add,
                        color: Colors.red,
                      ),
                    ),
                  ],
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "${roomSnapshot.data['roomName']}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text("${roomSnapshot.data['rid']}",
                          style: TextStyle(fontSize: 15)),
                    ],
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: Color.fromRGBO(26, 29, 33, 1),
                    ),
                  ),
                ),
                //3
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 55),
                    child: CardBuider(
                      roomDocId: "${widget.roomDocId}",
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  showHistoryDialog(BuildContext context) async {
    return await showGeneralDialog(
      context: context,
      barrierColor: Colors.grey.shade900.withOpacity(0.35), // Background color
      barrierDismissible: false,
      barrierLabel: 'Dialog',
      transitionDuration: Duration(milliseconds: 10),
      pageBuilder: (context, __, ___) {
        // Makes widget fullscreen
        return Dismissible(
          direction: DismissDirection.horizontal,
          onDismissed: (_) {
            Navigator.of(context).pop();
          },
          key: Key("key"),
          child: SafeArea(
            child: SizedBox.expand(
              child: Container(
                color: Colors.transparent,
                child: BetsHistory(
                  roomDocId: widget.roomDocId,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  showChatDialog(BuildContext context) async {
    return await showGeneralDialog(
      context: context,
      barrierColor: Colors.grey.shade900.withOpacity(0.35), // Background color
      barrierDismissible: false,
      barrierLabel: 'Dialog',
      transitionDuration: Duration(milliseconds: 10),
      pageBuilder: (context, __, ___) {
        // Makes widget fullscreen
        return Dismissible(
          direction: DismissDirection.horizontal,
          onDismissed: (_) {
            Navigator.of(context).pop();
          },
          key: Key("key"),
          child: SafeArea(
            child: SizedBox.expand(
              child: Container(
                color: Colors.transparent,
                child: ChangeNotifierProvider(
                  create: (context) => ChatProvider(),
                  child: Consumer<ChatProvider>(
                    builder: (context, chatsProvider, _) => ChatScreen(
                      chatsProvider: chatsProvider,
                      roomDocId: widget.roomDocId,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  showCreateGameDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return CreateGame(
            roomDocId: widget.roomDocId,
            selectedUpdate: false,
          );
        });
  }
}
