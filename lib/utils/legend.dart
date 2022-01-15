import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'statsData.dart';



class GroupedBarChart extends StatelessWidget {
  final List<charts.Series<ObjectType, String>> seriesList;
  final bool animate;


  GroupedBarChart(this.seriesList, {required this.animate});

  factory GroupedBarChart.withSampleData(Data data) {
    return new GroupedBarChart(
      _createSampleData(data),
      // Disable animations for image tests.
      animate: false,
    );
  }


  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.grouped,
      behaviors: [new charts.SeriesLegend()],
    );
  }

  /// Create series list with multiple series
  /// ObjectType
  static List<charts.Series<ObjectType, String>> _createSampleData(Data data) {
    final TotalData = [
      new ObjectType('Face', data.face.totalTimes),
      new ObjectType('Phone', data.phone.totalTimes),
      new ObjectType('Bag', data.bag.totalTimes),
      new ObjectType('Watch', data.watch.totalTimes),
      new ObjectType('Bottle', data.bottle.totalTimes),
    ];

    final RightData = [
      new ObjectType('Face', data.face.correct),
      new ObjectType('Phone', data.phone.correct),
      new ObjectType('Bag', data.bag.correct),
      new ObjectType('Watch', data.watch.correct),
      new ObjectType('Bottle', data.bottle.correct),
    ];

    final WrongData = [
      new ObjectType('Face', data.face.wrong),
      new ObjectType('Phone', data.phone.wrong),
      new ObjectType('Bag', data.bag.wrong),
      new ObjectType('Watch', data.watch.wrong),
      new ObjectType('Bottle', data.bottle.wrong),
    ];

    return [
      new charts.Series<ObjectType, String>(
        id: 'Total',
        domainFn: (ObjectType type, _) => type.name,
        measureFn: (ObjectType type, _) => type.amount,
        data: TotalData,
      ),
      new charts.Series<ObjectType, String>(
        id: 'Right',
        domainFn: (ObjectType type, _) => type.name,
        measureFn: (ObjectType type, _) => type.amount,
        data: RightData,
      ),
      new charts.Series<ObjectType, String>(
        id: 'Wrong',
        domainFn: (ObjectType type, _) => type.name,
        measureFn: (ObjectType type, _) => type.amount,
        data: WrongData,
      ),
    ];
  }
}

/// Sample object type.
class ObjectType {
  final String name;
  final int amount;

  ObjectType(this.name, this.amount);
}