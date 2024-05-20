import 'package:ylorders/charts/bar/bar_graph.dart';
import 'package:ylorders/functions/core.dart';
import 'package:ylorders/store/re-stock.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StoreManagement extends StatefulWidget {
  const StoreManagement({super.key});

  @override
  State<StoreManagement> createState() => _StoreManagementState();
}

class _StoreManagementState extends State<StoreManagement> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  TextEditingController storeNameController = TextEditingController();
  bool storeNameCheck = false;
  @override
  void initState() {
    BusyBeeCore().checkShoppingStuffExistance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: BusyBeeCore().getRandomColor(.2),
          title: Text(
            'Store Management',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Container(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Stores')
                  .doc(uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  String storeName = data['Store Name'];
                  String storeID = data['Store ID'];

                  return storeName.isEmpty
                      ? Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: BusyBeeCore().getRandomColor(.2),
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                showBottomSheet(
                                    context: context,
                                    builder: (context) => Container(
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Container(
                                                  child: StreamBuilder(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection('Stores')
                                                          .snapshots(),
                                                      builder: (context,
                                                          snapshotStores) {
                                                        if (snapshotStores
                                                            .hasData) {
                                                          List data =
                                                              snapshotStores
                                                                  .data!.docs;
                                                          List allStoreNames =
                                                              [];
                                                          for (var element
                                                              in data) {
                                                            String storeName =
                                                                element[
                                                                    'Store Name'];
                                                            allStoreNames
                                                                .add(storeName);
                                                          }
                                                          allStoreNames.contains(
                                                                  storeNameController
                                                                      .text)
                                                              ? storeNameCheck =
                                                                  false
                                                              : storeNameCheck =
                                                                  true;
                                                          return TextField(
                                                            controller:
                                                                storeNameController,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15),
                                                            cursorColor:
                                                                Colors.black,
                                                            cursorWidth: 1,
                                                            decoration:
                                                                InputDecoration(
                                                              border:
                                                                  const OutlineInputBorder(),
                                                              focusedBorder: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: storeNameCheck
                                                                          ? Colors
                                                                              .green
                                                                          : Colors
                                                                              .red)),
                                                              label: const Text(
                                                                  'Store Name'),
                                                              floatingLabelStyle:
                                                                  const TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                            ),
                                                          );
                                                        }
                                                        return Container();
                                                      }),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    BusyBeeCore().setupStore(
                                                        storeNameController,
                                                        storeID);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    color: BusyBeeCore()
                                                        .getRandomColor(.3),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        'Done',
                                                        style: TextStyle(
                                                            fontSize: 17),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ));
                              },
                              child: Container(
                                color: BusyBeeCore().getRandomColor(.3),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Create Store',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 3.55,
                              width: MediaQuery.of(context).size.width,
                              color: BusyBeeCore().getRandomColor(.2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    color: BusyBeeCore().getRandomColor(.2),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const Restock()));
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: BusyBeeCore()
                                                      .getRandomColor(.4),
                                                  border: Border.all(
                                                      color: Colors.black)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: Icon(
                                                  Icons.add,
                                                  size: 35,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  storeName,
                                                  style: TextStyle(
                                                      fontSize: 22,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                                Text(
                                                  DateTimeFormat.format(
                                                          DateTime.now(),
                                                          format: 'j M Y ')
                                                      .toString(),
                                                  style:
                                                      TextStyle(fontSize: 17),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    color: BusyBeeCore().getRandomColor(.2),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                6.5,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.05,
                                            color: BusyBeeCore()
                                                .getRandomColor(.4),
                                            child: StreamBuilder(
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('Order')
                                                    .snapshots(),
                                                builder:
                                                    (context, snapshotItems) {
                                                  if (snapshotItems.hasData) {
                                                    List allOrders =
                                                        snapshotItems
                                                            .data!.docs;
                                                    List myStoreOrders = [];
                                                    for (var element
                                                        in allOrders) {
                                                      List orderItems = element[
                                                          'Items Ordered'];
                                                      for (var element0
                                                          in orderItems) {
                                                        String storeID0 =
                                                            element0[
                                                                'Store ID'];
                                                        bool orderComplete =
                                                            element0[
                                                                'Order Complete'];
                                                        if (storeID0 == uid &&
                                                            orderComplete) {
                                                          myStoreOrders
                                                              .add(element0);
                                                        }
                                                      }
                                                    }
                                                    Map<String, double>
                                                        monthlyRevenues = {};
                                                    for (var element
                                                        in myStoreOrders) {
                                                      String orderID0 =
                                                          element['Order ID'];
                                                      BusyBeeCore()
                                                          .getRevenueForGraph(
                                                              monthlyRevenues,
                                                              orderID0);
                                                    }
                                                    return Center(
                                                      child: MyBarGraph(
                                                        weeklySummary: BusyBeeCore()
                                                            .extractMonthlyCosts(
                                                                monthlyRevenues),
                                                      ),
                                                    );
                                                  }
                                                  return Container();
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: BusyBeeCore().getRandomColor(.2),
                              child: TabBar(tabs: [
                                Tab(
                                  child: Text(
                                    'Inventory',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    'Orders',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                )
                              ]),
                            ),
                            Container(
                              height:
                                  MediaQuery.of(context).size.height / 1.841,
                              width: MediaQuery.of(context).size.width,
                              child: TabBarView(children: [
                                Container(
                                  color: BusyBeeCore().getRandomColor(.3),
                                  child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('Store Items')
                                          .where('Store ID', isEqualTo: uid)
                                          .snapshots(),
                                      builder: (context, snapshotInventory) {
                                        if (snapshotInventory.hasData) {
                                          List itemDocs =
                                              snapshotInventory.data!.docs;
                                          return GridView.builder(
                                              gridDelegate:
                                                  SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                              ),
                                              itemCount: itemDocs.length,
                                              itemBuilder: (context, index) {
                                                final item = itemDocs[index];
                                                return GestureDetector(
                                                  onTap: () {
                                                    // open item overview model
                                                  },
                                                  child: Container(
                                                    color: BusyBeeCore()
                                                        .getRandomColor(.4),
                                                    child: Image.network(
                                                      item['Item Thumbnail'],
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                                );
                                              });
                                        }
                                        return Container();
                                      }),
                                ),
                                Container(
                                  color: BusyBeeCore().getRandomColor(.3),
                                  child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('Orders')
                                          .snapshots(),
                                      builder: (context, snapshotOrders) {
                                        if (snapshotOrders.hasData) {
                                          List orders =
                                              snapshotOrders.data!.docs;
                                          List myOrders = [];
                                          for (var element in orders) {
                                            List itemsOrdered =
                                                element['Items Ordered'];
                                            for (var element0 in itemsOrdered) {
                                              String storeID0 =
                                                  element0['Store ID'];
                                              if (storeID0 == uid) {
                                                myOrders.add(element0);
                                              }
                                            }
                                          }
                                          return ListView.builder(
                                              itemCount: myOrders.length,
                                              itemBuilder: (context, index) {
                                                final order = myOrders[index];
                                                return Container(
                                                  color: BusyBeeCore()
                                                      .getRandomColor(.4),
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height /
                                                                13,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                5,
                                                            color: BusyBeeCore()
                                                                .getRandomColor(
                                                                    .7),
                                                            child:
                                                                StreamBuilder(
                                                                    stream: FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            'Store Items')
                                                                        .doc(order[
                                                                            'Item ID'])
                                                                        .snapshots(),
                                                                    builder:
                                                                        (context,
                                                                            snapshotOrderItem) {
                                                                      if (snapshotOrderItem
                                                                          .hasData) {
                                                                        final item =
                                                                            snapshotOrderItem.data!;
                                                                        return Image.network(
                                                                            item['Item Thumbnail']);
                                                                      }
                                                                      return Container();
                                                                    }),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    left: 10,
                                                                    right: 10),
                                                            child: Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  1.9,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    child: StreamBuilder(
                                                                        stream: FirebaseFirestore.instance.collection('Store Items').doc(order['Item ID']).snapshots(),
                                                                        builder: (context, snapshotOrderItem) {
                                                                          if (snapshotOrderItem
                                                                              .hasData) {
                                                                            final item =
                                                                                snapshotOrderItem.data!;
                                                                            return Text(
                                                                              item['Item Name'],
                                                                              style: TextStyle(fontSize: 18, overflow: TextOverflow.ellipsis),
                                                                            );
                                                                          }
                                                                          return Container();
                                                                        }),
                                                                  ),
                                                                  Container(
                                                                    child: Row(
                                                                      children: [
                                                                        Text(
                                                                            'Orders => ${BusyBeeCore().formatNumber(order['Orders'], 0)}  '),
                                                                        Text(
                                                                            'Order Value => ${BusyBeeCore().formatNumber(order['Order Value'], 2)}')
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          order['Order Complete'] ==
                                                                  false
                                                              ? Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .black),
                                                                    color: BusyBeeCore()
                                                                        .getRandomColor(
                                                                            .3),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child: Center(
                                                                        child: Text(
                                                                      'Pending',
                                                                    )),
                                                                  ),
                                                                )
                                                              : Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .black),
                                                                    color: BusyBeeCore()
                                                                        .getRandomColor(
                                                                            .3),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child: Center(
                                                                        child: Text(
                                                                      'Complete',
                                                                    )),
                                                                  ),
                                                                )
                                                        ],
                                                      )),
                                                );
                                              });
                                        }
                                        return Container();
                                      }),
                                )
                              ]),
                            ),
                          ],
                        );
                }
                return Container();
              }),
        ),
      ),
    );
  }
}
