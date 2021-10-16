import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:natbet/models/room.dart';
import 'package:natbet/services/toast.dart';
import 'package:natbet/widgets/create_game.dart';

class RoomService {
  CollectionReference rooms = FirebaseFirestore.instance.collection('rooms');
  final roomsRef = FirebaseFirestore.instance
      .collection('rooms')
      .withConverter<RoomModel>(
        fromFirestore: (snapshot, _) => RoomModel.fromJson(snapshot.data()!),
        toFirestore: (movie, _) => movie.toJson(),
      );

  Future<void> createRoom(String roomName, String? password) {
    // Call the user's CollectionReference to add a new user
    if (password == '') {
      return rooms
          .add({
            'creator': FirebaseAuth.instance.currentUser!.uid,
            'roomName': roomName,
            // 'password': '',
            'rid': DateTime.now().millisecondsSinceEpoch % 1000000,
            'members': [FirebaseAuth.instance.currentUser!.uid]
          })
          .then((value) => Toast().showToast("Create success"))
          .catchError(
              (error) => Toast().showToast("Failed to add user: $error"));
    } else {
      return rooms
          .add({
            'creator': FirebaseAuth.instance.currentUser!.uid,
            'roomName': roomName,
            'password': password,
            'rid': DateTime.now().millisecondsSinceEpoch % 1000000,
            'members': [FirebaseAuth.instance.currentUser!.uid]
          })
          .then((value) => Toast().showToast("Create success"))
          .catchError(
              (error) => Toast().showToast("Failed to add user: $error"));
    }
  }

  List<RoomModel> _roomListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
      print("data trong roomList day ${data['password']}");
      return RoomModel(
          creator: data['creator'],
          rname: data['roomName'],
          rpassword: data['password'],
          rid: data['rid'],
          members: data['members']);
    }).toList();
  }

  Stream<QuerySnapshot> getRooms() {
    return FirebaseFirestore.instance.collection('rooms').snapshots();
  }

  Stream getRoomById(String? rDocId) {
    return FirebaseFirestore.instance
        .collection('rooms')
        .doc(rDocId)
        .snapshots();
  }

  Future<void> createGame(
    String roomDocId,
    String gameType,
    String description,
    String leftValue,
    String rightValue,
    String condition,
  ) {
    CollectionReference game = FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomDocId)
        .collection("games");
    return game
        .add({
          'winner': 'none',
          'gameType': gameType,
          'description': description,
          'creator': FirebaseAuth.instance.currentUser!.uid,
          'leftValue': leftValue,
          'leftBudget': 0,
          'rightValue': rightValue,
          'rightBudget': 0,
          'closed': false,
          'condition': condition
        })
        .then((value) => Toast().showToast("Create success"))
        .catchError((error) => Toast().showToast("Failed to add user: $error"));
  }

  Future<void> updateGame(
    String roomDocId,
    String gameDocId,
    String winner,
  ) {
    DocumentReference game = FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomDocId)
        .collection("games")
        .doc(gameDocId);
    return game
        .update({'winner': winner, 'closed': true})
        .then((value) => Toast().showToast("Update success"))
        .catchError((error) => Toast().showToast("Failed to add user: $error"));
  }

  Future<void> updateCurrentUserLeftBetCoin(
    String roomDocId,
    String gameDocId,
  ) {
    DocumentReference game = FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomDocId)
        .collection("games")
        .doc(gameDocId);
    return game.update({
      'leftPlayers.${FirebaseAuth.instance.currentUser!.uid}': 0
    }).catchError((error) => Toast().showToast("Failed to add user: $error"));
  }

  Future<void> updateCurrentUserRightBetCoin(
    String roomDocId,
    String gameDocId,
  ) {
    DocumentReference game = FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomDocId)
        .collection("games")
        .doc(gameDocId);
    return game.update({
      'rightPlayers.${FirebaseAuth.instance.currentUser!.uid}': 0
    }).catchError((error) => Toast().showToast("Failed to add user: $error"));
  }

  Stream<QuerySnapshot> getGamesByRoom(roomDocId) {
    return FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomDocId)
        .collection('games')
        .snapshots();
  }

  Future<void> leftBetting(String roomDocId, String gameDocId,
      int currentUserBetValue, var leftBudget) async {
    print(currentUserBetValue.runtimeType);
    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomDocId)
        .collection("games")
        .doc(gameDocId)
        .update({'leftBudget': leftBudget});

    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomDocId)
        .collection("games")
        .doc(gameDocId)
        .update({
      'leftPlayers.${FirebaseAuth.instance.currentUser!.uid}':
          currentUserBetValue
    });
  }

  Future<void> rightBetting(String roomDocId, String gameDocId,
      int currentUserBetValue, var rightBudget) async {
    print(currentUserBetValue.runtimeType);
    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomDocId)
        .collection("games")
        .doc(gameDocId)
        .update({'rightBudget': rightBudget});

    await FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomDocId)
        .collection("games")
        .doc(gameDocId)
        .update({
      'rightPlayers.${FirebaseAuth.instance.currentUser!.uid}':
          currentUserBetValue
    });
  }

  // CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> deleteGame(var roomDocId, var gameDocId) {
    return rooms
        .doc(roomDocId)
        .collection('games')
        .doc(gameDocId)
        .delete()
        .then((value) => Toast().showToast("Delete success"))
        .catchError(
            (error) => Toast().showToast("Failed to delete user: $error"));
  }
}
