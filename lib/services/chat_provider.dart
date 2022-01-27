import 'package:flutter/material.dart';
import 'package:natbet/models/chat.dart';
import 'package:natbet/services/room.dart';

class ChatProvider extends ChangeNotifier {
  bool _disposed = false;
  RoomService _roomService = RoomService();
  List<Chat> _chats = [];
  List<Chat> get chats => _chats;
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  void listenToPosts(String roomId) {
    _roomService.listenToChatsRealTime(roomId).listen((chatsData) {
      if (chatsData != null && chatsData.length > 0) {
        _chats = chatsData;
        _chats.sort((a, b) {
          var adate = a.timestamp;
          var bdate = b.timestamp;
          return bdate!.compareTo(adate!);
        });
        notifyListeners();
      }
      notifyListeners();
    });
  }
}
