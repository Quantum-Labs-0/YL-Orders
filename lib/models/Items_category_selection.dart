import 'package:ylorders/functions/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItemsCategorySelection extends StatefulWidget {
  const ItemsCategorySelection(
      {super.key, required this.itemCategoryController});
  final TextEditingController itemCategoryController;

  @override
  State<ItemsCategorySelection> createState() => _ItemsCategorySelectionState();
}

class _ItemsCategorySelectionState extends State<ItemsCategorySelection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Categories')
                .doc('Categories')
                .snapshots(),
            builder: (context, snapshotCategory) {
              if (snapshotCategory.hasData) {
                final data = snapshotCategory.data!;
                List categories = data['Categories'];
                return GridView.builder(
                    itemCount: categories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            widget.itemCategoryController.text =
                                categories[index];
                            Navigator.pop(context);
                          },
                          child: Container(
                            color: BusyBeeCore().getRandomColor(.3),
                            child: Icon(
                              Icons.electrical_services,
                              size: 45,
                            ),
                          ),
                        ));
              }
              return Container();
            }),
      ),
    );
  }
}
