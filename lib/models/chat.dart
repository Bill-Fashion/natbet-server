import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String? content;
  final String? sender;
  final Timestamp? timestamp;
  final String? chatId;

  const Chat({this.content, this.sender, this.timestamp, this.chatId});
  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'sender': sender,
      'timestamp': timestamp,
      'id': chatId
    };
  }

  static Chat fromMap(Map<String, dynamic> map, String documentId) {
    return Chat(
      content: map['content'],
      sender: map['sender'],
      timestamp: map['timestamp'],
      chatId: documentId,
    );
  }
}
