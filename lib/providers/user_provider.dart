import 'package:ecomuser/auth/authservice.dart';
import 'package:ecomuser/db/db_helper.dart';
import 'package:ecomuser/models/user_model.dart';
import 'package:flutter/widgets.dart';

class UserProvider extends ChangeNotifier {
  UserModel? userModel;

  Future<void> addUser(UserModel userModel) {
    return DbHelper.addUser(userModel);
  }

  Future<bool> doesUserExist(String uid) {
    return DbHelper.doesUserExist(uid);
  }

  getUserInfo() {
    DbHelper.getUserInfo(AuthService.currentUser!.uid).listen((snapshot) {
      userModel = UserModel.fromMap(snapshot.data()!);
      notifyListeners();
    });
  }

  Future<void> updateUserProfileField(String field, dynamic value) =>
      DbHelper.updateUserProfileField(
          AuthService.currentUser!.uid, {field: value});
}
