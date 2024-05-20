import 'package:ylorders/functions/core.dart';
import 'package:flutter/material.dart';

class ItemFeatures extends StatefulWidget {
  const ItemFeatures(
      {super.key, required this.itemFeatures, required this.updateState});
  final List itemFeatures;
  final Function updateState;

  @override
  State<ItemFeatures> createState() => _ItemFeaturesState();
}

class _ItemFeaturesState extends State<ItemFeatures> {
  TextEditingController itemFeatureController = TextEditingController();
  List myFeatures = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          color: BusyBeeCore().getRandomColor(.3),
                          child: TextField(
                            controller: itemFeatureController,
                            decoration: InputDecoration(
                                hintText: 'Item Feature',
                                contentPadding: EdgeInsets.all(5),
                                border: InputBorder.none),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => itemFeatureController.clear(),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(Icons.cancel_outlined),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: BusyBeeCore().getRandomColor(.3),
                  height: MediaQuery.of(context).size.height / 1.137,
                  child: ListView.builder(
                      itemCount: widget.itemFeatures.length,
                      itemBuilder: ((context, index) {
                        final feature = widget.itemFeatures[index];
                        return GestureDetector(
                          onDoubleTap: () {
                            setState(() {
                              widget.itemFeatures.removeAt(index);
                            });
                            widget.updateState;
                          },
                          child: Container(
                            color: BusyBeeCore().getRandomColor(.3),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                feature,
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                        );
                      })),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            widget.itemFeatures.add(itemFeatureController.text);
            widget.updateState;
            setState(() {
              itemFeatureController.clear();
            });
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
