import 'package:flutter/material.dart';

class LoadingModel extends ChangeNotifier{

  var loading = false;

  void onLoading()
  {
    loading = !loading;
    notifyListeners();
  }

}