import 'dart:convert';

import 'package:face_recognition/api/firebase_api.dart';
import 'package:face_recognition/api/firebase_file.dart';
import 'package:face_recognition/utils/statsData.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


class StatisticsPage extends StatefulWidget {
   StatisticsPage({Key? key}) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>{

  late Future<List<FirebaseFile>> futureFiles;

  late FirebaseFile statisticsFile;

  String json_content = "!";

  late Data objects;

  @override
  void initState() {
    super.initState();

    futureFiles = FirebaseApi.listAll('statistics/');
  }


  Future<void> downloadData() async {
    await FirebaseApi.downloadFile(statisticsFile.ref);
    final directory = await getExternalStorageDirectory();
    String? path = directory?.path;
    final file = File('$path/stats.json');
    final contents = await file.readAsString();
    setState(() => json_content = contents);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<FirebaseFile>>(
          future: futureFiles,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Center(child: Text('Some error occurred!'));
                } else {
                  final files = snapshot.data!;
                  statisticsFile = files[0];
                  downloadData();
                  objects = dataFromJson(json_content);
                  int bot = objects.bottle.totalTimes;
                  return Scaffold(
                    body: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Total things recognized: \n"),
                                Text("Bottles recognized: $bot \n"),
                                Text("Faces recognized: \n"),
                                Text("Total accuracy: \n"),
                              ]
                          ),
                          const Text("Graph here"),
                        ],
                      ),
                    ),
                  );
                }
            }
          }
      )
  );
  }

  /*void updateStatistics(String result)
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
  }*/

}

