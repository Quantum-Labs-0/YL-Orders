import 'dart:async';

import 'package:ylorders/authentication/authentiction.dart';
import 'package:ylorders/functions/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  Timer? timer;
  Timer? resendTimer;
  static const maxSeconds = 60;
  int seconds = maxSeconds;
  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    startResendTimer();
    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkIsEmailVerified());
    }
  }

  void startResendTimer() {
    resendTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (seconds == 0) {
        setState(() {
          seconds = maxSeconds;
        });
        sendVerificationEmail();
      }
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      }
    });
  }

  Future sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();
  }

  Future checkIsEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const Authentication()
      : SafeArea(
          child: Scaffold(
            body: Container(
              color: BusyBeeCore().getRandomColor(.2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                      'Click the verification link sent to your email to proceed'),
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: const Icon(Icons.mail_outline_outlined),
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                      'Resending verification email in $seconds seconds')),
                            ),
                          )
                        ]),
                  )
                ],
              ),
            ),
          ),
        );
}
