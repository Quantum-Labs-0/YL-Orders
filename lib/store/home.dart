// ignore_for_file: avoid_unnecessary_containers

import 'dart:async';

import 'package:ylorders/functions/core.dart';
import 'package:ylorders/models/item_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ylorders/store/cart.dart';
import 'package:ylorders/store/menu/monitor_orders.dart';
import 'package:ylorders/store/menu/store_management.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  List itemFeatures = [];
  List pageFilters = [];

  String appName = '';
  String packageName = '';
  String version = '';
  String buildNumber = '';
  bool is_Web = kIsWeb;

  Future checkExistance() async {
    DocumentSnapshot snapshotCategories = await FirebaseFirestore.instance
        .collection('Categories')
        .doc('Categories')
        .get();
    DocumentSnapshot appInformation = await FirebaseFirestore.instance
        .collection('App information')
        .doc('App information')
        .get();
    if (!appInformation.exists) {
      FirebaseFirestore.instance
          .collection('App information')
          .doc('App information')
          .set({'Latest Version': version});
    }
    if (!snapshotCategories.exists) {
      FirebaseFirestore.instance
          .collection('Categories')
          .doc('Categories')
          .set({'Categories': []});
    }
  }

  updateState() {
    setState(() {});
  }

  appInformation() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appName = packageInfo.appName;
      packageName = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
  }

  checkAppVersion() async {
    DocumentSnapshot appInformation = await FirebaseFirestore.instance
        .collection('App information')
        .doc('App information')
        .get();
    String latestVersion = appInformation.get('Latest Version');
    if (latestVersion != version) {
      if (!is_Web) {
        updateApp();
      }
    }
  }

  bool hasNet = false;

  updateApp() async {
    final Uri url = Uri.parse(
        'https://play.google.com/store/apps/details?id=com.yoghlabs.shaleslate&pli=1');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    appInformation();
    checkAppVersion();
    checkExistance();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueGrey[700],
          title: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Profiles')
                  .doc(uid)
                  .snapshots(),
              builder: (context, snapshotProfile) {
                if (snapshotProfile.hasData) {
                  final data = snapshotProfile.data!;
                  bool hasOpenedMenu = data['Opened Menu'];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          BusyBeeCore().updateMeNU();
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  scrollable: true,
                                  content: Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, top: 30),
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                // GestureDetector(
                                                //   onTap: () {
                                                //     BusyBeeCore()
                                                //         .showToast('Open Account Page');
                                                //     // stock-up store, edit item prices, create promo codes for items (one code == one item)
                                                //   },
                                                //   child: Container(
                                                //       child: Icon(
                                                //     Icons.account_circle_rounded,
                                                //     size: 30,
                                                //   )),
                                                // ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: ((context) =>
                                                                StoreManagement())));
                                                  },
                                                  child: Container(
                                                      child: Icon(
                                                    Icons.hive,
                                                    size: 30,
                                                    color: Colors.black,
                                                  )),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: ((context) =>
                                                                ManageOrders())));
                                                  },
                                                  child: Container(
                                                      child: Icon(
                                                    Icons
                                                        .precision_manufacturing,
                                                    size: 30,
                                                    color: Colors.black,
                                                  )),
                                                ),
                                              ],
                                            ),
                                            // Padding(
                                            //   padding: const EdgeInsets.only(top: 30),
                                            //   child: Row(
                                            //     mainAxisAlignment:
                                            //         MainAxisAlignment.spaceAround,
                                            //     children: [
                                            //       GestureDetector(
                                            //         onTap: () {
                                            //           BusyBeeCore().showToast(
                                            //               'Open Settings Page');
                                            //           // view settings: gridview, pageview, listview
                                            //           // font size, weight and color
                                            //           // app themes: dancing-multi-colors, light, dark
                                            //           // show product rating or store rating (aggregate of store products rating) in home or all pageview(s)
                                            //         },
                                            //         child: Container(
                                            //             child: Icon(
                                            //           Icons.settings,
                                            //           size: 30,
                                            //         )),
                                            //       ),
                                            //       GestureDetector(
                                            //         onTap: () {
                                            //           BusyBeeCore().showToast(
                                            //               'Open Saved items Page');
                                            //         },
                                            //         child: Container(
                                            //             child: Icon(
                                            //           Icons.bookmark,
                                            //           size: 30,
                                            //         )),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  actions: const [],
                                );
                              });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: hasOpenedMenu
                                  ? Border(
                                      bottom: BorderSide.none,
                                      top: BorderSide.none,
                                      left: BorderSide.none,
                                      right: BorderSide.none)
                                  : Border.all(color: Colors.black)),
                          child: Padding(
                            padding: EdgeInsets.all(hasOpenedMenu ? 0 : 8),
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 3),
                                      child: Icon(
                                        Icons.hive,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'YL - O',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                hasOpenedMenu
                                    ? Container()
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Container(
                                          color:
                                              BusyBeeCore().getRandomColor(.5),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 3),
                                                  child: Icon(
                                                    Icons
                                                        .keyboard_double_arrow_left_rounded,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Text(
                                                  'Click',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          pageFilters.isNotEmpty
                              ? GestureDetector(
                                  onTap: () => pageFilters.clear(),
                                  child: Container(
                                    // anchor of the tree
                                    // Tree -> when a category is selected a new sub category is created from compressing the features of the parent to sub groups and on and on....
                                    // the tree is a search filter to naarow the search as much as possible
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Center(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Optimized',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                    )),
                                  ),
                                )
                              : Container(),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: GestureDetector(
                              onTap: () => BusyBeeCore().searchView(context,
                                  searchController, itemFeatures, updateState),
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => Cart())),
                              child: Container(
                                // show number of items in cart if > 0
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Icon(
                                    Icons.shopping_cart_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
                return Container();
              }),
        ),
        body: Container(
          color: BusyBeeCore().getRandomColor(.2),
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 15,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Categories')
                        .doc('Categories')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data!;
                        List categories = data['Categories'];
                        return MasonryGridView.builder(
                            itemCount: categories.length,
                            gridDelegate:
                                SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1),
                            padding: EdgeInsets.all(5),
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    pageFilters.contains(category.toString())
                                        ? pageFilters
                                            .remove(category.toString())
                                        : pageFilters.add(category.toString());
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black)),
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(category.toString()),
                                  )),
                                ),
                              );
                            });
                      }
                      return Container();
                    }),
              ),
              Expanded(
                child: Container(
                  child: StreamBuilder(
                      stream: pageFilters.isEmpty
                          ? FirebaseFirestore.instance
                              .collection('Store Items')
                              .snapshots()
                          : FirebaseFirestore.instance
                              .collection('Store Items')
                              .where('Features', arrayContainsAny: pageFilters)
                              .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data!;
                          List storeItems = data.docs;
                          return PageView.builder(
                              // Build pages based on the search filter if not empty or random items based on trending or hot deals
                              itemCount: storeItems.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                final storeItem = storeItems[index];
                                List itemImagesCore = storeItem['Item Images'];
                                int currentIndex = 0;

                                List ratings = storeItem['Ratings'];
                                List itemFeaturesCore = storeItem['Features'];
                                List delivered = storeItem['Delivered'];

                                return Container(
                                  color: BusyBeeCore().getRandomColor(0.2),
                                  child: Column(
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                3,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: BusyBeeCore().getRandomColor(.4),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if (currentIndex > 0) {
                                                  setState(() {
                                                    currentIndex =
                                                        currentIndex - 1;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                color: BusyBeeCore()
                                                    .getRandomColor(.3),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  // if saved use bookmark_saved
                                                  child: Icon(
                                                    Icons.arrow_back_ios_new,
                                                    size: 30,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.3,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  3,
                                              color: BusyBeeCore()
                                                  .getRandomColor(.3),
                                              child: Image.network(
                                                itemImagesCore[currentIndex],
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if (currentIndex <
                                                        itemImagesCore.length) {
                                                      setState(() {
                                                        currentIndex =
                                                            currentIndex + 1;
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    color: BusyBeeCore()
                                                        .getRandomColor(.3),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      // if saved use bookmark_saved
                                                      child: Icon(
                                                        Icons.arrow_forward_ios,
                                                        size: 30,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    final uid = FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid;
                                                    DocumentSnapshot item =
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'Saved Items')
                                                            .doc(uid)
                                                            .get();
                                                    if (!item.exists) {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              'Saved Items')
                                                          .doc(uid)
                                                          .set(
                                                              {'Item IDs': []});
                                                      item =
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'Saved Items')
                                                              .doc(uid)
                                                              .get();
                                                    }
                                                    List mySavedItems =
                                                        item['Item IDs'];
                                                    mySavedItems.contains(
                                                            storeItem[
                                                                'Item ID'])
                                                        ? FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'Saved Items')
                                                            .doc(uid)
                                                            .update({
                                                            'Item IDs': FieldValue
                                                                .arrayRemove([
                                                              storeItem[
                                                                  'Item ID']
                                                            ])
                                                          })
                                                        : FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'Saved Items')
                                                            .doc(uid)
                                                            .update({
                                                            'Item IDs':
                                                                FieldValue
                                                                    .arrayUnion([
                                                              storeItem[
                                                                  'Item ID']
                                                            ])
                                                          });
                                                  },
                                                  child: Container(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      // if saved use bookmark_saved
                                                      child: Icon(
                                                        Icons.bookmark_add,
                                                        size: 30,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                color: BusyBeeCore()
                                                    .getRandomColor(.3),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Container(
                                                      child: Column(
                                                        children: [
                                                          Text('Delivered'),
                                                          Text(delivered.length
                                                              .toString())
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Column(
                                                        children: [
                                                          Text('In-Stock'),
                                                          Text(
                                                              '${storeItem['In-Stock']}')
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3.5,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              25,
                                                      child: ListView.builder(
                                                          itemCount:
                                                              ratings.length,
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Icon(
                                                                Icons.star);
                                                          }),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    3,
                                                color: BusyBeeCore()
                                                    .getRandomColor(.3),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8,
                                                          right: 8,
                                                          bottom: 8),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      TabBar(tabs: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(7.5),
                                                          child: Text(
                                                            'Description',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(7.5),
                                                          child: Text(
                                                            'Features',
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ]),
                                                      Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            3.7,
                                                        child: TabBarView(
                                                            children: [
                                                              GestureDetector(
                                                                onTap: () {
                                                                  // bottomsheet to show full description
                                                                },
                                                                child:
                                                                    Container(
                                                                  child: Text(
                                                                    storeItem[
                                                                        'Description'],
                                                                    style: TextStyle(
                                                                        overflow:
                                                                            TextOverflow.ellipsis),
                                                                  ),
                                                                ),
                                                              ),
                                                              ListView.builder(
                                                                  itemCount:
                                                                      itemFeaturesCore
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    String
                                                                        feature =
                                                                        itemFeaturesCore[
                                                                            index];
                                                                    return Container(
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(right: 5),
                                                                            child:
                                                                                Icon(
                                                                              Icons.circle,
                                                                              size: 5,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                              '$feature.'),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }),
                                                            ]),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                color: BusyBeeCore()
                                                    .getRandomColor(.3),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                              storeItem[
                                                                  'Item Name'],
                                                              style: TextStyle(
                                                                  fontSize: 16),
                                                            ),
                                                          ),
                                                          Container(
                                                              child: Row(
                                                            children: [
                                                              Text(
                                                                'KES ${storeItem['Current Price']}',
                                                              ),
                                                              BusyBeeCore().stringToDouble(
                                                                          storeItem[
                                                                              'Old Price']) ==
                                                                      0
                                                                  ? Container()
                                                                  : Text(
                                                                      ' was ${storeItem['Old Price']}',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red[50]),
                                                                    ),
                                                            ],
                                                          )),
                                                        ],
                                                      ),
                                                      Container(
                                                        child: StreamBuilder(
                                                            stream:
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'Carts')
                                                                    .doc(uid)
                                                                    .snapshots(),
                                                            builder: (context,
                                                                snapshotCart) {
                                                              if (snapshotCart
                                                                  .hasData) {
                                                                final data =
                                                                    snapshotCart
                                                                        .data!;
                                                                List cart =
                                                                    data[
                                                                        'Cart'];
                                                                int itemsOrdered =
                                                                    0;
                                                                for (var element
                                                                    in cart) {
                                                                  if (element[
                                                                          'Item ID'] ==
                                                                      storeItem[
                                                                          'Item ID']) {
                                                                    itemsOrdered =
                                                                        BusyBeeCore()
                                                                            .stringToInt(element['Orders']);
                                                                  }
                                                                }
                                                                return itemsOrdered ==
                                                                        0
                                                                    ? GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          BusyBeeCore().updateCart(
                                                                              storeItem['Item ID'],
                                                                              true,
                                                                              storeItem['In-Stock']);
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          color:
                                                                              BusyBeeCore().getRandomColor(.6),
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsets.only(
                                                                                left: 30,
                                                                                right: 30,
                                                                                top: 10,
                                                                                bottom: 10),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(right: 10),
                                                                                  child: Icon(
                                                                                    Icons.shopping_cart,
                                                                                    size: 20,
                                                                                  ),
                                                                                ),
                                                                                Text('Cart'),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            GestureDetector(
                                                                                onTap: () => BusyBeeCore().updateCart(storeItem['Item ID'], false, storeItem['In-Stock']),
                                                                                child: Container(child: Icon(Icons.remove))),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: Text(
                                                                                itemsOrdered.toString(),
                                                                                style: TextStyle(fontSize: 17),
                                                                              ),
                                                                            ),
                                                                            GestureDetector(
                                                                              onTap: () => BusyBeeCore().updateCart(storeItem['Item ID'], true, storeItem['In-Stock']),
                                                                              child: Container(child: Icon(Icons.add)),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      );
                                                              }
                                                              return Container();
                                                            }),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              });
                        }
                        return Container();
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
