import 'package:flutter/material.dart';

class PasswordModel extends ChangeNotifier {

  var isObsecure = true;

  void onTapPassword() {
    isObsecure = !isObsecure;
    notifyListeners();
  }
}