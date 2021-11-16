import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:natbet/services/utils.dart';

class UserService {
  UtilsService _utilsService = UtilsService();
  Future<void> saveTokenToDatabase(String? token) async {
    // Assume user is logged in for this example
    String userId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'tokens': FieldValue.arrayUnion([token]),
    });
  }

  Future saveAvatar(File postImgUrl) async {
    // ignore: non_constant_identifier_names
    String avatar = '';
    if (postImgUrl != '') {
      avatar = await _utilsService.uploadFile(postImgUrl,
          'user/profile/${FirebaseAuth.instance.currentUser!.uid}/avatar');
    }

    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'avatar': avatar});
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

  Stream<QuerySnapshot> userCharts() {
    return FirebaseFirestore.instance
        .collection('users')
        .orderBy('coins', descending: true)
        .snapshots();
  }

  Future<void> changeUserName(String userName) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'name': userName});
  }
}
