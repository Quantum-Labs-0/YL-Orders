import 'package:ylorders/authentication/sign_in.dart';
import 'package:ylorders/functions/core.dart';
import 'package:ylorders/store/home.dart';
import 'package:ylorders/store/re-stock.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authentication extends StatelessWidget {
  const Authentication({super.key});

  @override
  Widget build(BuildContext context) {
    double widthLength = MediaQuery.of(context).size.width;
    return widthLength > 450
        ? Scaffold(
            body: Container(
              color: BusyBeeCore().getRandomColor(.2),
              child: Center(
                child: const Text('CURRENTLY AVAILABLE FOR MOBILE ONLY'),
              ),
            ),
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return const Home();
                  } else {
                    return const SignIn();
                  }
                }),
          );
  }
}
