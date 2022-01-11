import 'dart:convert';

import 'package:face_recognition/api/firebase_api.dart';
import 'package:face_recognition/api/firebase_file.dart';
import 'package:face_recognition/utils/statsData.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';


//import 'package:syncfusion_flutter_charts/charts.dart';


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

    futureFiles = FirebaseApi.listAll('logs/');
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
                    files.sort((a, b) => a.name.compareTo(b.name));
                    statisticsFile = files[1];
                    downloadData();
                    if(json_content == "!")
                    {
                      return Center(child: CircularProgressIndicator());
                    }
                    objects = dataFromJson(json_content);
                    return Scaffold(
                      body: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text("Graph here\n"),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Total things recognized: ${objects.getTotal()}\n"),
                                  Text("Total accuracy: ${objects.getTotalAccu()}%\n"),
                                  Text("Bottles recognized: ${objects.bottle.totalTimes} (${objects.bottle.getAcc()}%)\n"),
                                  Text("Faces recognized: ${objects.face.totalTimes} (${objects.face.getAcc()}%)\n"),
                                  Text("Bags recognized: ${objects.bag.totalTimes} (${objects.bag.getAcc()}%)\n"),
                                  Text("Phones recognized: ${objects.phone.totalTimes} (${objects.phone.getAcc()}%)\n"),
                                  Text("Watches recognized: ${objects.watch.totalTimes} (${objects.watch.getAcc()}%)\n"),
                                ]
                            ),
                            FloatingActionButton(
                              tooltip: 'Clear',
                              onPressed: () {
                                objects.clearStatistics();
                                downloadData();
                                objects = dataFromJson(json_content);
                              },
                              child: const Icon(Icons.cleaning_services_rounded),
                            ),
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

}

