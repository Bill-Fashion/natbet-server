import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:natbet/services/room.dart';
import 'package:natbet/screens/main_screens/card_builder.dart';
import 'package:natbet/widgets/create_game.dart';

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
            floatingActionButton: SpeedDial(
              spacing: 5,
              spaceBetweenChildren: 10,
              animatedIcon: AnimatedIcons.add_event,
              onPress: () {
                showCreateGameDialog(context);
              },
            ),
            //1
            body: CustomScrollView(
              slivers: <Widget>[
                //2
                SliverAppBar(
                  // expandedHeight: 100.0,
                  floating: true,
                  centerTitle: true,
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
                  child: CardBuider(
                    roomDocId: "${widget.roomDocId}",
                  ),
                )
              ],
            ),
          );
        });
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
