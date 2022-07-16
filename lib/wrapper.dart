// // // import 'package:flutter/material.dart';
// // // import 'package:movielib/model/user_model.dart';
// // // import 'package:movielib/screens/home_screen.dart';
// // // import 'package:movielib/screens/login_screen.dart';
// // // import 'package:movielib/services/auth_service.dart';
// // // import 'package:provider/provider.dart';
// // //
// // // class Wrapper extends StatelessWidget {
// // //   const Wrapper({Key? key}) : super(key: key);
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final authService = Provider.of<AuthService>(context);
// // //     return StreamBuilder<UserData?>(
// // //       stream: authService.user,
// // //       builder: (_, AsyncSnapshot<UserData?> snapshot) {
// // //         if (snapshot.connectionState == ConnectionState.active) {
// // //           final UserData? user = snapshot.data;
// // //           return user == null ? const LoginScreen() : const HomeScreen();
// // //         } else {
// // //           return const Scaffold(
// // //             body: Center(
// // //               child: CircularProgressIndicator(),
// // //             ),
// // //           );
// // //         }
// // //       },
// // //     );
// // //   }
// // // }
import 'package:flutter/material.dart';
import 'package:movielib/screens/login_screen.dart';
import 'package:movielib/screens/profile_screen.dart';
import 'package:movielib/view_models/user_view_models.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    if (_userModel.user == null) {
      return const LoginScreen();
    } else {
      return ProfileScreen(
        userData: _userModel.user,
      );
    }
  }
}
