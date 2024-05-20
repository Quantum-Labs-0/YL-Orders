import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:ylorders/payment_channels/busybee/model/entitlement.dart';

class RevenueCatProvider {
  Entitlement _entitlement = Entitlement.free;
  Entitlement get entitlement => _entitlement;

  Future init() async {
    Purchases.addCustomerInfoUpdateListener((customerInfo) {
      updateCustomerInfo();
    });
  }

  Future updateCustomerInfo() async {
    final customerInfo = await Purchases.getCustomerInfo();
    final entitlements = customerInfo.entitlements.active.values.toList();
    _entitlement =
        entitlements.isEmpty ? Entitlement.free : Entitlement.Retailer;
  }
}
