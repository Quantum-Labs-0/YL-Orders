import 'package:ylorders/functions/core.dart';
import 'package:flutter/material.dart';

class ItemSearch extends StatefulWidget {
  const ItemSearch(
      {super.key,
      required this.searchController,
      required this.itemFeatures,
      required this.updateState});
  final TextEditingController searchController;
  final List itemFeatures;
  final Function updateState;

  @override
  State<ItemSearch> createState() => _ItemSearchState();
}

class _ItemSearchState extends State<ItemSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
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
                          controller: widget.searchController,
                          decoration: InputDecoration(
                              hintText: 'Search',
                              contentPadding: EdgeInsets.all(5),
                              border: InputBorder.none),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => widget.searchController.clear(),
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
                    itemCount: 30,
                    itemBuilder: ((context, index) {
                      return GestureDetector(
                        onTap: () {
                          // update item-features list with the features of the selected item into the search filter stream query for an optimized search
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 13,
                                  width: MediaQuery.of(context).size.width / 6,
                                  color: BusyBeeCore().getRandomColor(.5),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text('Name $index'),
                                )
                              ],
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
    );
  }
}
