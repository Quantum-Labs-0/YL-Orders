import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PaywallWidget extends StatefulWidget {
  final String title;
  final String description;
  final List<Package> packages;
  final ValueChanged<Package> onClickedPackage;
  const PaywallWidget(
      {super.key,
      required this.title,
      required this.description,
      required this.packages,
      required this.onClickedPackage});

  @override
  State<PaywallWidget> createState() => _PaywallWidgetState();
}

class _PaywallWidgetState extends State<PaywallWidget> {
  @override
  Widget build(BuildContext context) => Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.description),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: widget.packages.length,
                    itemBuilder: ((context, index) {
                      final package = widget.packages[index];
                      return buildPackage(context, package);
                    })),
              )
            ],
          ),
        ),
      );
  Widget buildPackage(BuildContext context, Package package) {
    final product = package.storeProduct;
    return Card(
      color: Colors.blue,
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        title: Text(
          product.title,
          style: const TextStyle(fontSize: 18),
        ),
        subtitle: Text(product.description),
        trailing: Text(
          product.priceString,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        onTap: () => widget.onClickedPackage(package),
      ),
    );
  }
}
