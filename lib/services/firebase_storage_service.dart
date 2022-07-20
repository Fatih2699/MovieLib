import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:movielib/services/storage_base.dart';

class FirebaseStorageService implements StorageBase {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Reference? _storageReference;
  @override
  Future<String> uploadFile(
      String userId, String fileType, File yuklenecekDosya) async {
    String fileName = DateTime.now().toIso8601String() + '_profile.png';
    _storageReference =
        _firebaseStorage.ref().child(userId).child(fileType).child(fileName);
    var uploadTask = _storageReference?.putFile(yuklenecekDosya);
    var url = (await uploadTask!.whenComplete(
            () => debugPrint("İŞLEM GERÇEKLEŞTİ: " + userId.toString())))
        .ref
        .getDownloadURL();
    return url;
  }
}
