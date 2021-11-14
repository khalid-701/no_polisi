import 'package:flutter/material.dart';
import 'package:no_polisi/UI/home_page.dart';
import 'package:no_polisi/UI/login_page.dart';
import 'package:no_polisi/UI/register.dart';
import 'package:no_polisi/UI/splahscreen.dart';
import 'package:no_polisi/drawer/list_plat.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      "home_page" : (context) =>HomeWidget(),
      "login_page" : (context) =>LoginWidget(),
      "register_page" : (context) => RegisterWidget(),
       "list_page" : (context) => ListPlat(),
    },

    home: SplashScreenWidget(),
  ));
}

