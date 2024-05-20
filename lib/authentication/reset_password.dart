import 'package:ylorders/authentication/sign_in.dart';
import 'package:ylorders/functions/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController email = TextEditingController();
  bool isValidGmail = false;
  bool emailCheck = true;

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

  Future sendResetPassword(TextEditingController email) async {
    DocumentSnapshot snapshotEmails = await FirebaseFirestore.instance
        .collection('Emails')
        .doc('Emails')
        .get();
    List emails = snapshotEmails.get('Emails');
    if (emails.contains(email.text.toString())) {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email.text.trim());
      BusyBeeCore().showToast('Password reset link sent to your email');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SignIn()),
          (route) => false);
    } else {
      BusyBeeCore().showToast('No account registered to email');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: BusyBeeCore().getRandomColor(.2),
        elevation: 0,
        title: const Text('Reset Password'),
      ),
      body: Container(
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
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: emailCheck ? Colors.green : Colors.red)),
                    label: Text('Email'),
                    floatingLabelStyle: TextStyle(color: Colors.black),
                  ),
                  onChanged: (value) {
                    setState(() {
                      isCorrectFormat(email.text)
                          ? emailCheck = true
                          : emailCheck = false;
                      if (isGmail(email.text) && isCorrectFormat(email.text)) {
                        isValidGmail = true;
                      }
                    });
                  },
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 50, left: 100, right: 100),
                child: GestureDetector(
                  onTap: () => sendResetPassword(email),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Center(
                        child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Reset Password',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
                  ),
                )),
          ],
        ),
      ),
    ));
  }
}
