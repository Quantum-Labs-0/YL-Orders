import 'package:ylorders/charts/bar/individual_bar.dart';

class BarData {
  final double jan;
  final double feb;
  final double mar;
  final double apr;
  final double may;
  final double jun;
  final double jul;
  final double aug;
  final double sep;
  final double oct;
  final double nov;
  final double dec;

  BarData(
      {required this.jan,
      required this.feb,
      required this.mar,
      required this.apr,
      required this.may,
      required this.jun,
      required this.jul,
      required this.aug,
      required this.sep,
      required this.oct,
      required this.nov,
      required this.dec});
  List<IndividualBar> barData = [];

  void initializeData() {
    barData = [
      IndividualBar(x: 1, y: jan),
      IndividualBar(x: 2, y: feb),
      IndividualBar(x: 3, y: mar),
      IndividualBar(x: 4, y: apr),
      IndividualBar(x: 5, y: may),
      IndividualBar(x: 6, y: jun),
      IndividualBar(x: 7, y: jul),
      IndividualBar(x: 8, y: aug),
      IndividualBar(x: 9, y: sep),
      IndividualBar(x: 10, y: oct),
      IndividualBar(x: 11, y: nov),
      IndividualBar(x: 12, y: dec),
    ];
  }
}
