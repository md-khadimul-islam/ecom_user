import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_user/auth/auth_service.dart';
import 'package:ecom_user/db_helper.dart';
import 'package:ecom_user/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  AppUser? appUser;

  Future<void> addNewUser(User user) {
    final appUser = AppUser(
      id: user.uid,
      email: user.email!,
      userCreationTime: Timestamp.fromDate(user.metadata.creationTime!),
    );
    return DbHelper.addUser(appUser);
  }

  getUserSnapshot () {
    DbHelper.getUserSnapshotInfoById(AuthService.currentUser!.uid).listen((snapshot) {
      appUser = AppUser.fromJson(snapshot.data()!);
      notifyListeners();
    });
  }

  Future<void> updateUserDisplayName(String value) {
    return DbHelper.updateUserField(AuthService.currentUser!.uid, {'displayName' : value});
  }
  
  Future<void> updateUserPhoneNumber(String value) {
    return DbHelper.updateUserField(AuthService.currentUser!.uid, {'phoneNumber' : value});
  }

  Future<AppUser> getUser() async {
    final docSnapshot = await DbHelper.getUserInfoById(AuthService.currentUser!.uid);
    return AppUser.fromJson(docSnapshot.data()!);
  }
}
