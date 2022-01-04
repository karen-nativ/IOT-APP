import 'package:flutter/material.dart';

enum Objects {phone, face, watch, }

class ObjectResults {
  int totalTimes = 0;
  int correct = 0;
  int wrong = 0;
  int accuracy = 0;
}



class StatisticsPage extends StatefulWidget {
   StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>{

  late ObjectResults phones;
  late ObjectResults faces;
  late ObjectResults watches;
  late ObjectResults bottles;
  late ObjectResults bags;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text("Total things recognized: \n"),
                    Text("Bottles recognized: \n"),
                    Text("Faces recognized: \n"),
                    Text("Total accuracy: \n"),
                  ]
              ),
              const Text("Graph here"),
            ],
          ),
        )
    );
  }

  void updateStatistics(String result)
  {
    switch(result) {
      case 'phone': {
        phones.totalTimes++;
      } break;
      case 'bag': {
        bags.totalTimes++;
      } break;
      case 'watch': {
        watches.totalTimes++;
      } break;
      case 'face': {
        faces.totalTimes++;
      } break;
      case 'bottle': {
        bottles.totalTimes++;
      } break;
    }
  }
}

