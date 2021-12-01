import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:natbet/services/user.dart';

class HistoryUser extends StatefulWidget {
  final Map<String, dynamic> userData;
  final DocumentSnapshot gameDocument;
  final int sideWin;

  // final String? roomDocId;
  const HistoryUser(
      {Key? key,
      required this.userData,
      required this.gameDocument,
      required this.sideWin})
      : super(key: key);
  @override
  _HistoryUserState createState() => _HistoryUserState();
}

class _HistoryUserState extends State<HistoryUser> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: UserService().getUserInfo(widget.gameDocument.id),
        builder: (BuildContext context, AsyncSnapshot userSnapshot) {
          if (userSnapshot.hasError) {
            return Text('Something went wrong');
          }

          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          } else {
            if (widget.sideWin == 0) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "• ${userSnapshot.data['name']}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "-${widget.userData['leftBetBudget']}",
                    style: TextStyle(color: Colors.white54),
                  ),
                  Text(
                    "+${widget.userData['leftPrize']}",
                    style: TextStyle(color: Colors.yellow),
                  ),
                ],
              );
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "• ${userSnapshot.data['name']}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "-${widget.userData['rightBetBudget']}",
                    style: TextStyle(color: Colors.white54),
                  ),
                  Text(
                    "+${widget.userData['rightPrize']}",
                    style: TextStyle(color: Colors.yellow),
                  ),
                ],
              );
            }
          }
        });
  }
}
