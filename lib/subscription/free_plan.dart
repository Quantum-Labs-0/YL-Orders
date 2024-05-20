import 'package:ylorders/payment_channels/busybee/google_pay.dart';
import 'package:ylorders/payment_channels/models/paywall.dart';
import 'package:ylorders/store/home.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class FreePlan extends StatefulWidget {
  const FreePlan({super.key});

  @override
  State<FreePlan> createState() => _FreePlanState();
}

class _FreePlanState extends State<FreePlan> {
  List<Package> packagesAvailable = [];

  getPackages() async {
    final offerings = await PurchaseApi.fetchOffers();
    final packages = offerings
        .map((offer) => offer.availablePackages)
        .expand((pair) => pair)
        .toList();
    setState(() {
      packagesAvailable = packages;
    });
  }

  @override
  void initState() {
    super.initState();
    getPackages();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
          child: Center(
        child: PaywallWidget(
            title: 'Upgrade your subscription',
            description: 'Unlock all management features and options',
            packages: packagesAvailable,
            onClickedPackage: (package) async {
              await PurchaseApi.purchasePackage(package);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Home()),
                  (route) => false);
            }),
      )),
    ));
  }
}
