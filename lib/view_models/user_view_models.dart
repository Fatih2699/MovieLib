import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movielib/locator.dart';
import 'package:movielib/model/user_model.dart';
import 'package:movielib/repository/user_repository.dart';
import 'package:movielib/services/auth_service.dart';

class UserModel with ChangeNotifier implements AuthService {
  final UserRepository _userRepository = locator<UserRepository>();
  UserData? _user;

  UserData get user => _user!;

  UserModel() {
    currentUser();
  }
  @override
  Future<UserData?> currentUser() async {
    try {
      _user = await _userRepository.currentUser();
      return _user!;
    } catch (e) {
      debugPrint(
        "USER VIEW MODEL CURRENT USER HATA ÇIKTI: " + e.toString(),
      );
      return null;
    }
  }

  @override
  Future<UserData?> createUserWithEmailandPassword(
      String email, String sifre) async {
    try {
      _user =
          await _userRepository.createUserWithEmailandPassword(email, sifre);
      return _user;
    } catch (e) {
      debugPrint('UserViewMODEL createUserWithEmailandPassword HATA VAR: ' +
          e.toString());
    }
    return null;
  }

  @override
  Future<UserData?> signInWithEmailandPassword(
      String email, String sifre) async {
    try {
      _user = await _userRepository.signInWithEmailandPassword(email, sifre);
      debugPrint('USERRRRRR: ' + _user.toString());
      return _user;
    } catch (e) {
      debugPrint(
          'UserViewMODEL signInWithEmailandPassword HATA VAR' + e.toString());
    }
    return null;
  }

  @override
  Future<bool> signOut() async {
    try {
      bool sonuc = await _userRepository.signOut();
      _user = null;
      return sonuc;
    } catch (e) {
      debugPrint('userview MODEL SignOut hata çıktı: ' + e.toString());
      return false;
    }
  }

  Future<String> uploadFile(
      String userID, String fileType, File profilFoto) async {
    var indirmeLink =
        await _userRepository.uploadFile(userID, fileType, profilFoto);
    return indirmeLink;
  }

  Future<bool> updateUserName(String userId, String newUserName) async {
    var result = await _userRepository.updateUserName(userId, newUserName);
    if (result) {
      _user!.displayName = newUserName;
    }
    return result;
  }

  Future<bool> addMovieFavorite(String userID, int movieID, String title,
      String posterPath, List genreIDs, num voteAverage) async {
    var result = await _userRepository.addMovieFavorite(
        userID, movieID, title, posterPath, genreIDs, voteAverage);
    return result;
  }

  Future<bool> removeFavorite(String userID, int movieID, String title,
      String posterPath, List genreIDs, num voteAverage) async {
    var result = await _userRepository.removeFavorite(
        userID, movieID, title, posterPath, genreIDs, voteAverage);
    return result;
  }

  Future<bool> addWatchLater(String userID, int movieID, String title,
      String posterPath, List genreIDs, num voteAverage, DateTime date) async {
    var result = await _userRepository.addWatchLater(
        userID, movieID, title, posterPath, genreIDs, voteAverage, date);
    return result;
  }

  Future<bool> removeWatchLater(String userID, int movieID, String title,
      String posterPath, List genreIDs, num voteAverage, DateTime date) async {
    var result = await _userRepository.removeWatchLater(
        userID, movieID, title, posterPath, genreIDs, voteAverage, date);
    return result;
  }
}
