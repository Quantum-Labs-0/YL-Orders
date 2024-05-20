// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseApi {
  static const apiKey = 'CREATE NEW REVENUECAT PROJECT';

  static Future init() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(apiKey);
  }

  static Future<List<Offering>> fetchOffers() async {
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;

      return current == null ? [] : [current];
    } on PlatformException {
      return [];
    }
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      await Purchases.purchasePackage(package);
      return true;
    } catch (e) {
      return false;
    }
  }
}
