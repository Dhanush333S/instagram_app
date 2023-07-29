import 'package:flutter/material.dart';
import 'package:instagram_app/models/user.dart';
import 'package:instagram_app/resources/auth_methods.dart';
class UserProvider with ChangeNotifier{

  final AuthMethods _authMethods=AuthMethods();
  User? _user;
  User get getUser => _user!;

  Future<void> refreshUser() async{
    User user=await _authMethods.getUserdetails();
    _user=user;
    notifyListeners();
  }
}