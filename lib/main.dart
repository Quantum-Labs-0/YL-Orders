import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ylorders/authentication/authentiction.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ylorders/firebase_options.dart';
import 'package:ylorders/payment_channels/busybee/google_pay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //await PurchaseApi.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YL Orders',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Authentication(),
    );
  }
}
