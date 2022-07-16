import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movielib/constants/app_constants.dart';
import 'package:movielib/model/user_model.dart';
import 'package:movielib/screens/login_screen.dart';
import 'package:movielib/view_models/user_view_models.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final UserData userData;

  const ProfileScreen({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _controllerUserName = TextEditingController();
  File? _profilFoto;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerUserName = TextEditingController();
  }

  void _galeridenResimSec() async {
    final picker = ImagePicker();
    var _yeniResim = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profilFoto = File(_yeniResim!.path);
    });
  }

  Future<void> _profilFotoGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_profilFoto != null) {
      Fluttertoast.showToast(
          msg: "Profil Fotoğrafınız Güncellendi.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: ApplicationConstants.gri,
          textColor: Colors.white,
          fontSize: 16.0);
      var url = await _userModel.uploadFile(
          _userModel.user.userId, "photoURL", _profilFoto!);
    }
  }

  _userNameGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_userModel.user.displayName != _controllerUserName.text) {
      Fluttertoast.showToast(
          msg: "Kullanıcı Adınız Güncellendi",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: ApplicationConstants.gri,
          textColor: Colors.white,
          fontSize: 16.0);
      return await _userModel.updateUserName(
          _userModel.user.userId, _controllerUserName.text);
    }
  }

  _logOut() async {
    final authService = Provider.of<UserModel>(context, listen: false);
    try {
      await authService.signOut();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false);
      Fluttertoast.showToast(msg: 'Başarıyla Çıkış Yapıldı.');
    } catch (e) {
      debugPrint('HATA VAR' + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    _controllerUserName.text = _userModel.user.displayName!;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        color: ApplicationConstants.lacivert,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const Text(
                      'Profilini Güncelle',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    IconButton(
                      onPressed: () async {
                        AlertDialog alert = AlertDialog(
                          backgroundColor: ApplicationConstants.gri,
                          title: const Text(
                            "Çıkış yapmak istediğine emin misiniz?",
                            style:
                                TextStyle(color: Colors.white60, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Vazgeç'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _logOut();
                                  },
                                  child: const Text('Çıkış Yap'),
                                ),
                              ],
                            ),
                          ],
                        );

                        // show the dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          },
                        );
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 24,
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: DottedBorder(
                    color: ApplicationConstants.mor,
                    padding: const EdgeInsets.all(4),
                    strokeWidth: 2,
                    borderType: BorderType.Oval,
                    dashPattern: const [5, 5],
                    child: Column(
                      children: [
                        Stack(
                          children: <Widget>[
                            InkWell(
                              child: CircleAvatar(
                                backgroundColor: const Color(0XFF4AD0EE),
                                radius: 60,
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 60,
                                  backgroundImage: _profilFoto != null
                                      ? FileImage(_profilFoto!) as ImageProvider
                                      : NetworkImage(_userModel.user.photoURL!),
                                ),
                              ),
                              onTap: () {
                                _galeridenResimSec();
                              },
                            ),
                            Positioned(
                              bottom: 60,
                              right: -10,
                              child: Center(
                                child: IconButton(
                                  color: Colors.white,
                                  icon: const Icon(
                                    Icons.camera_alt_outlined,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    debugPrint('DENEME');
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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
                        controller: _controllerUserName,
                        style: const TextStyle(color: ApplicationConstants.gri),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(20),
                          hintText: _userModel.user.displayName.toString(),
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
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: ApplicationConstants.gri),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(20),
                          hintText: _userModel.user.email,
                          hintStyle: const TextStyle(
                            color: ApplicationConstants.gri,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                SizedBox(
                  width: 214,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      _profilFotoGuncelle(context);
                      _userNameGuncelle(context);
                    },
                    child: const Text(
                      'Kaydet',
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
