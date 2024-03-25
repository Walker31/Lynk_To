import 'package:flutter/material.dart';

class UserDetails {
  final String rollNo;
  final String password;

  UserDetails(this.rollNo, this.password);
}


class UserProvider extends ChangeNotifier {
  UserDetails? _userDetails;

  UserDetails? get userDetails => _userDetails;

  void setUserDetails(String rollNo, String password) {
    _userDetails = UserDetails(rollNo, password);
    notifyListeners();
  }
}
