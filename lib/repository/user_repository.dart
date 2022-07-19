import 'dart:io';

import 'package:movielib/locator.dart';
import 'package:movielib/model/comment_model.dart';
import 'package:movielib/model/user_model.dart';
import 'package:movielib/services/auth_service.dart';
import 'package:movielib/services/firebase_auth_service.dart';
import 'package:movielib/services/firebase_storage_service.dart';
import 'package:movielib/services/firestore_db_service.dart';

class UserRepository implements AuthService {
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();
  final FireStoreDBService _fireStoreDBService = locator<FireStoreDBService>();
  final FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();

  @override
  Future<UserData?> currentUser() async {
    UserData? _user = await _firebaseAuthService.currentUser();
    return await _fireStoreDBService.readUser(_user!.userId);
  }

  @override
  Future<UserData?> createUserWithEmailandPassword(
      String email, String password) async {
    UserData? _user = await _firebaseAuthService.createUserWithEmailandPassword(
        email, password);
    print(_user.toString() + 'userrrrr');
    bool _sonuc = await _fireStoreDBService.saveUser(_user!);
    print(_sonuc);
    if (_sonuc) {
      return await _fireStoreDBService.readUser(_user.userId);
    }
  }

  @override
  Future<UserData?> signInWithEmailandPassword(
      String email, String password) async {
    UserData? _user =
        await _firebaseAuthService.signInWithEmailandPassword(email, password);
    print('suser' + _user.toString());
    return await _fireStoreDBService.readUser(_user!.userId);
  }

  @override
  Future<bool> signOut() async {
    return await _firebaseAuthService.signOut();
  }

  Future<String> uploadFile(
      String userID, String fileType, File profilFoto) async {
    var photoURL =
        await _firebaseStorageService.uploadFile(userID, fileType, profilFoto);
    await _fireStoreDBService.updatePhoto(userID, photoURL);
    return photoURL;
  }

  Future<bool> updateUserName(String userId, String newUserName) async {
    return await _fireStoreDBService.updateUserName(userId, newUserName);
  }

  Future<bool> addMovieFavorite(String userID, int movieID, String title,
      String posterPath, List genreIDs, num voteAverage) async {
    return await _fireStoreDBService.addMovieFavorite(
        userID, movieID, title, posterPath, genreIDs, voteAverage);
  }

  Future<bool> removeFavorite(String userID, int movieID, String title,
      String posterPath, List genreIDs, num voteAverage) async {
    return await _fireStoreDBService.removeFavorite(
        userID, movieID, title, posterPath, genreIDs, voteAverage);
  }

  Future<bool> addWatchLater(String userID, int movieID, String title,
      String posterPath, List genreIDs, num voteAverage, DateTime date) async {
    return await _fireStoreDBService.addWatchLater(
        userID, movieID, title, posterPath, genreIDs, voteAverage, date);
  }

  Future<bool> removeWatchLater(String userID, int movieID, String title,
      String posterPath, List genreIDs, num voteAverage, DateTime date) async {
    return await _fireStoreDBService.removeWatchLater(
        userID, movieID, title, posterPath, genreIDs, voteAverage, date);
  }

  Future<bool> addComment(Comment comment) async {
    return await _fireStoreDBService.addComment(comment);
  }
}
