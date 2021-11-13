import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:natbet/constants.dart';
import 'package:natbet/services/toast.dart';

class AuthService extends ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  Toast _toast = Toast();

  bool isLoggedIn() {
    return auth.currentUser != null;
  }

  String? userId() {
    return auth.currentUser?.uid;
  }

  String? email() {
    return auth.currentUser?.email;
  }

  Future signUp(name, email, password) async {
    try {
      UserCredential user = (await auth.createUserWithEmailAndPassword(
          email: email, password: password));

      final uid = user.user!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.user!.uid)
          .set({
        'name': name,
        'email': email,
        'uid': uid,
        'avatar': defaultAvatarImg,
        'coins': 100000,
      });
      notifyListeners();
      print(auth.currentUser != null);
      // _userFromFireBaseUser(user.user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _toast.showToast('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _toast.showToast('The account already exists for that email.');
      }
    } catch (e) {
      _toast.showToast('$e');
    }
  }

  Future signIn(email, password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      // _userFromFireBaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _toast.showToast('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _toast.showToast('Wrong password provided for that user.');
      }
    }
  }

  Future signOut() async {
    try {
      await auth.signOut();
      notifyListeners();
    } catch (e) {
      _toast.showToast(e.toString());
      return null;
    }
  }
}
