import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movielib/model/user_model.dart';
import 'package:movielib/services/auth_service.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserData?> currentUser() async {
    try {
      User? user = _firebaseAuth.currentUser;
      return _userFromFirebase(user!);
    } catch (e) {
      debugPrint(
          'FirebaseAuthService HATA ÇIKTI CURRENT USER: ' + e.toString());
    }
    return null;
  }

  UserData? _userFromFirebase(User? user) {
    debugPrint(user.toString() + 'userfrmdb');
    if (user == null) {
      return null;
    } else {
      return UserData(user.uid, user.email!, user.photoURL, user.displayName);
    }
  }

  @override
  Future<UserData?> createUserWithEmailandPassword(
      String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(userCredential.user);
  }

  @override
  Future<UserData?> signInWithEmailandPassword(
      String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(userCredential.user!);
  }

  @override
  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      debugPrint('HATA VAR firebase_auth SIGNOUT: ' + e.toString());
      return false;
    }
  }
}
