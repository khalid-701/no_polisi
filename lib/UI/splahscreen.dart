import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:no_polisi/UI/login_page.dart';

class SplashScreenWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    return Scaffold(
      body: Center(
        child: AnimatedSplashScreen(
          splash: Container(
              child: Image.asset('assets/polisi.png'), width: 300, height: 300, ),
          nextScreen: LoginWidget(),
          splashTransition: SplashTransition.rotationTransition,
          duration: 3000,
          backgroundColor: Colors.white70,

        ),
      ),
    );
  }
}
