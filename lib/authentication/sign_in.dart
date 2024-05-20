// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:ylorders/authentication/authentiction.dart';
import 'package:ylorders/authentication/reset_password.dart';
import 'package:ylorders/authentication/sign_up.dart';
import 'package:ylorders/functions/core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool opening = false;
  bool isValidGmail = false;
  bool passwordVisibility = false;
  bool is_Web = kIsWeb;
  bool emailCheck = true;
  bool passwordCheck = true;

  bool isGmail(String text) {
    if (text.endsWith("@icloud.com")) {
      return text.endsWith("@icloud.com");
    } else {
      return text.endsWith("@gmail.com");
    }
  }

  bool isCorrectFormat(String text) {
    // Regular expression pattern to check for spaces before "@gmail.com"
    final gmailPattern = RegExp(r"^\S+@gmail\.com$");
    final icloudPattern = RegExp(r"^\S+@icloud\.com$");
    if (icloudPattern.hasMatch(text)) {
      return icloudPattern.hasMatch(text);
    }
    return gmailPattern.hasMatch(text);
  }

  signIn() {
    if (!isValidGmail) {
      is_Web
          ? ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Invalid Gmail')))
          : BusyBeeCore().showToast('Invalid Gmail');
      setState(() {
        emailCheck = false;
      });
    }
    if (password.text.isEmpty) {
      is_Web
          ? ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Enter a password')))
          : BusyBeeCore().showToast('Enter a password');
      setState(() {
        passwordCheck = false;
      });
    }
    if (isValidGmail && password.text.isNotEmpty) {
      try {
        setState(() {
          opening = true;
          passwordCheck = true;
          emailCheck = true;
        });
        FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: email.text, password: password.text)
            .whenComplete(() {
          setState(() {
            opening = false;
          });
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Authentication()),
              (route) => false);
        });
// ignore: unused_catch_clause
      } on FirebaseAuthException catch (e) {
        is_Web
            ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Enter the correct login information')))
            : BusyBeeCore().showToast('Enter the correct login information');
        email.clear();
        password.clear();
        setState(() {
          passwordCheck = false;
          emailCheck = false;
        });
      }
    }
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 3));
    FlutterNativeSplash.remove();
  }

  void cat() {}

  @override
  void initState() {
    super.initState();
    initialization();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BusyBeeCore().getRandomColor(.2),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(
              Icons.hive,
              color: Colors.black,
            ),
            Text('YL Orders',
                style: TextStyle(
                  color: Colors.black,
                )),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: BusyBeeCore().getRandomColor(.2),
          height: MediaQuery.of(context).size.height / 1.1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  child: TextField(
                    controller: email,
                    style: const TextStyle(fontSize: 15),
                    cursorColor: Colors.black,
                    cursorWidth: 1,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: emailCheck ? Colors.green : Colors.red)),
                      label: const Text('Email'),
                      floatingLabelStyle: const TextStyle(color: Colors.black),
                    ),
                    onChanged: (value) {
                      setState(() {
                        isCorrectFormat(email.text)
                            ? emailCheck = true
                            : emailCheck = false;
                        if (isGmail(email.text) &&
                            isCorrectFormat(email.text)) {
                          isValidGmail = true;
                        }
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.29,
                      child: TextField(
                        controller: password,
                        obscureText: !passwordVisibility,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              left: 10, right: 68, bottom: 20, top: 20),
                          label: const Text('Password'),
                          border: const OutlineInputBorder(),
                          floatingLabelStyle:
                              const TextStyle(color: Colors.black),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: passwordCheck
                                      ? Colors.grey
                                      : Colors.red)),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          passwordVisibility = !passwordVisibility;
                        });
                      },
                      child: Container(
                        color: BusyBeeCore().getRandomColor(.3),
                        width: MediaQuery.of(context).size.width / 7,
                        height: MediaQuery.of(context).size.height / 15,
                        child: passwordVisibility
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(top: 50, left: 100, right: 100),
                  child: opening
                      ? Container(
                          decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'Signing in ',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 17,
                                  height:
                                      MediaQuery.of(context).size.height / 30,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : GestureDetector(
                          onTap: () => signIn(),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(20)),
                            child: const Center(
                                child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'Sign in',
                                style: TextStyle(color: Colors.white),
                              ),
                            )),
                          ),
                        )),
              Padding(
                padding: const EdgeInsets.only(top: 30, right: 30),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text('Forgot your password ?'),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ResetPassword()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.black54,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Reset Password',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30, right: 30),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text('Dont have an account ?'),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const CreateAccount()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.black54,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Create Account',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
