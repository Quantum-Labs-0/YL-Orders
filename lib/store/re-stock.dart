// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:ylorders/functions/core.dart';
import 'package:ylorders/models/Items_category_selection.dart';
import 'package:ylorders/models/item_features.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Restock extends StatefulWidget {
  const Restock({super.key});

  @override
  State<Restock> createState() => _RestockState();
}

class _RestockState extends State<Restock> {
  bool itemNameCheck = false;
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemCategoryController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  TextEditingController itemDescriptionController = TextEditingController();
  TextEditingController itemFeatureController = TextEditingController();
  TextEditingController itemStockCountController = TextEditingController();
  File? itemThumbnail;
  String? itemThumbnailImageName;
  List<String> itemImagesNames = [];
  List<File> itemImages = [];
  List<String> itemFeatures = [];
  bool restocking = false;
  bool is_web = kIsWeb;

  // Future<void> compressImages() async {
  //   final compressedFile = await FlutterImageCompress.compressAndGetFile(
  //     image!.path,
  //     image!.path,
  //   );
  //   setState(() {
  //     image = File(compressedFile!.path);
  //   });
  // }

  Future pickItemImages(ImageSource source) async {
    try {
      List<XFile> images0 =
          await ImagePicker().pickMultiImage(requestFullMetadata: true);

      if (images0.isEmpty) return;
      for (var element in images0) {
        itemImages.add(File(element.path));
        itemImagesNames.add(element.name);
      }
      //compressImage();
    } on PlatformException {
      is_web
          ? ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to pick profile image')))
          : BusyBeeCore().showToast('Failed to pick profile image');
    }
  }

  Future pickThubnailImage(ImageSource source) async {
    try {
      final image = await ImagePicker()
          .pickImage(source: source, requestFullMetadata: true);

      if (image == null) return;
      setState(() {
        itemThumbnail = File(image.path);
        itemThumbnailImageName = image.name;
      });
      //compressImage();
    } on PlatformException {
      is_web
          ? ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to pick profile image')))
          : BusyBeeCore().showToast('Failed to pick profile image');
    }
  }

  updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BusyBeeCore().getRandomColor(.2),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '',
              style: TextStyle(color: Colors.black),
            ),
            restocking
                ? Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: Container(
                      color: BusyBeeCore().getRandomColor(.3),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'Restocking',
                              style: TextStyle(color: Colors.black),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 7),
                              child: Container(
                                width: MediaQuery.of(context).size.width / 19,
                                height: MediaQuery.of(context).size.height / 34,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () async {
                      if (itemNameController.text.isNotEmpty &&
                          itemCategoryController.text.isNotEmpty &&
                          itemPriceController.text.isNotEmpty &&
                          itemStockCountController.text.isNotEmpty &&
                          itemThumbnail != null &&
                          itemImages.isNotEmpty) {
                        restocking = true;
                        await BusyBeeCore().createItem(
                            itemNameController,
                            itemImages,
                            itemThumbnail!,
                            itemFeatures,
                            itemDescriptionController,
                            BusyBeeCore().stringToInt(
                                itemStockCountController.text.toString()),
                            itemCategoryController,
                            BusyBeeCore().stringToDouble(
                                itemPriceController.text.toString()));
                        restocking = false;
                        Navigator.of(context).pop();
                        BusyBeeCore().showToast('Restocking Complete');
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: BusyBeeCore().getRandomColor(.3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Restock',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: BusyBeeCore().getRandomColor(.2),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Store Items')
                        .where('Item Name', isEqualTo: itemNameController.text)
                        .snapshots(),
                    builder: (context, snapshotNames) {
                      if (snapshotNames.hasData) {
                        List storeItems = snapshotNames.data!.docs;
                        return Container(
                          child: TextField(
                            controller: itemNameController,
                            style: const TextStyle(fontSize: 15),
                            cursorColor: Colors.black,
                            cursorWidth: 1,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: itemNameController.text.isNotEmpty
                                          ? storeItems.isEmpty
                                              ? Colors.green
                                              : Colors.red
                                          : Colors.transparent)),
                              label: const Text('Item Name'),
                              floatingLabelStyle:
                                  const TextStyle(color: Colors.black),
                            ),
                          ),
                        );
                      }
                      return Container();
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.29,
                      child: TextField(
                        controller: itemCategoryController,
                        cursorColor: Colors.black,
                        enabled: false,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              left: 10, right: 68, bottom: 20, top: 20),
                          label: const Text('Item Category'),
                          border: const OutlineInputBorder(),
                          floatingLabelStyle:
                              const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (context) => ItemsCategorySelection(
                                itemCategoryController: itemCategoryController,
                              )),
                      child: Container(
                        color: BusyBeeCore().getRandomColor(.3),
                        width: MediaQuery.of(context).size.width / 7,
                        height: MediaQuery.of(context).size.height / 15,
                        child: Icon(Icons.category_rounded),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2.2,
                      child: TextField(
                        controller: itemPriceController,
                        style: const TextStyle(fontSize: 15),
                        cursorColor: Colors.black,
                        cursorWidth: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: itemPriceController.text.isNotEmpty
                                      ? BusyBeeCore().stringToDouble(
                                                  itemPriceController.text) >
                                              0.0
                                          ? Colors.green
                                          : Colors.red
                                      : Colors.transparent)),
                          label: const Text('Item Price'),
                          floatingLabelStyle:
                              const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.2,
                      child: TextField(
                        controller: itemStockCountController,
                        style: const TextStyle(fontSize: 15),
                        cursorColor: Colors.black,
                        cursorWidth: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      itemStockCountController.text.isNotEmpty
                                          ? BusyBeeCore().stringToDouble(
                                                      itemStockCountController
                                                          .text) >
                                                  0.0
                                              ? Colors.green
                                              : Colors.red
                                          : Colors.transparent)),
                          label: const Text('Stock Count'),
                          floatingLabelStyle:
                              const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  child: TextField(
                    controller: itemDescriptionController,
                    style: const TextStyle(fontSize: 15),
                    cursorColor: Colors.black,
                    cursorWidth: 1,
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: itemDescriptionController.text.isNotEmpty
                                  ? Colors.green
                                  : Colors.red)),
                      label: const Text('Item Description'),
                      floatingLabelStyle: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.29,
                      child: TextField(
                        controller: itemFeatureController,
                        cursorColor: Colors.black,
                        enabled: false,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                              left: 10, right: 68, bottom: 20, top: 20),
                          label: const Text('Item Features Creation'),
                          border: const OutlineInputBorder(),
                          floatingLabelStyle:
                              const TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ItemFeatures(
                                  itemFeatures: itemFeatures,
                                  updateState: updateState))),
                      child: Container(
                        color: BusyBeeCore().getRandomColor(.4),
                        width: MediaQuery.of(context).size.width / 7,
                        height: MediaQuery.of(context).size.height / 15,
                        child: Icon(Icons.featured_play_list_outlined),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          is_web
                              ? pickThubnailImage(ImageSource.gallery)
                              : await BusyBeeCore()
                                      .storagePermission()
                                      .isGranted
                                  ? pickThubnailImage(ImageSource.gallery)
                                  : await BusyBeeCore().storagePermission();
                        },
                        child: Container(
                          color: BusyBeeCore().getRandomColor(.3),
                          width: MediaQuery.of(context).size.width / 2.2,
                          height: MediaQuery.of(context).size.height / 6,
                          child: itemThumbnail == null
                              ? Center(child: Text('Item Thumbnail Image'))
                              : Image.file(
                                  itemThumbnail!,
                                  fit: BoxFit.contain,
                                ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          is_web
                              ? pickItemImages(ImageSource.gallery)
                              : await BusyBeeCore()
                                      .storagePermission()
                                      .isGranted
                                  ? pickItemImages(ImageSource.gallery)
                                  : await BusyBeeCore().storagePermission();
                        },
                        child: Container(
                          color: BusyBeeCore().getRandomColor(.3),
                          width: MediaQuery.of(context).size.width / 2.2,
                          height: MediaQuery.of(context).size.height / 6,
                          child: itemImages.isEmpty
                              ? Center(child: Text('Item Images'))
                              : Image.file(
                                  itemImages[0],
                                  fit: BoxFit.contain,
                                ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
