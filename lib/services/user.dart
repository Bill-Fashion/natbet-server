import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:natbet/models/user.dart';

class UserService {
  UserModel _userModelFromFirebaseSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
        id: snapshot.id,
        avatarURL: snapshot['avatar'],
        name: snapshot['name'],
        email: snapshot['email'],
        description: snapshot['description']);
  }

  Stream getUserInfo(String? uid) {
    return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
  }

  Future<void> addUserToRoom(String docId) async {
    await FirebaseFirestore.instance.collection('rooms').doc(docId).update({
      'members':
          FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
    });
  }

  Future<void> deductUserCoins(var currentUserCoins, var amountOfCoins) {
    var value = currentUserCoins - amountOfCoins;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'coins': value});
  }

  Future<void> addUserCoins(var currentUserCoins, var amountOfCoins) {
    var value = currentUserCoins + amountOfCoins;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'coins': value});
  }
}
