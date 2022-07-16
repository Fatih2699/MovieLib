import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movielib/constants/app_constants.dart';
import 'package:movielib/screens/login_screen.dart';
import 'package:movielib/view_models/user_view_models.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _cPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _checkpassword() {
      if (_cPasswordController.text == _passwordController.text) {
        return true;
      } else {
        return false;
      }
    }

    final authService = Provider.of<UserModel>(context);
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
                    'Kayıt ol ve Başla',
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
                            controller: _emailController,
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
                            controller: _passwordController,
                            obscureText: _obscureText,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                                color: ApplicationConstants.gri),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.only(top: 14.0),
                              prefixIcon: const Icon(
                                Icons.lock,
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
                            controller: _cPasswordController,
                            obscureText: true,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                                color: ApplicationConstants.gri),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(top: 14.0),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.white,
                              ),
                              hintText: "Şifre Tekrar",
                              hintStyle: TextStyle(
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
                const SizedBox(
                  height: 200,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Zaten hesabım var.',
                      style: TextStyle(color: ApplicationConstants.gri),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Giriş Yap',
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
                    onPressed: () async {
                      if (_checkpassword().toString() == true.toString()) {
                        try {
                          await authService.createUserWithEmailandPassword(
                              _emailController.text, _passwordController.text);
                          Fluttertoast.showToast(
                              msg: "İşlem Başarılı",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3,
                              backgroundColor: ApplicationConstants.gri,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        } catch (e) {
                          return debugPrint(
                              'GİRİŞ YAP HATA VAR' + e.toString());
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "Girdiğiniz şifreler eşleşmiyor",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 3,
                            backgroundColor: ApplicationConstants.gri,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    child: const Text(
                      'Kayıt Ol',
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
