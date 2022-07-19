import 'package:movielib/model/user_model.dart';

abstract class DBBase {
  Future<UserData> readUser(String userID);
  Future<bool> saveUser(UserData user);
  Future<bool> updateUserName(String userID, String newUserName);
  Future<bool> updatePhoto(String userID, String photoURL);
  Future<bool> addMovieFavorite(String userID, int movieID, String title,
      String posterPath, List genreIDs, num voteAverage);
  Future<bool> removeFavorite(String userID, int movieID, String title,
      String posterPath, List genreIDs, num voteAverage);
  Future<bool> addWatchLater(String userID, int movieID, String title,
      String posterPath, List genreIDs, num voteAverage, DateTime date);
  Future<bool> removeWatchLater(String userID, int movieID, String title,
      String posterPath, List genreIDs, num voteAverage, DateTime date);
  //Future<bool> addComment(Comment comment);
}
