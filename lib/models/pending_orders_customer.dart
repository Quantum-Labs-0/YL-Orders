import 'package:ylorders/functions/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PendingOrdersCustomer extends StatefulWidget {
  const PendingOrdersCustomer({super.key, required this.orderID});
  final String orderID;

  @override
  State<PendingOrdersCustomer> createState() => _PendingOrdersCustomerState();
}

class _PendingOrdersCustomerState extends State<PendingOrdersCustomer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: BusyBeeCore().getRandomColor(.2),
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Orders')
                .doc(widget.orderID)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                List itemsOrdered = data['Items Ordered'];
                return ListView.builder(
                    itemCount: itemsOrdered.length,
                    itemBuilder: ((context, index) {
                      final itemOrdered = itemsOrdered[index];
                      return Container(
                        color: BusyBeeCore().getRandomColor(.3),
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('Store Items')
                                .doc(itemOrdered['Item ID'])
                                .snapshots(),
                            builder: (context, snapshotItem) {
                              if (snapshotItem.hasData) {
                                final item = snapshotItem.data!;

                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                10,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                4,
                                            color: BusyBeeCore()
                                                .getRandomColor(.5),
                                            child: Image.network(
                                                item['Item Thumbnail']),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.1,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Text(
                                                        item['Item Name'],
                                                        style: TextStyle(
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis)),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      'Orders => ${itemOrdered['Orders']}',
                                                      style: TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        child: Text(
                                                          'KES ${item['Current Price']}',
                                                          style: TextStyle(
                                                              fontSize: 17,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                        ),
                                                      ),
                                                      itemOrdered['Order Complete'] ==
                                                              true
                                                          ? Container(
                                                              color: BusyBeeCore()
                                                                  .getRandomColor(
                                                                      .3),
                                                              child: Text(
                                                                'Complete',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 17,
                                                                ),
                                                              ),
                                                            )
                                                          : Container(
                                                              color: BusyBeeCore()
                                                                  .getRandomColor(
                                                                      .3),
                                                              child: Text(
                                                                'Pending',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 17,
                                                                ),
                                                              ),
                                                            ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return Container();
                            }),
                      );
                    }));
              }
              return Container();
            }),
      ),
    );
  }
}
