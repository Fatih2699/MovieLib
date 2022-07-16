import 'dart:math';

class UserData {
  final String userId;
  final String email;
  String? photoURL;
  String? displayName;
  List favoriteMovies = [];
  List watchLaterMovies = [];
  UserData(this.userId, this.email, this.photoURL, this.displayName);

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'photoURL': photoURL ??
          'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png',
      'displayName': displayName ??
          email.substring(0, email.indexOf('@')) + randomSayiUret(),
      'favorite-movies': favoriteMovies,
      'watchLater-movies': watchLaterMovies
    };
  }

  UserData.fromMap(Map<String, dynamic> map)
      : userId = map['userId'],
        email = map['email'],
        photoURL = map['photoURL'],
        displayName = map['displayName'],
        favoriteMovies = map['favorite-movies'],
        watchLaterMovies = map['watchLater-movies'];

  @override
  String toString() {
    return 'UserData{userID: $userId, email: $email, displayName: $displayName, photoURL: $photoURL,favorite-movies:$favoriteMovies,watchLater-movies:$watchLaterMovies}';
  }

  String randomSayiUret() {
    int rastgeleSayi = Random().nextInt(999999);
    return rastgeleSayi.toString();
  }
}
