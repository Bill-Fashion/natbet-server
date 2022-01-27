import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:natbet/services/chat_provider.dart';
import 'package:natbet/services/room.dart';
import 'package:natbet/widgets/message.dart';

class ChatScreen extends StatefulWidget {
  final ChatProvider chatsProvider;
  final String? roomDocId;
  const ChatScreen({Key? key, required this.chatsProvider, this.roomDocId})
      : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  RoomService _roomService = RoomService();
  ScrollController _scrollController = ScrollController();
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(scrollListener);
    widget.chatsProvider.listenToPosts('${widget.roomDocId}');
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent / 2 &&
        !_scrollController.position.outOfRange) {
      widget.chatsProvider.listenToPosts('${widget.roomDocId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(26, 29, 33, 1),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: ListView(
              controller: _scrollController,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              reverse: true,
              children: [
                ...widget.chatsProvider.chats
                    .map((chat) => ChatMessage(
                          message: chat,
                        ))
                    .toList()
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 50,
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    flex: 5,
                    child: TextFormField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(500),
                      ],
                      controller: _textEditingController,
                      maxLines: 15,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(3.0, 0, 3.0, 0),
                        hintText: 'Write message...',
                        hintStyle: TextStyle(color: Colors.white38),
                        isDense: true,
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        // backgroundColor: Color.fromRGBO(26, 29, 33, 1)
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  FloatingActionButton(
                    backgroundColor: Colors.red,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    splashColor: Colors.blue,
                    onPressed: () {
                      if (_textEditingController.text.isNotEmpty) {
                        print('${_textEditingController.text}');
                        _roomService.sendChat(
                            _textEditingController.text, '${widget.roomDocId}');
                        _textEditingController.clear();
                      }
                    },

                    // elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
