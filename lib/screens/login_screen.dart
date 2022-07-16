import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movielib/constants/app_constants.dart';
import 'package:movielib/screens/home_screen.dart';
import 'package:movielib/screens/register_screen.dart';
import 'package:movielib/view_models/user_view_models.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<UserModel>(context);
    validateForm() async {
      if (emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        try {
          await authService.signInWithEmailandPassword(
              emailController.text, passwordController.text);
          return Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(
                  //userData: authService.user,
                  ),
            ),
          );
        } catch (e) {
          debugPrint(e.toString());
        }
      } else {
        return Fluttertoast.showToast(
          msg: 'E-mail veya şifre boş olamaz',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      try {
        await authService.signInWithEmailandPassword(
            emailController.text, passwordController.text);
        return Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(
                //userData: authService.user,
                ),
          ),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          return Fluttertoast.showToast(
            msg: 'E-mail veya şifre hatalı',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.blueGrey,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      }
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: ApplicationConstants.lacivert,
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 30),
                  child: const Text(
                    'Tekrar Hoşgeldin',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      color: ApplicationConstants.lacivert,
                      child: Center(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: ApplicationConstants.mavi,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 60.0,
                          width: 330,
                          child: TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                                color: ApplicationConstants.gri),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(top: 14.0),
                              prefixIcon: Icon(
                                Icons.alternate_email_rounded,
                                color: Colors.white,
                              ),
                              hintText: "Email",
                              hintStyle: TextStyle(
                                color: ApplicationConstants.gri,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 20,
                    ),
                    Container(
                      color: ApplicationConstants.lacivert,
                      child: Center(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: ApplicationConstants.mavi,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          height: 60.0,
                          width: 330,
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: _obscureText,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                                color: ApplicationConstants.gri),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(top: 14.0),
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Colors.white,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              hintText: "Şifre",
                              hintStyle: const TextStyle(
                                color: ApplicationConstants.gri,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Şifremi Unuttum',
                      style: TextStyle(color: ApplicationConstants.mor),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 300,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Hesabınız Yok mu ',
                      style: TextStyle(color: ApplicationConstants.gri),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Kayıt ol',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 214,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      validateForm();
                    },
                    child: const Text(
                      'Giriş Yap',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: ApplicationConstants.mor,
                      padding: const EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
