import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:ylorders/authentication/sign_in.dart';
import 'package:ylorders/authentication/verify_email.dart';
import 'package:ylorders/functions/core.dart';
import 'package:ylorders/legal/privacy_policy.dart';
import 'package:ylorders/legal/terms_and_conditions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  bool usernameCheck = true;
  bool emailCheck = false;
  bool passwordCheck = true;
  bool confirmPasswordCheck = true;

  bool creating = false;
  bool termsAndConditions = false;
  bool privacyPolicy = false;
  bool clearedToCreate = false;
  File? image;
  String? imageName;
  String imageURL = '';
  bool isValidEmail = false;
  bool passwordVisibility = false;
  bool confirmPasswordVisibility = false;
  bool is_web = kIsWeb;

  bool isEmail(String text) {
    if (text.endsWith("@icloud.com")) {
      return text.endsWith("@icloud.com");
    }
    return text.endsWith("@gmail.com");
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

  Future signUp(File image) async {
    await BusyBeeCore().checkExistance();
    DocumentSnapshot snapshotNames =
        await FirebaseFirestore.instance.collection('Names').doc('Names').get();
    DocumentSnapshot snapshotEmails = await FirebaseFirestore.instance
        .collection('Emails')
        .doc('Emails')
        .get();
    List emails = snapshotEmails.get('Emails');
    DocumentReference namesDocument =
        FirebaseFirestore.instance.collection('Names').doc('Names');
    List names = snapshotNames.get('Names');
    DocumentReference emailsDocument =
        FirebaseFirestore.instance.collection('Emails').doc('Emails');
    if (names.contains(username.text)) {
      setState(() {
        clearedToCreate = false;
        usernameCheck = false;
      });
      is_web
          ? ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Username already in use')))
          : BusyBeeCore().showToast('Username already in use');
    }
    if (!isValidEmail) {
      is_web
          ? ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Invalid Gmail')))
          : BusyBeeCore().showToast('Invalid Gmail');
      setState(() {
        emailCheck = false;
      });
    }
    if (emails.contains(email.text)) {
      setState(() {
        clearedToCreate = false;
        emailCheck = false;
      });
      is_web
          ? ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Email is already registered')))
          : BusyBeeCore().showToast('Email is already registered');
    }
    if (username.text.isEmpty) {
      is_web
          ? ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Enter a username')))
          : BusyBeeCore().showToast('Enter a username');
      setState(() {
        usernameCheck = false;
      });
    }
    if (password.text != confirmPassword.text) {
      is_web
          ? ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Passwords do not match')))
          : BusyBeeCore().showToast('Passwords do not match');
      setState(() {
        confirmPasswordCheck = false;
      });
    }
    if (username.text == '') {
      is_web
          ? ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Invalid username')))
          : BusyBeeCore().showToast('Invalid username');
      setState(() {
        usernameCheck = false;
      });
    }
    if (password.text.length < 10) {
      is_web
          ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Password must be aleast 10 characters')))
          : BusyBeeCore().showToast('Password must be aleast 10 characters');
      setState(() {
        passwordCheck = false;
      });
    }
    if (!names.contains(username.text) &&
        !emails.contains(email.text) &&
        username.text.isNotEmpty &&
        username.text != '' &&
        isValidEmail &&
        password.text.length > 9) {
      setState(() {
        clearedToCreate = true;
        usernameCheck = true;
        emailCheck = true;
        passwordCheck = true;
        confirmPasswordCheck = true;
      });
    }
    if (clearedToCreate) {
      setState(() {
        creating = true;
      });

      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text, password: password.text)
          .whenComplete(() async {
        final uid = FirebaseAuth.instance.currentUser!.uid;
        final path = 'Profile pictures/$uid/$imageName';
        final file = File(image.path);

        final ref = FirebaseStorage.instance.ref().child(path);
        final uploadTask = ref.putFile(file);

        final snapshot = await uploadTask.whenComplete(() {
          // print('Upload Complete');
        });
        final url = await snapshot.ref.getDownloadURL();
        FirebaseFirestore.instance
            .collection('Profiles')
            .doc(uid)
            .set({
              'Profile Picture': url.toString(),
              'Profile Picture Name': imageName.toString(),
              'Private': false,
              'Bio': '',
              'Opened Menu': false,
              'Phone Number': '',
              'Username': username.text,
              'Email': email.text,
              'UID': uid.toString(),
              'App Settings': {}
            })
            .then((value) => BusyBeeCore()
                .createAccountProfile(email, username, uid, termsAndConditions))
            .whenComplete(() {
              namesDocument.update({
                'Names': FieldValue.arrayUnion([username.text])
              });
              emailsDocument.update({
                'Emails': FieldValue.arrayUnion([email.text])
              });
              setState(() {
                creating = false;
              });
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const VerifyEmail()),
                  (route) => false);
            });
      });
    }
  }

  Future signUpWithoutImage() async {
    await BusyBeeCore().checkExistance();
    DocumentSnapshot snapshotNames =
        await FirebaseFirestore.instance.collection('Names').doc('Names').get();
    DocumentSnapshot snapshotEmails = await FirebaseFirestore.instance
        .collection('Emails')
        .doc('Emails')
        .get();

    DocumentReference namesDocument =
        FirebaseFirestore.instance.collection('Names').doc('Names');
    List names = snapshotNames.get('Names');
    DocumentReference emailsDocument =
        FirebaseFirestore.instance.collection('Emails').doc('Emails');
    List emails = snapshotEmails.get('Emails');

    if (names.contains(username.text)) {
      setState(() {
        clearedToCreate = false;
        usernameCheck = false;
      });
      is_web
          ? ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Username already in use')))
          : BusyBeeCore().showToast('Username already in use');
    }
    if (!isValidEmail) {
      is_web
          ? ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Invalid Gmail')))
          : BusyBeeCore().showToast('Invalid Gmail');
      setState(() {
        emailCheck = false;
      });
    }
    if (emails.contains(email.text)) {
      setState(() {
        clearedToCreate = false;
        emailCheck = false;
      });
      is_web
          ? ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Email is already registered')))
          : BusyBeeCore().showToast('Email is already registered');
    }
    if (username.text.isEmpty) {
      is_web
          ? ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Enter a username')))
          : BusyBeeCore().showToast('Enter a username');

      setState(() {
        usernameCheck = false;
      });
    }
    if (username.text == '') {
      is_web
          ? ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Invalid username')))
          : BusyBeeCore().showToast('Invalid username');
      setState(() {
        usernameCheck = false;
      });
    }
    if (password.text.length < 10) {
      is_web
          ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Password must be aleast 10 characters')))
          : BusyBeeCore().showToast('Password must be aleast 10 characters');
      setState(() {
        passwordCheck = false;
      });
    }
    if (!names.contains(username.text) &&
        !emails.contains(email.text) &&
        username.text.isNotEmpty &&
        username.text != '' &&
        isValidEmail &&
        password.text.length > 9) {
      setState(() {
        clearedToCreate = true;
        usernameCheck = true;
        emailCheck = true;
        passwordCheck = true;
        confirmPasswordCheck = true;
      });
    }
    if (clearedToCreate) {
      setState(() {
        creating = true;
      });
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text, password: password.text)
          .whenComplete(() async {
        final uid = FirebaseAuth.instance.currentUser!.uid;
        FirebaseFirestore.instance
            .collection('Profiles')
            .doc(uid)
            .set({
              'Profile Picture': '',
              'Profile Picture Name': '',
              'Private': false,
              'Bio': '',
              'Opened Menu': false,
              'Username': username.text,
              'Phone Number': '',
              'Email': email.text,
              'UID': uid.toString(),
              'App Settings': {}
            })
            .then((value) => BusyBeeCore()
                .createAccountProfile(email, username, uid, termsAndConditions))
            .whenComplete(() {
              namesDocument.update({
                'Names': FieldValue.arrayUnion([username.text])
              });
              emailsDocument.update({
                'Emails': FieldValue.arrayUnion([email.text])
              });
              setState(() {
                creating = false;
              });
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const VerifyEmail()),
                  (route) => false);
            });
      });
    }
  }

  updateMenuStatus() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('Profiles').doc(uid).update({
      'Opened Menu': true,
    });
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker()
          .pickImage(source: source, requestFullMetadata: true);
      if (image == null) return;
      setState(() {
        this.image = File(image.path);
        imageName = image.name;
      });
      //compressImage();
    } on PlatformException {
      is_web
          ? ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to pick profile image')))
          : BusyBeeCore().showToast('Failed to pick profile image');
    }
  }

  // Future<void> compressImages() async {
  //   final compressedFile = await FlutterImageCompress.compressAndGetFile(
  //     image!.path,
  //     image!.path,
  //   );
  //   setState(() {
  //     image = File(compressedFile!.path);
  //   });
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: BusyBeeCore().getRandomColor(.2),
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        child: image != null
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  backgroundImage: FileImage(image!),
                                  radius: 50,
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () async {
                                    if (await BusyBeeCore()
                                        .storagePermission()
                                        .isGranted) {
                                      pickImage(ImageSource.gallery);
                                    }
                                    // else if (await storagePermission()
                                    //     .isDenied) {
                                    //   BusyBeeCore().showToast(
                                    //       'Storage Permission Denied');
                                    // } else if (await storagePermission()
                                    //     .isPermanentlyDenied) {
                                    //   BusyBeeCore().showToast(
                                    //       'Storage Permission  Permanently Denied');
                                    // }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(35),
                                        child: Icon(
                                          Icons.person,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (await BusyBeeCore()
                              .storagePermission()
                              .isGranted) {
                            pickImage(ImageSource.gallery);
                          }
                          //else if (await storagePermission()
                          //     .isDenied) {
                          //   BusyBeeCore().showToast('Storage Permission Denied');
                          // } else if (await storagePermission()
                          //     .isPermanentlyDenied) {
                          //   BusyBeeCore().showToast(
                          //       'Storage Permission  Permanently Denied');
                          // }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(50)),
                          child: const Icon(
                            Icons.add,
                          ),
                        ),
                      )
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  child: TextField(
                    controller: username,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      label: const Text('Username'),
                      border: const OutlineInputBorder(),
                      floatingLabelStyle: const TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: usernameCheck ? Colors.grey : Colors.red),
                      ),
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(10),
              //   child: Container(
              //     child: TextField(
              //       controller: brandName,
              //       cursorColor: Colors.black,
              //       decoration: const InputDecoration(
              //         label: Text('Brand Name'),
              //         border: OutlineInputBorder(),
              //         floatingLabelStyle: TextStyle(color: Colors.grey),
              //         focusedBorder: OutlineInputBorder(
              //           borderSide: BorderSide(color: Colors.grey),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  child: TextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 15),
                    cursorColor: Colors.black,
                    cursorWidth: 1,
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
                        if (isEmail(email.text) &&
                            isCorrectFormat(email.text)) {
                          isValidEmail = true;
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
                padding: const EdgeInsets.only(
                    top: 10, left: 10, right: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.29,
                      child: TextField(
                        controller: confirmPassword,
                        obscureText: !confirmPasswordVisibility,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              left: 10, right: 68, bottom: 20, top: 20),
                          label: const Text('Confirm Password'),
                          border: const OutlineInputBorder(),
                          floatingLabelStyle:
                              const TextStyle(color: Colors.black),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: confirmPasswordCheck
                                      ? Colors.grey
                                      : Colors.red)),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          confirmPasswordVisibility =
                              !confirmPasswordVisibility;
                        });
                      },
                      child: Container(
                        color: BusyBeeCore().getRandomColor(.3),
                        width: MediaQuery.of(context).size.width / 7,
                        height: MediaQuery.of(context).size.height / 15,
                        child: confirmPasswordVisibility
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0, left: 10, right: 10, bottom: 10),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox.adaptive(
                              value: termsAndConditions,
                              checkColor: Colors.white,
                              onChanged: (termsAndConditions) {
                                setState(() {
                                  this.termsAndConditions = termsAndConditions!;
                                });
                              }),
                          GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const TermsAndConditions())),
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: BusyBeeCore().getRandomColor(.2),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text(
                                      'Terms and Conditions',
                                    ),
                                  ))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(top: 10, left: 100, right: 100),
                  child: creating
                      ? Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(20)),
                                child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'Creating Account ',
                                    style: TextStyle(color: Colors.white),
                                  ),
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
                          onTap: () {
                            if (termsAndConditions) {
                              if (password.text == confirmPassword.text) {
                                BusyBeeCore().showToast('Passwords do match');
                                if (image != null) {
                                  signUp(image!);
                                } else {
                                  signUpWithoutImage();
                                }
                              } else {
                                BusyBeeCore()
                                    .showToast('Passwords do not match');
                              }
                            } else {
                              BusyBeeCore().showToast(
                                  'Accept Terms & Conditions and Privacy Policy to proceed');
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Center(
                                child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'Create Account',
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
                      const Text('Already have an account?'),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const SignIn()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.black54,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Sign in',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
