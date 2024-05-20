import 'package:ylorders/functions/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ManageOrders extends StatefulWidget {
  const ManageOrders({super.key});

  @override
  State<ManageOrders> createState() => _ManageOrdersState();
}

class _ManageOrdersState extends State<ManageOrders> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Orders')
                .where('Customer UID', isEqualTo: uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List myOrders = snapshot.data!.docs;
                return ListView.builder(
                    itemCount: myOrders.length,
                    itemBuilder: (context, index) {
                      final order = myOrders[index];
                      List itemsOrdered = order['Items Ordered'];
                      bool orderComplete = false;
                      List pendingOrders = [];
                      for (var element in itemsOrdered) {
                        bool isOrderComplete = element['Order Complete'];
                        if (!isOrderComplete) {
                          pendingOrders.add(element);
                        }
                      }
                      return GestureDetector(
                        onTap: () => BusyBeeCore()
                            .pendingOrdersView(context, order['Order ID']),
                        child: Container(
                          color: BusyBeeCore().getRandomColor(.4),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  'Date => ${order['Date']}'),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  'Orders => ${order['Orders']}  '),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  'Order Value => ${BusyBeeCore().formatNumber(order['Order Value'], 2)}'),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                        ),
                      );
                    });
              }
              return Container();
            }),
      ),
    );
  }
}
