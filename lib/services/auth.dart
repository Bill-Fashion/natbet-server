import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:natbet/constants.dart';
import 'package:natbet/models/user.dart';
import 'package:natbet/services/toast.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  Toast _toast = Toast();
  UserModel _userFromFireBaseUser(User? user) {
    return UserModel(id: user?.uid);
  }

  Stream<UserModel?> get user {
    return auth.authStateChanges().map(_userFromFireBaseUser);
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

      _userFromFireBaseUser(user.user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        _toast.showToast('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        _toast.showToast('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future signIn(email, password) async {
    try {
      User user = (await auth.signInWithEmailAndPassword(
          email: email, password: password)) as User;

      _userFromFireBaseUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        _toast.showToast('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        _toast.showToast('Wrong password provided for that user.');
      }
    }
  }

  Future signOut() async {
    try {
      return await auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
