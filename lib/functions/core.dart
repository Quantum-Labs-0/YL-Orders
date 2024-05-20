// // ignore_for_file: deprecated_member_use

// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ylorders/models/item_features.dart';
import 'package:ylorders/models/pending_orders_customer.dart';
import 'package:ylorders/payment_channels/busybee/google_pay.dart';
import 'package:ylorders/payment_channels/models/paywall.dart';
import 'package:ylorders/store/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mpesa/mpesa.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'package:date_time_format/date_time_format.dart';
import 'package:ylorders/models/item_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:mpesa/mpesa.dart';
// //import 'package:internet_connection_checker/internet_connection_checker.dart';

class BusyBeeCore {
  createAccountProfile(TextEditingController email,
      TextEditingController username, String uid, bool termsAndConditions0) {
    final documentID = const Uuid().v4();

    FirebaseFirestore.instance
        .collection('Account Profiles')
        .doc(documentID)
        .set({
      'Username': username.text.toString(),
      'UID': uid,
      'Terms And Contitions Agreement': termsAndConditions0,
      'Phone Number': '',
      'Subscription Start': '',
      'Subscription End': '',
      'Subscription End Timestamp': '0',
      'Email': email.text.toString(),
      'Account ID': documentID.toString(),
      'Type': 'Retailer',
      'Active': false
    });
  }

  String formatNumber(dynamic number, int decimals) {
    if (number is int) {
      if (number >= 1000000) {
        return '${(number / 1000000).toStringAsFixed(decimals)}M';
      } else if (number >= 1000) {
        return '${(number / 1000).toStringAsFixed(decimals)}K';
      } else {
        return '$number';
      }
    } else if (number is double) {
      if (number >= 1000000) {
        return '${number.toStringAsFixed(decimals)}M';
      } else if (number >= 1000) {
        return '${number.toStringAsFixed(decimals)}K';
      } else {
        return '$number';
      }
    } else {
      throw ArgumentError('Input must be either int or double');
    }
  }

//   double calculateNetProfit(double totalRevenue, double totalExpenses) {
//     return totalRevenue - totalExpenses;
//   }

//   double calculateDSCR(double netOperatingIncome, double totalDebtService) {
//     if (totalDebtService <= 0) {
//       throw ArgumentError("Total Debt Service must be greater than 0");
//     }

//     return netOperatingIncome / totalDebtService;
//   }

//   double calculateROI(double netProfit, double totalInvestmentCost) {
//     if (totalInvestmentCost <= 0) {
//       throw ArgumentError("Total Investment Cost must be greater than 0");
//     }

//     return (netProfit / totalInvestmentCost) * 100;
//   }

//   double calculateCapRate(double netOperatingIncome, double propertyValue) {
//     if (propertyValue <= 0) {
//       throw ArgumentError("Property value must be greater than 0");
//     }

//     return (netOperatingIncome / propertyValue) * 100;
//   }

//   double calculateGRM(double propertyValue, double grossRentalIncome) {
//     if (grossRentalIncome <= 0) {
//       throw ArgumentError("Gross Rental Income must be greater than 0");
//     }

//     return propertyValue / grossRentalIncome;
//   }

  Color getRandomColor(double opacity) {
    // You can replace this with your own logic for generating colors
    return Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
        .withOpacity(opacity);
  }

  widths_transition(
      int seconds,
      double width_1,
      double width_1_min,
      double width_2,
      double width_2_max,
      double speed,
      Function updateState) async {
    Timer.periodic(Duration(seconds: seconds), (timer) async {
      if (width_1 > width_1_min) {
        width_1 = width_1 - speed;
      }
      if (width_2 < width_2_max) {
        width_2 = width_2 + speed;
      }
    });
  }

  Future searchView(
      BuildContext context,
      TextEditingController searchController,
      List itemFeatures,
      Function updateState) {
    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => DraggableScrollableSheet(
              initialChildSize: 1,
              maxChildSize: 1,
              minChildSize: 0.8,
              builder: (context, scrollController) => ItemSearch(
                searchController: searchController,
                itemFeatures: itemFeatures,
                updateState: updateState,
              ),
            ));
  }

  Future pendingOrdersView(
    BuildContext context,
    String orderID,
  ) {
    return showModalBottomSheet(
        context: context,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => DraggableScrollableSheet(
              initialChildSize: 1,
              maxChildSize: 1,
              minChildSize: 0.8,
              builder: (context, scrollController) =>
                  PendingOrdersCustomer(orderID: orderID),
            ));
  }

  List<double> extractMonthlyCosts(Map<String, double> monthlyCosts) {
    // Create a list of month names in order
    List<String> monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    // Create a list to store the costs in the order of months
    List<double> costsByMonth = [];

    // Iterate over the month names and add the corresponding cost from the map
    for (String month in monthNames) {
      // Create the key using the month and year format 'MMMM yyyy'
      String key = '$month ${DateTime.now().year}';

      // Check if the key exists in the map
      if (monthlyCosts.containsKey(key)) {
        // Add the cost to the list
        costsByMonth.add(monthlyCosts[key]!);
      } else {
        // If the key is not present, add a default value (e.g., 0.0)
        costsByMonth.add(0.0);
      }
    }

    return costsByMonth;
  }

  Future showToast(String messege) async {
    await Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: messege,
      fontSize: 16,
      gravity: ToastGravity.TOP,
    );
  }

  Future<PermissionStatus> storagePermission() async {
    PermissionStatus storagePermission = await Permission.storage.request();
    return storagePermission;
  }

  Future<PermissionStatus> locationPermission() async {
    PermissionStatus locationPermission = await Permission.location.request();
    return locationPermission;
  }

  Future<PermissionStatus> notificationPermission() async {
    PermissionStatus notificationPermission =
        await Permission.notification.request();
    return notificationPermission;
  }

  Future<PermissionStatus> notificationPolicyPermission() async {
    PermissionStatus notificationPolicyPermission =
        await Permission.accessNotificationPolicy.request();
    return notificationPolicyPermission;
  }

  Future<PermissionStatus> cameraPermission() async {
    PermissionStatus cameraPermission = await Permission.camera.request();
    return cameraPermission;
  }

  Future<PermissionStatus> microphonePermission() async {
    PermissionStatus microphonePermission =
        await Permission.microphone.request();
    return microphonePermission;
  }

//   void sendSMS(String phoneNumber) async {
//     //String url = 'sms:$phoneNumber?body=$message';
//     String url = 'sms:$phoneNumber';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       print('Could not launch $url');
//       // Handle the error, e.g., show a message to the user
//     }
//   }

//   // void sendEmail(
//   //     {required String to,
//   //     required String subject,
//   //     required String body}) async {
//   //   String url =
//   //       'mailto:$to?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';
//   //   if (await canLaunch(url)) {
//   //     await launch(url);
//   //   } else {
//   //     print('Could not launch $url');
//   //     // Handle the error, e.g., show a message to the user
//   //   }
//   // }
//   void sendEmail({required String to}) async {
//     String url = 'mailto:$to';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       print('Could not launch $url');
//       // Handle the error, e.g., show a message to the user
//     }
//   }

//   void launchPhoneCall(String phoneNumber) async {
//     String url = 'tel:$phoneNumber';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       print('Could not launch $url');
//       // Handle the error, e.g., show a message to the user
//     }
//   }

//   Future showNetworkToast(String messege, Color color) async {
//     await Fluttertoast.cancel();
//     Fluttertoast.showToast(
//         msg: messege,
//         fontSize: 16,
//         gravity: ToastGravity.TOP,
//         backgroundColor: color);
//   }

  initializeMpesaPaybilTansaction(
      String customerName,
      String phoneNumber,
      double amount,
      String paybillNumber,
      String clientKey,
      String clientSecret,
      String passKey) async {
    Mpesa mpesa = Mpesa(
      clientKey: clientKey,
      clientSecret: clientSecret,
      passKey: passKey,
      environment: "production",
    );
    String orderID = const Uuid().v1();
    try {
      mpesa
          .lipaNaMpesa(
        phoneNumber: "254${BusyBeeCore().removeLeadingZero(phoneNumber)}",
        amount: amount,
        businessShortCode: paybillNumber,
        callbackUrl:
            "https://us-central1-mpesamalipo.cloudfunctions.net/mpesaCallback",
      )
          .then((value) {
        String responseCode0 = value.ResponseCode;
        final myUId = FirebaseAuth.instance.currentUser!.uid;
        if (BusyBeeCore().stringToInt(responseCode0) == 0) {
          showToast('Payment Successful');

          BusyBeeCore().createOrder(orderID, amount, myUId);
          BusyBeeCore().generateReceipt(
              myUId,
              customerName,
              orderID,
              amount.toString(),
              DateTimeFormat.format(DateTime.now(), format: 'j M Y').toString(),
              'M-Pesa Paybill');
        } else if (BusyBeeCore().stringToInt(responseCode0) == 1) {
          showToast('Insufficient Funds');
        }
        // } else if (BusyBeeCore().stringToInt(responseCode0) == 2) {
        //   showToast('Less Than Minimum Transaction Value');
        // } else if (BusyBeeCore().stringToInt(responseCode0) == 3) {
        //   showToast('More Than Maximum Transaction Value');
        // } else if (BusyBeeCore().stringToInt(responseCode0) == 4) {
        //   showToast('Would Exceed Daily Transfer Limit');
        // } else if (BusyBeeCore().stringToInt(responseCode0) == 5) {
        //   showToast('Would Exceed Minimum Balance');
        // } else if (BusyBeeCore().stringToInt(responseCode0) == 6) {
        //   showToast('Would Exceed Maxiumum Balance');
        // } else if (BusyBeeCore().stringToInt(responseCode0) == 20) {
        //   showToast('Unresolved Initiator');
        // }
      });
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  createOrder(String orderID, double amount, String myUId) async {
    FirebaseFirestore.instance.collection('Orders').doc(orderID).set({
      'Order ID': orderID,
      'Items Ordered': [],
      'Order Value': amount.toString(),
      'Customer UID': myUId,
      'Date': DateTimeFormat.format(DateTime.now(), format: 'j M Y').toString(),
      'Timestamp':
          DateTimeFormat.format(DateTime.now(), format: 'YMj').toString(),
    }).then((value) async {
      DocumentReference cartRef =
          FirebaseFirestore.instance.collection('Cart').doc(myUId);
      DocumentSnapshot cart =
          await FirebaseFirestore.instance.collection('Cart').doc(myUId).get();
      List cartItems = cart.get('Cart');
      DocumentReference order =
          FirebaseFirestore.instance.collection('Order').doc(orderID);
      List itemsOrdered = [];
      for (var element in cartItems) {
        String itemID = element['Item ID'];
        DocumentSnapshot item = await FirebaseFirestore.instance
            .collection('Store Items')
            .doc(itemID)
            .get();
        String itemName = item['Item Name'];
        String storeID = item['Store ID'];
        String itemValue = item['Current Price'];
        String numberOrdered = element['Orders'];
        String totalValueOfSubOrder =
            (BusyBeeCore().stringToInt(numberOrdered) *
                    BusyBeeCore().stringToInt(itemValue))
                .toString();
        itemsOrdered.add([
          {
            'Item Name': itemName,
            'Item ID': itemID,
            'Item Value': itemValue,
            'Store ID': storeID,
            'Orders': numberOrdered,
            'Order Value': totalValueOfSubOrder,
            'Order Complete': false,
            'Date': DateTimeFormat.format(DateTime.now(), format: 'j M Y')
                .toString(),
            'Time': DateTimeFormat.format(DateTime.now(), format: 'H : i a')
                .toString(),
          }
        ]);
      }
      order.update({'Items Ordered': itemsOrdered}).then(
          (value) => cartItems.clear());
      cartRef.update({'Cart': cartItems});
    });
  }

  createItem(
      TextEditingController itemNameController,
      List<File> itemImages,
      File itemThumbnail,
      List<String> features,
      TextEditingController itemDescriptionController,
      int inStock,
      TextEditingController itemCategoryController,
      double itemPrice) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final itemID = Uuid().v1();
    FirebaseFirestore.instance.collection('Store Items').doc(itemID).set({
      'Item Name': itemNameController.text.toString(),
      'Item Images': [],
      'Item Thumbnail': '',
      'Item Category': itemCategoryController.text,
      'Store ID': uid,
      'Item ID': itemID.toString(),
      'Ratings': [],
      'Current Price': itemPrice,
      'Old Price': '0',
      'Description': itemDescriptionController.text.toString(),
      'Features': features,
      'In-Stock': inStock,
      'Delivered': [],
    }).then((value) async {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      for (var element in itemImages) {
        XFile image = XFile(element.path);
        final path = 'Stores/$uid/${itemID.toString()}/Images/${image.name}';
        File file = File(element.path);
        final ref = FirebaseStorage.instance.ref().child(path);
        final uploadTask = ref.putFile(file);

        final snapshot = await uploadTask.whenComplete(() {
          // print('Upload Complete');
        });
        final url = await snapshot.ref.getDownloadURL();
        DocumentReference itemRef =
            FirebaseFirestore.instance.collection('Store Items').doc(itemID);
        itemRef.update({
          'Item Images': FieldValue.arrayUnion([url.toString()])
        });
      }
    }).then((value) async {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      XFile thumbImage = XFile(itemThumbnail.path);
      final path =
          'Stores/$uid/${itemID.toString()}/Thumbnail/${thumbImage.name}';
      File file = File(itemThumbnail.path);
      final ref = FirebaseStorage.instance.ref().child(path);
      final uploadTask = ref.putFile(file);

      final snapshot = await uploadTask.whenComplete(() {
        // print('Upload Complete');
      });
      final url = await snapshot.ref.getDownloadURL();
      DocumentReference itemRef =
          FirebaseFirestore.instance.collection('Store Items').doc(itemID);
      itemRef.update({'Item Thumbnail': url.toString()});
    });
  }

  String removeLeadingZero(String inputString) {
    // Check if the string is not empty and the first character is '0'
    if (inputString.isNotEmpty && inputString[0] == '0') {
      // Remove the first character and return the updated string
      return inputString.substring(1);
    }

    // Return the original string if it doesn't start with '0' or is empty
    return inputString;
  }

  // String getDayMonth(String sentence) {
  //   List<String> words = sentence.split(' ');

  //   if (words.length >= 2) {
  //     return "${words[0]} ${words[1]}";
  //   } else {
  //     return sentence;
  //   }
  // }

//   Future updateBoolAppSetting(
//       String uid, String settingName, bool updateValue) async {
//     FirebaseFirestore.instance.collection('Profiles').doc(uid).update({
//       'App Settings.$settingName': updateValue,
//     });
//   }

//   Future updateStringAppSetting(
//       String uid, String settingName, String updateValue) async {
//     FirebaseFirestore.instance.collection('Profiles').doc(uid).update({
//       'App Settings.$settingName': updateValue,
//     });
//   }

//   String addDaysToCurrentDate(int days) {
//     DateTime currentDate = DateTime.now();

//     DateTime futureDate = currentDate.add(Duration(days: days));

//     String formattedDate =
//         DateTimeFormat.format(futureDate, format: 'j M Y').toString();

//     return formattedDate;
//   }

  int stringToInt(String input) {
    return int.parse(input);
  }

  double stringToDouble(String input) {
    return double.parse(input);
  }

  // String generateRefferalCode(int length) {
  //   const String chars =
  //       'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  //   Random random = Random();

  //   if (length <= 0) {
  //     throw ArgumentError('Length must be greater than 0');
  //   }

  //   return String.fromCharCodes(Iterable.generate(
  //     length,
  //     (_) => chars.codeUnitAt(random.nextInt(chars.length)),
  //   ));
  // }

  double findLargestNumber(List numbers) {
    // Check if the list is not empty
    if (numbers.isNotEmpty) {
      // Sort the list in descending order
      numbers.sort((a, b) => b.compareTo(a));

      // Return the first element, which is the largest number
      return numbers[0];
    } else {
      // Return a default value or handle the case where the list is empty
      return 0.0; // You can customize this part based on your requirements
    }
  }

  // Future<bool> checkInternetConnection() async {
  //   bool isConnected = await InternetConnectionChecker().hasConnection;
  //   return isConnected;
  // }

//   Future<String> getAreaName(LatLng latLng) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         latLng.latitude,
//         latLng.longitude,
//       );

//       if (placemarks.isNotEmpty) {
//         Placemark placemark = placemarks.first;
//         if (placemark.administrativeArea!.toString().isNotEmpty &&
//             placemark.locality!.toString().isNotEmpty) {
//           return '${placemark.administrativeArea}, ${placemark.locality}';
//         } else if (placemark.administrativeArea!.toString().isEmpty &&
//             placemark.locality!.toString().isNotEmpty) {
//           return '${placemark.locality}';
//         } else if (placemark.administrativeArea!.toString().isNotEmpty &&
//             placemark.locality!.toString().isEmpty) {
//           return '${placemark.administrativeArea}';
//         }
//         return 'Location Marker Created';
//       } else {
//         return 'Area not found';
//       }
//     } catch (e) {
//       print('Error fetching area name: $e');
//       return 'Error';
//     }
//   }

  // Future fetchOffers(BuildContext context) async {
  //   final offerings = await PurchaseApi.fetchOffers();
  //   if (offerings.isEmpty) {
  //     ScaffoldMessenger.of(context)
  //         .showSnackBar(const SnackBar(content: Text('No plans found')));
  //   } else {
  //     final packages = offerings
  //         .map((offer) => offer.availablePackages)
  //         .expand((pair) => pair)
  //         .toList();
  //     showModalBottomSheet(
  //         context: context,
  //         builder: (context) => PaywallWidget(
  //             title: 'Upgrade your subscription',
  //             description: 'Unlock various automated management features',
  //             packages: packages,
  //             onClickedPackage: (package) async {
  //               await PurchaseApi.purchasePackage(package);
  //               Navigator.of(context).pop();
  //             }));
  //     Navigator.of(context).pushAndRemoveUntil(
  //         MaterialPageRoute(builder: (context) => const Home()),
  //         (route) => false);
  //   }
  // }

//   sendInvoice(
//       String lateCharge,
//       String date,
//       String unitID78,
//       String propertyFormID,
//       String propertyOwnerUID,
//       String tenantUID,
//       String tenantName,
//       String unitLebal,
//       String propertName,
//       String amount,
//       String propertyEmail,
//       String propertyPhoneNumber,
//       String propertyLocation) async {
//     DocumentReference unitInfo =
//         FirebaseFirestore.instance.collection('Property Units').doc(unitID78);
//     unitInfo.update({
//       'Unit Documents': FieldValue.arrayUnion([
//         {
//           'Type': 'Payment Invoice',
//           'Date':
//               DateTimeFormat.format(DateTime.now(), format: 'j M Y').toString(),
//           'Rent Amount': amount,
//           'Tenant Name': tenantName,
//           'Tenant UID': tenantUID,
//           'Unit Lebal': unitLebal,
//           'Property Form ID': propertyFormID,
//           'Unit ID': unitID78,
//           'Property Email': propertyEmail,
//           'Property Phone Number': propertyPhoneNumber,
//           'Property Name': propertName,
//           'Invoice Number': BusyBeeCore().generateInvoiceCode(6),
//           'Late Charge': lateCharge,
//           'Due Date': date,
//           'Property Location': propertyLocation
//         }
//       ])
//     });
//   }

  // Future<String> generateInvoiceCode(int length) async {
  //   const String chars =
  //       'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  //   Random random = Random();

  //   if (length <= 0) {
  //     throw ArgumentError('Length must be greater than 0');
  //   }

  //   // Check if the document exists
  //   bool documentExists = await checkDocumentExists();

  //   if (!documentExists) {
  //     // Create the document if it doesn't exist
  //     await createDocument();
  //   }

  //   String generatedCode = String.fromCharCodes(Iterable.generate(
  //     length,
  //     (_) => chars.codeUnitAt(random.nextInt(chars.length)),
  //   ));

  //   // Check for duplicate in the specific document
  //   bool isDuplicate = await checkForDuplicate(generatedCode);

  //   // If duplicate, generate a new code
  //   while (isDuplicate) {
  //     generatedCode = String.fromCharCodes(Iterable.generate(
  //       length,
  //       (_) => chars.codeUnitAt(random.nextInt(chars.length)),
  //     ));

  //     isDuplicate = await checkForDuplicate(generatedCode);
  //   }

  //   return generatedCode;
  // }

  addMpesaPayment(
      String storeID,
      TextEditingController passKey0,
      TextEditingController consumerKey0,
      TextEditingController paybillNumber,
      TextEditingController consumerSecret0,
      BuildContext context) {
    bool dataComplete = false;
    bool creating = false;
    final uid = FirebaseAuth.instance.currentUser!.uid;

    if (consumerKey0.text.isEmpty ||
        paybillNumber.text.isEmpty ||
        consumerSecret0.text.isEmpty ||
        passKey0.text.isEmpty) {
      BusyBeeCore().showToast('Fill all fields to proceed');
    } else if (consumerKey0.text.isNotEmpty &&
        paybillNumber.text.isNotEmpty &&
        consumerSecret0.text.isNotEmpty &&
        passKey0.text.isNotEmpty) {
      dataComplete = true;
    }
    if (dataComplete) {
      creating = true;
      final docID = const Uuid().v1();
      FirebaseFirestore.instance.collection('Payment Methods').doc(docID).set({
        'UID': uid,
        'Payment ID': docID.toString(),
        'Payment Method': 'M-Pesa Paybill Online',
        'Consumer Key': consumerKey0.text.toString(),
        'Consumer Secret': consumerSecret0.text.toString(),
        'Callback URL':
            'https://us-central1-mpesamalipo.cloudfunctions.net/mpesaCallback',
        'Pass Key': passKey0.text.toString(),
        'Paybill Number': paybillNumber.text.toString(),
      }).then((value) {
        FirebaseFirestore.instance
            .collection('Stores')
            .doc(storeID)
            .update({'Mpesa Document ID': docID.toString()});
      }).then((value) {
        creating = false;
        BusyBeeCore().showToast('Portal Successfully Created');
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
      });
    }
  }

  updateMpesaPayment(
      String docID,
      String storeID,
      TextEditingController passKey0,
      TextEditingController consumerKey0,
      TextEditingController paybillNumber,
      TextEditingController consumerSecret0,
      BuildContext context) {
    bool dataComplete = false;
    bool creating = false;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    if (consumerKey0.text.isEmpty ||
        paybillNumber.text.isEmpty ||
        consumerSecret0.text.isEmpty ||
        passKey0.text.isEmpty) {
      BusyBeeCore().showToast('Fill all fields to proceed');
    } else if (consumerKey0.text.isNotEmpty &&
        paybillNumber.text.isNotEmpty &&
        consumerSecret0.text.isNotEmpty &&
        passKey0.text.isNotEmpty) {
      dataComplete = true;
    }
    if (dataComplete) {
      creating = true;
      FirebaseFirestore.instance.collection('Payment Methods').doc(docID).set({
        'UID': uid,
        'Payment ID': docID.toString(),
        'Payment Method': 'M-Pesa Paybill Online',
        'Consumer Key': consumerKey0.text.toString(),
        'Consumer Secret': consumerSecret0.text.toString(),
        'Callback URL':
            'https://us-central1-mpesamalipo.cloudfunctions.net/mpesaCallback',
        'Pass Key': passKey0.text.toString(),
        'Paybill Number': paybillNumber.text.toString(),
      }).then((value) {
        FirebaseFirestore.instance
            .collection('Stores')
            .doc(storeID)
            .update({'Mpesa Document ID': docID.toString()});
      }).then((value) {
        creating = false;
        BusyBeeCore().showToast('Portal Successfully Updated');
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
      });
    }
  }

  Future<void> generateReceipt(
      String storeOwnerUID,
      String customerName,
      String itemName,
      String totalAmount,
      String paymentDate,
      String paymentMethod) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference myReciepts =
        FirebaseFirestore.instance.collection('Reciepts').doc(uid);
    myReciepts.update({
      'Reciepts': FieldValue.arrayUnion([
        {
          'Store Owner': storeOwnerUID,
          'Customer UID': uid,
          'Item Name': itemName,
          'Customer Name': customerName,
          'Total Amount': totalAmount,
          'Payment Date': paymentDate,
          'Payment Method': paymentMethod,
          'Type': 'Order Payment Reciept'
        }
      ])
    });
  }

//   getSettingValue(String uid, String settingName) async {
//     DocumentSnapshot snapshot =
//         await FirebaseFirestore.instance.collection('Profiles').doc(uid).get();

//     bool updatedType = snapshot['App Settings'][settingName];

//     // setState(() {
//     //   forsale = updatedType;
//     // });
//     //usage
//     getSettingValue(uid, 'Residential Rental Home Display');
//   }
  rateItem(int rate, String itemID) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('Store Items').doc(itemID).update({
      'Ratings': [
        {uid.toString(): rate.toString()}
      ]
    });
  }

  int rating(List ratings) {
    int customerRating = 0;
    final uid = FirebaseAuth.instance.currentUser!.uid;
    for (var cRating in ratings) {
      String rate = cRating[uid.toString()];
      customerRating += BusyBeeCore().stringToInt(rate);
    }
    int maxRate = ratings.length * 5;
    int rating = BusyBeeCore()
        .stringToInt(((customerRating * 5) / maxRate).toStringAsFixed(0));
    return rating;
  }

  Future checkShoppingStuffExistance() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot snapshotCart =
        await FirebaseFirestore.instance.collection('Carts').doc(uid).get();
    DocumentSnapshot snapshotStore =
        await FirebaseFirestore.instance.collection('Stores').doc(uid).get();
    DocumentSnapshot snapshotReciepts =
        await FirebaseFirestore.instance.collection('Reciepts').doc(uid).get();
    if (!snapshotReciepts.exists) {
      FirebaseFirestore.instance
          .collection('Reciepts')
          .doc(uid)
          .set({'Reciepts': []});
    }
    if (!snapshotStore.exists) {
      final storeID = const Uuid().v1();
      FirebaseFirestore.instance
          .collection('Stores')
          .doc(uid)
          .set({'Store ID': storeID.toString(), 'Store Name': ''});
    }

    if (!snapshotCart.exists) {
      FirebaseFirestore.instance.collection('Carts').doc(uid).set({'Cart': []});
    }
  }

  updateMeNU() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference appInformation =
        FirebaseFirestore.instance.collection('Profiles').doc(uid);
    appInformation.update({'Opened Menu': true});
  }

  Future checkExistance() async {
    DocumentSnapshot snapshotNames =
        await FirebaseFirestore.instance.collection('Names').doc('Names').get();
    DocumentSnapshot appInformation = await FirebaseFirestore.instance
        .collection('App information')
        .doc('App information')
        .get();
    DocumentSnapshot snapshotEmails = await FirebaseFirestore.instance
        .collection('Emails')
        .doc('Emails')
        .get();

    if (!appInformation.exists) {
      FirebaseFirestore.instance
          .collection('App information')
          .doc('App information')
          .set({'Latest Version': '0'});
    }

    if (!snapshotNames.exists) {
      FirebaseFirestore.instance
          .collection('Names')
          .doc('Names')
          .set({'Names': []});
    }
    if (!snapshotEmails.exists) {
      FirebaseFirestore.instance
          .collection('Emails')
          .doc('Emails')
          .set({'Emails': []});
    }
  }

  setupStore(TextEditingController storeNameController, String storeID) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('Stores').doc(uid).set({
      'Store ID': storeID,
      'Store Name': storeNameController.text.toString(),
      'Orders': [],
      'Mpesa Document ID': ''
    });
  }

  updateCart(String itemID, bool isAdding, String inStock) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference myCartRef =
        FirebaseFirestore.instance.collection('Carts').doc(uid);
    DocumentSnapshot myCartSnap =
        await FirebaseFirestore.instance.collection('Carts').doc(uid).get();
    List cartItems = myCartSnap.get('Cart');

    bool inCart = false;
    String orders = '';
    for (var element in cartItems) {
      if (element['Item ID'] == itemID) {
        inCart = true;
        orders = element['Orders'];
      }
    }
    if (inCart) {
      if (isAdding) {
        if (BusyBeeCore().stringToInt(orders) <
            BusyBeeCore().stringToInt(inStock)) {
          String newOrders = (BusyBeeCore().stringToInt(orders) + 1).toString();
          await myCartRef.update({
            'Cart': FieldValue.arrayRemove([
              {'Item ID': itemID, 'Orders': orders}
            ])
          });

          myCartRef.update({
            'Cart': FieldValue.arrayUnion([
              {'Item ID': itemID, 'Orders': newOrders}
            ])
          });
        }
      } else {
        if (BusyBeeCore().stringToInt(orders) > 0) {
          String newOrders =
              ((BusyBeeCore().stringToInt(orders) - 1)).toString();
          if (BusyBeeCore().stringToInt(newOrders) == 0) {
            myCartRef.update({
              'Cart': FieldValue.arrayRemove([
                {'Item ID': itemID, 'Orders': orders}
              ])
            });
          } else if (BusyBeeCore().stringToInt(newOrders) > 0) {
            await myCartRef.update({
              'Cart': FieldValue.arrayRemove([
                {'Item ID': itemID, 'Orders': orders}
              ])
            });
            myCartRef.update({
              'Cart': FieldValue.arrayUnion([
                {'Item ID': itemID, 'Orders': newOrders}
              ])
            });
          }
        }
      }
    } else {
      myCartRef.update({
        'Cart': FieldValue.arrayUnion([
          {'Item ID': itemID, 'Orders': '1'}
        ])
      });
    }
  }

  updateDelivered(String itemID, String orderID) {
    DocumentReference item =
        FirebaseFirestore.instance.collection('Store Item').doc(itemID);
    item.update({
      'Delivered': FieldValue.arrayUnion([orderID])
    });
  }

  Future<double> totalPrice(List cart) async {
    double total = 0.0;
    for (var element in cart) {
      DocumentSnapshot item = await FirebaseFirestore.instance
          .collection('Store Item')
          .doc(element['Item ID'])
          .get();
      String currentPrice = item['Current Price'];
      total += BusyBeeCore().stringToDouble(currentPrice);
    }
    return total;
  }

  makeOrder(String storeID, String itemID, String currentPrice) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('Stores').doc(storeID).update({
      'Orders': FieldValue.arrayUnion([
        {
          'UID': uid,
          'Item ID': itemID,
          'Current Price': currentPrice,
          'Order Complete': false
        }
      ])
    });
  }

  Future getRevenueForGraph(
      Map<String, double> monthlyRevenue, String orderID) async {
    DocumentSnapshot ordersSnapshot = await FirebaseFirestore.instance
        .collection('Orders')
        .doc(orderID)
        .get();
    String orderValue = ordersSnapshot.get('Order Value');
    String year = BusyBeeCore().getYear(ordersSnapshot['Date']);
    String yearNow = BusyBeeCore().getYear(
        DateTimeFormat.format(DateTime.now(), format: 'j M Y ').toString());
    if (year == yearNow) {
      String month = BusyBeeCore().getMonth(ordersSnapshot['Date']);
      double earning = ordersSnapshot['Order Value'];
      monthlyRevenue.update(month, (value) => value + earning,
          ifAbsent: () => earning);
    }
  }

  String getMonth(String sentence) {
    // Split the sentence into words
    List<String> words = sentence.split(' ');
    return words[1];
  }

  String getYear(String sentence) {
    // Split the sentence into words
    List<String> words = sentence.split(' ');
    return words[2];
  }
}
