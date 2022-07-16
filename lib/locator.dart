import 'package:get_it/get_it.dart';
import 'package:movielib/repository/movie_repository.dart';
import 'package:movielib/repository/user_repository.dart';
import 'package:movielib/services/firebase_auth_service.dart';
import 'package:movielib/services/firebase_storage_service.dart';
import 'package:movielib/services/firestore_db_service.dart';

GetIt locator = GetIt.asNewInstance();

void setupLocator() {
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FireStoreDBService());
  locator.registerLazySingleton(() => FirebaseStorageService());
  locator.registerLazySingleton(() => MovieRepository());
}
