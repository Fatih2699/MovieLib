import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movielib/model/comment_model.dart';
import 'package:movielib/model/user_model.dart';
import 'package:movielib/services/database_base.dart';

class FireStoreDBService implements DBBase {
  final FirebaseFirestore _firebaseDB = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(UserData user) async {
    await _firebaseDB.collection("users").doc(user.userId).set(user.toMap());
    DocumentSnapshot _okunanUser =
        await FirebaseFirestore.instance.doc('users/${user.userId}').get();
    Map<String, dynamic> _okunanUserBilgileriMapi =
        _okunanUser.data() as Map<String, dynamic>;
    UserData _okunanUserBilgileriNesne =
        UserData.fromMap(_okunanUserBilgileriMapi);
    print("Okunan User Nesnesi:" + _okunanUserBilgileriNesne.toString());
    return true;
  }

  @override
  Future<UserData> readUser(String userID) async {
    DocumentSnapshot _okunanUser =
        await _firebaseDB.collection('users').doc(userID).get();
    Map<String, dynamic> _okunanUserBilgileriMap =
        _okunanUser.data() as Map<String, dynamic>;
    UserData _okunanaUserNesnesi = UserData.fromMap(_okunanUserBilgileriMap);
    return _okunanaUserNesnesi;
  }

  @override
  Future<bool> updateUserName(String userId, String newUserName) async {
    var users = await _firebaseDB
        .collection("users")
        .where("displayName", isEqualTo: newUserName)
        .get();
    if (users.docs.isNotEmpty) {
      return false;
    } else {
      await _firebaseDB
          .collection("users")
          .doc(userId)
          .update({'displayName': newUserName});
      return true;
    }
  }

  @override
  Future<bool> updatePhoto(String userID, String photoURL) async {
    await _firebaseDB
        .collection("users")
        .doc(userID)
        .update({'photoURL': photoURL});
    return true;
  }

  @override
  Future<bool> addMovieFavorite(String userID, int movieID, String title,
      String posterPath, List genreIDs, num voteAverage) async {
    await _firebaseDB.collection('users').doc(userID).update({
      "favorite-movies": FieldValue.arrayUnion([
        {
          'id': movieID,
          'title': title,
          'posterPath': posterPath,
          'genres': genreIDs,
          'voteAverage': voteAverage
        }
      ])
    });
    return true;
  }

  @override
  Future<bool> removeFavorite(String userID, int movieID, String title,
      String posterPath, List genreIDs, num voteAverage) async {
    await _firebaseDB.collection('users').doc(userID).update({
      "favorite-movies": FieldValue.arrayRemove([
        {
          'id': movieID,
          'title': title,
          'posterPath': posterPath,
          'genres': genreIDs,
          'voteAverage': voteAverage
        }
      ])
    });
    return true;
  }

  @override
  Future<bool> addWatchLater(String userID, int movieID, String title,
      String posterPath, List genreIDs, num voteAverage, DateTime date) async {
    await _firebaseDB.collection('users').doc(userID).update({
      "watchLater-movies": FieldValue.arrayUnion([
        {
          'id': movieID,
          'title': title,
          'posterPath': posterPath,
          'genres': genreIDs,
          'voteAverage': voteAverage,
          'dateTime': date,
        }
      ])
    });
    return true;
  }

  @override
  Future<bool> removeWatchLater(String userID, int movieID, String title,
      String posterPath, List genreIDs, num voteAverage, DateTime date) async {
    await _firebaseDB.collection('users').doc(userID).update({
      "watchLater-movies": FieldValue.arrayRemove([
        {
          'id': movieID,
          'title': title,
          'posterPath': posterPath,
          'genres': genreIDs,
          'voteAverage': voteAverage,
          'dateTime': date,
        }
      ])
    });
    return true;
  }

  Future<bool> addComment(Comment comment) async {
    var added = await _firebaseDB.collection("comments").add(comment.toMap());
    DocumentSnapshot _okunanComment =
        await FirebaseFirestore.instance.doc('comments/$added').get();
    Map<String, dynamic> _okunanCommentBilgileriMapi =
        _okunanComment.data() as Map<String, dynamic>;
    Comment _okunanCommentBilgileriNesne =
        Comment.fromMap(_okunanCommentBilgileriMapi);
    return true;
  }
}
