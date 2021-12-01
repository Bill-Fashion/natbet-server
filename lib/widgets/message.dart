import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:natbet/models/chat.dart';
import 'package:natbet/services/user.dart';

class ChatMessage extends StatefulWidget {
  final Chat? message;
  ChatMessage({Key? key, this.message}) : super(key: key);

  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  UserService _userService = UserService();
  @override
  Widget build(BuildContext context) {
    bool isMe =
        widget.message!.sender == FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder(
        stream: _userService.getUserInfo(widget.message!.sender),
        builder: (BuildContext context, AsyncSnapshot userSnapshot) {
          if (!userSnapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
            child: Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isMe) ...[
                  CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(userSnapshot.data['avatar']),
                  ),
                  SizedBox(width: 20 / 2),
                ],
                Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    if (!isMe)
                      Text(
                        userSnapshot.data['name'],
                        style: TextStyle(fontSize: 10),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 250),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20 * 0.75,
                        vertical: 20 / 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(isMe ? 1 : 0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        '${widget.message!.content}',
                        maxLines: 15,
                        style: TextStyle(
                          color: isMe
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
