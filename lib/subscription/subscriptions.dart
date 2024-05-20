// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:ylorders/payment_channels/busybee/model/entitlement.dart';
import 'package:ylorders/store/menu/store_management.dart';
import 'package:ylorders/subscription/free_plan.dart';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class MySubscriptions extends StatefulWidget {
  const MySubscriptions({super.key});

  @override
  State<MySubscriptions> createState() => _MySubscriptionsState();
}

class _MySubscriptionsState extends State<MySubscriptions> {
  Entitlement entitlement = Entitlement.free;

  Future init() async {
    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      updateCustomerInfo();
    });
  }

  Future updateCustomerInfo() async {
    final customerInfo = await Purchases.getCustomerInfo();
    final entitlements = customerInfo.entitlements.active.values.toList();
    Entitlement _entitlement =
        entitlements.isEmpty ? Entitlement.free : Entitlement.Retailer;
    setState(() {
      entitlement = _entitlement;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: buildEntitlement(entitlement),
    ));
  }

  Widget buildEntitlement(Entitlement entitlement) {
    switch (entitlement) {
      case Entitlement.Retailer:
        return const StoreManagement();
      case Entitlement.free:
      default:
        return const FreePlan();
    }
  }
}
