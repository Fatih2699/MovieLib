import 'package:movielib/model/user_model.dart';

abstract class AuthService {
  Future<UserData?> currentUser();
  Future<bool>signOut();
  Future<UserData?> signInWithEmailandPassword(String email, String password);
  Future<UserData?> createUserWithEmailandPassword(
      String email, String password);
}
