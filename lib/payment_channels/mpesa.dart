import 'package:ylorders/functions/core.dart';
import 'package:ylorders/payment_channels/steps%20to%20get%20pament%20details/mpesa_details.dart';
import 'package:ylorders/store/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mpesa/mpesa.dart';
import 'package:uuid/uuid.dart';

class MpesaItergration extends StatefulWidget {
  const MpesaItergration({super.key, required this.storeID});
  final String storeID;

  @override
  State<MpesaItergration> createState() => _MpesaItergrationState();
}

class _MpesaItergrationState extends State<MpesaItergration> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController consumerKey0 = TextEditingController();
  TextEditingController consumerSecret0 = TextEditingController();
  TextEditingController passKey0 = TextEditingController();
  TextEditingController paybillNumber = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController callBackURL = TextEditingController();

  bool consumerKeyVisibity = false;
  bool consumerSecretVisibity = false;
  bool passKeyVisibility = false;

  bool isSuccess = false;
  bool creating = false;
  bool dataComplete = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('M-Pesa Rent Collection Portal')],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Payment Methods')
                  .where('UID', isEqualTo: uid)
                  .where('Payment Method', isEqualTo: 'M-Pesa Paybill Online')
                  .snapshots(),
              builder: (context, snapshotPayment) {
                if (snapshotPayment.hasData) {
                  List paymentMethods = snapshotPayment.data!.docs;
                  if (paymentMethods.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            child: Row(children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 1.29,
                                child: TextField(
                                  controller: consumerKey0,
                                  obscureText: !consumerKeyVisibity,
                                  cursorColor: Colors.black,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        left: 10,
                                        right: 68,
                                        bottom: 20,
                                        top: 20),
                                    label: Text('Consumer Key'),
                                    border: OutlineInputBorder(),
                                    floatingLabelStyle:
                                        TextStyle(color: Colors.black),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(9),
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 7,
                                  height:
                                      MediaQuery.of(context).size.height / 15,
                                  child: consumerKeyVisibity
                                      ? GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              consumerKeyVisibity = false;
                                            });
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Icon(Icons.visibility),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              consumerKeyVisibity = true;
                                            });
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(Icons.visibility_off),
                                          ),
                                        ),
                                ),
                              )
                            ]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            child: Row(children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 1.29,
                                child: TextField(
                                  controller: consumerSecret0,
                                  obscureText: !consumerSecretVisibity,
                                  cursorColor: Colors.black,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        left: 10,
                                        right: 68,
                                        bottom: 20,
                                        top: 20),
                                    label: Text('Consumer Secret'),
                                    border: OutlineInputBorder(),
                                    floatingLabelStyle:
                                        TextStyle(color: Colors.black),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(9),
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 7,
                                  height:
                                      MediaQuery.of(context).size.height / 15,
                                  child: consumerSecretVisibity
                                      ? GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              consumerSecretVisibity = false;
                                            });
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Icon(Icons.visibility),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              consumerSecretVisibity = true;
                                            });
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(Icons.visibility_off),
                                          ),
                                        ),
                                ),
                              )
                            ]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            child: Row(children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 1.29,
                                child: TextField(
                                  controller: passKey0,
                                  obscureText: !passKeyVisibility,
                                  cursorColor: Colors.black,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        left: 10,
                                        right: 68,
                                        bottom: 20,
                                        top: 20),
                                    label: Text('Pass Key'),
                                    border: OutlineInputBorder(),
                                    floatingLabelStyle:
                                        TextStyle(color: Colors.black),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(9),
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 7,
                                  height:
                                      MediaQuery.of(context).size.height / 15,
                                  child: passKeyVisibility
                                      ? GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              passKeyVisibility = false;
                                            });
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Icon(Icons.visibility),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              passKeyVisibility = true;
                                            });
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(Icons.visibility_off),
                                          ),
                                        ),
                                ),
                              )
                            ]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            child: TextField(
                              controller: paybillNumber,
                              style: const TextStyle(fontSize: 15),
                              cursorColor: Colors.black,
                              cursorWidth: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                label: Text('Paybill Number'),
                                floatingLabelStyle:
                                    TextStyle(color: Colors.black),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  paybillNumber.value =
                                      paybillNumber.value.copyWith(
                                    text: value,
                                    selection: TextSelection.collapsed(
                                        offset: value.length),
                                  );
                                });
                              },
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(10),
                        //   child: Container(
                        //     child: TextField(
                        //       controller: accountNumber,
                        //       style: const TextStyle(fontSize: 15),
                        //       cursorColor: Colors.white,
                        //       cursorWidth: 1,
                        //       decoration: const InputDecoration(
                        //         border: OutlineInputBorder(),
                        //         focusedBorder: OutlineInputBorder(
                        //             borderSide: BorderSide(color: Colors.grey)),
                        //         label: Text('Account Number'),
                        //         floatingLabelStyle: TextStyle(color: Colors.grey),
                        //       ),
                        //       onChanged: (value) {
                        //         setState(() {
                        //           accountNumber.value =
                        //               accountNumber.value.copyWith(
                        //             text: value,
                        //             selection: TextSelection.collapsed(
                        //                 offset: value.length),
                        //           );
                        //         });
                        //       },
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: creating
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Creating Payment Portal',
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.white),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                30,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                17,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    BusyBeeCore().addMpesaPayment(
                                        widget.storeID,
                                        passKey0,
                                        consumerKey0,
                                        paybillNumber,
                                        consumerSecret0,
                                        context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Create Payment Portal',
                                        style: TextStyle(
                                            fontSize: 17, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30, right: 30),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text('Not sure about details?'),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const GetMpesaDetails()));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.blue,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Steps',
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
                    );
                  } else {
                    final paymentItem = paymentMethods[0];
                    String consumerKeyData = paymentItem['Consumer Key'];
                    String consumerSecretData = paymentItem['Consumer Secret'];
                    String passKeyData = paymentItem['Pass Key'];
                    String paybillNumberData = paymentItem['Paybill Number'];
                    String accountNumberData = paymentItem['Account Number'];
                    String docId = paymentItem['Payment ID'];
                    consumerKey0.text = consumerKeyData;
                    consumerSecret0.text = consumerSecretData;
                    passKey0.text = passKeyData;
                    paybillNumber.text = paybillNumberData;
                    accountNumber.text = accountNumberData;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            child: Stack(children: [
                              TextField(
                                controller: consumerKey0,
                                obscureText: !consumerKeyVisibity,
                                cursorColor: Colors.white,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      left: 10, right: 68, bottom: 20, top: 20),
                                  label: Text('Consumer Key'),
                                  border: OutlineInputBorder(),
                                  floatingLabelStyle:
                                      TextStyle(color: Colors.grey),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(9),
                                  child: Container(
                                    child: consumerKeyVisibity
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                consumerKeyVisibity = false;
                                              });
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Icon(Icons.visibility),
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                consumerKeyVisibity = true;
                                              });
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(Icons.visibility_off),
                                            ),
                                          ),
                                  ),
                                ),
                              )
                            ]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            child: Stack(children: [
                              TextField(
                                controller: consumerSecret0,
                                obscureText: !consumerSecretVisibity,
                                cursorColor: Colors.white,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      left: 10, right: 68, bottom: 20, top: 20),
                                  label: Text('Consumer Secret'),
                                  border: OutlineInputBorder(),
                                  floatingLabelStyle:
                                      TextStyle(color: Colors.grey),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(9),
                                  child: Container(
                                    child: consumerSecretVisibity
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                consumerSecretVisibity = false;
                                              });
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Icon(Icons.visibility),
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                consumerSecretVisibity = true;
                                              });
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(Icons.visibility_off),
                                            ),
                                          ),
                                  ),
                                ),
                              )
                            ]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            child: Stack(children: [
                              TextField(
                                controller: passKey0,
                                obscureText: !passKeyVisibility,
                                cursorColor: Colors.white,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      left: 10, right: 68, bottom: 20, top: 20),
                                  label: Text('Pass Key'),
                                  border: OutlineInputBorder(),
                                  floatingLabelStyle:
                                      TextStyle(color: Colors.grey),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(9),
                                  child: Container(
                                    child: passKeyVisibility
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                passKeyVisibility = false;
                                              });
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Icon(Icons.visibility),
                                            ),
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                passKeyVisibility = true;
                                              });
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(Icons.visibility_off),
                                            ),
                                          ),
                                  ),
                                ),
                              )
                            ]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            child: TextField(
                              controller: paybillNumber,
                              style: const TextStyle(fontSize: 15),
                              cursorColor: Colors.white,
                              cursorWidth: 1,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey)),
                                label: Text('Paybill Number'),
                                floatingLabelStyle:
                                    TextStyle(color: Colors.grey),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  paybillNumber.value =
                                      paybillNumber.value.copyWith(
                                    text: value,
                                    selection: TextSelection.collapsed(
                                        offset: value.length),
                                  );
                                });
                              },
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(10),
                        //   child: Container(
                        //     child: TextField(
                        //       controller: accountNumber,
                        //       style: const TextStyle(fontSize: 15),
                        //       cursorColor: Colors.white,
                        //       cursorWidth: 1,
                        //       decoration: const InputDecoration(
                        //         border: OutlineInputBorder(),
                        //         focusedBorder: OutlineInputBorder(
                        //             borderSide: BorderSide(color: Colors.grey)),
                        //         label: Text('Account Number'),
                        //         floatingLabelStyle: TextStyle(color: Colors.grey),
                        //       ),
                        //       onChanged: (value) {
                        //         setState(() {
                        //           accountNumber.value =
                        //               accountNumber.value.copyWith(
                        //             text: value,
                        //             selection: TextSelection.collapsed(
                        //                 offset: value.length),
                        //           );
                        //         });
                        //       },
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: creating
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Updating Payment Portal',
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                30,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                17,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    BusyBeeCore().updateMpesaPayment(
                                        docId,
                                        widget.storeID,
                                        passKey0,
                                        consumerKey0,
                                        paybillNumber,
                                        consumerSecret0,
                                        context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Update Payment Portal',
                                        style: TextStyle(fontSize: 17),
                                      ),
                                    ),
                                  ),
                                ),
                        )
                      ],
                    );
                  }
                }
                return Container();
              }),
        ),
      ),
    ));
  }
}
