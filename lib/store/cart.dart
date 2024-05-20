import 'package:ylorders/functions/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: BusyBeeCore().getRandomColor(.2),
        automaticallyImplyLeading: false,
        title: Text(
          'Shopping Cart',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: BusyBeeCore().getRandomColor(.2),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 1.235,
              width: MediaQuery.of(context).size.width,
              color: BusyBeeCore().getRandomColor(.4),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Carts')
                      .doc(uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!;
                      List cartItems = data['Cart'];
                      return ListView.builder(
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            final cartItem = cartItems[index];
                            return Container(
                              color: BusyBeeCore().getRandomColor(.3),
                              child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('Store Items')
                                      .doc(cartItem['Item ID'])
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
                                                    item['Item Thumbnail'],
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2.1,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                              item['Item Name'],
                                                              style: TextStyle(
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis)),
                                                        ),
                                                        // Container(
                                                        //   child: Text(
                                                        //     'Storage Capacity: 256 GB',
                                                        //     style: TextStyle(
                                                        //         overflow:
                                                        //             TextOverflow.ellipsis),
                                                        //   ),
                                                        // ),
                                                        Container(
                                                          child: Text(
                                                            'KES ${item['Current Price']}',
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              child: Row(
                                                children: [
                                                  GestureDetector(
                                                      onTap: () => BusyBeeCore()
                                                          .updateCart(
                                                              item['Item ID'],
                                                              false,
                                                              item['In-Stock']),
                                                      child: Container(
                                                          child: Icon(
                                                              Icons.remove))),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      cartItem['Orders'],
                                                      style: TextStyle(
                                                          fontSize: 17),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () => BusyBeeCore()
                                                        .updateCart(
                                                            item['Item ID'],
                                                            true,
                                                            item['In-Stock']),
                                                    child: Container(
                                                        child: Icon(Icons.add)),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                    return Container();
                                  }),
                            );
                          });
                    }
                    return Container();
                  }),
            ),
            Container(
              color: BusyBeeCore().getRandomColor(.4),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Carts')
                              .doc(uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final data = snapshot.data!;
                              List cartItems = data['Cart'];

                              return Column(
                                children: [
                                  Text(
                                    'Total',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    'KES ${BusyBeeCore().totalPrice(cartItems)}',
                                    style: TextStyle(fontSize: 17),
                                  ) // use a function to the total price for checkout
                                ],
                              );
                            }
                            return Container();
                          }),
                    ),
                    // Container(
                    //   child: StreamBuilder(
                    //       stream: FirebaseFirestore.instance
                    //           .collection('Profiles')
                    //           .doc(uid)
                    //           .snapshots(),
                    //       builder: (context, snapshotProfile) {
                    //         if (snapshotProfile.hasData) {
                    //           final data = snapshotProfile.data!;
                    //           String customerName = data['Username'];
                    //           String phoneNumber = data['Phone Number'];

                    //           return Container(
                    //             child: StreamBuilder(
                    //                 stream: FirebaseFirestore.instance
                    //                     .collection('Stores')
                    //                     .doc(uid)
                    //                     .snapshots(),
                    //                 builder: (context, snapshotStoreMpesa) {
                    //                   if (snapshotStoreMpesa.hasData) {
                    //                     final storeData =
                    //                         snapshotStoreMpesa.data!;
                    //                     String mpesaDocID =
                    //                         storeData['Mpesa Document ID'];
                    //                     return StreamBuilder(
                    //                         stream: FirebaseFirestore.instance
                    //                             .collection('Payment Methods')
                    //                             .doc(mpesaDocID)
                    //                             .snapshots(),
                    //                         builder: (context, snapshotMpesa) {
                    //                           if (snapshotMpesa.hasData) {
                    //                             final mpesaData =
                    //                                 snapshotMpesa.data!;
                    //                             String paybillNumber =
                    //                                 mpesaData['Paybill Number'];
                    //                             String clientKey =
                    //                                 mpesaData['Consumer Key'];
                    //                             String clientSecret = mpesaData[
                    //                                 'Consumer Secret'];
                    //                             String passKey =
                    //                                 mpesaData['Pass Key'];
                    //                             return StreamBuilder(
                    //                                 stream: FirebaseFirestore
                    //                                     .instance
                    //                                     .collection('Carts')
                    //                                     .doc(uid)
                    //                                     .snapshots(),
                    //                                 builder: (context,
                    //                                     snapshotCart) {
                    //                                   if (snapshotCart
                    //                                       .hasData) {
                    //                                     final data =
                    //                                         snapshotCart.data!;
                    //                                     List cartItems =
                    //                                         data['Cart'];

                    //                                     return GestureDetector(
                    //                                       onTap: () {
                    //                                         BusyBeeCore().initializeMpesaPaybilTansaction(
                    //                                             customerName,
                    //                                             phoneNumber,
                    //                                             BusyBeeCore().stringToDouble(BusyBeeCore()
                    //                                                 .totalPrice(
                    //                                                     cartItems)
                    //                                                 .toString()),
                    //                                             paybillNumber,
                    //                                             clientKey,
                    //                                             clientSecret,
                    //                                             passKey);
                    //                                       },
                    //                                       child: Container(
                    //                                         decoration: BoxDecoration(
                    //                                             border: Border.all(
                    //                                                 color: Colors
                    //                                                     .black)),
                    //                                         child: Padding(
                    //                                           padding:
                    //                                               const EdgeInsets
                    //                                                   .only(
                    //                                                   left: 10,
                    //                                                   right: 4),
                    //                                           child: Row(
                    //                                             children: [
                    //                                               Text(
                    //                                                   'Checkout'),
                    //                                               Padding(
                    //                                                 padding:
                    //                                                     const EdgeInsets
                    //                                                         .all(
                    //                                                         8.0),
                    //                                                 child: Icon(
                    //                                                     Icons
                    //                                                         .shopping_cart_checkout),
                    //                                               )
                    //                                             ],
                    //                                           ),
                    //                                         ),
                    //                                       ),
                    //                                     );
                    //                                   }
                    //                                   return Container();
                    //                                 });
                    //                           }
                    //                           return Container();
                    //                         });
                    //                   }
                    //                   return Container();
                    //                 }),
                    //           );
                    //         }
                    //         return Container();
                    //       }),
                    // )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
