import 'dart:io';

import 'package:face_recognition/screens/sign_in_screen.dart';
import 'package:face_recognition/screens/statistics_screen.dart';
import 'package:face_recognition/utils/statsData.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'api/firebase_api.dart';
import 'api/firebase_file.dart';




void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SecuRecognize', //Tab text
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: SignInScreen()
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _result = '';

  bool clicked_classify = false;
  bool clicked_mood = false;

  late Future<List<FirebaseFile>> futureList;

  late FirebaseFile futureResult;

  late FirebaseFile futureStats;

  String json_content = "!";

  late Data objects;

  @override
  void initState() {
    super.initState();

    futureList = FirebaseApi.listAll('logs/');
  }

  void _classify(String contents) {
    setState(() {
      _result = contents;
      objects.updateStatistics(contents);
    });
  }

  Future<String> downloadData() async {
    await FirebaseApi.downloadFile(futureResult.ref);
    await FirebaseApi.downloadFile(futureStats.ref);
    final directory = await getExternalStorageDirectory();
    String? path = directory?.path;
    final resultsFile = File('$path/result.txt');
    final statsFile = File('$path/stats.json');
    final contents = await resultsFile.readAsString();
    final jsonContent = await statsFile.readAsString();
    setState(() => json_content = jsonContent);
    return contents;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: FutureBuilder<List<FirebaseFile>>(
          future: futureList,
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
                  futureResult = files[0];
                  futureStats = files[1];
                  return Scaffold(
                    body: Center(
                    // Center is a layout widget. It takes a single child and positions it
                    // in the middle of the parent.
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            _result,
                            style: Theme
                                .of(context)
                                .textTheme
                                .headline4,
                          ),
                          if(clicked_classify && !clicked_mood) ... [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FloatingActionButton(
                                  tooltip: 'Correct!',
                                  onPressed: () {
                                    clicked_mood = true;
                                    setState(() {});
                                  },
                                  child: const Icon(Icons.mood),
                                ),
                                FloatingActionButton(
                                  tooltip: 'False!',
                                  onPressed: () {
                                    clicked_mood = true;
                                    setState(() {});
                                  },
                                  child: const Icon(Icons.mood_bad),
                                ),
                              ],
                            ),
                            Text('Click here to classify again:'),
                        ]
                        else if(clicked_classify) ... [
                            Text('Click here to classify again:'),
                        ]
                        else
                          Text('Click here to classify:'),
                        ],
                      ),
                    ),
                    floatingActionButton: FloatingActionButton(
                      tooltip: 'Classify picture',
                      child: const Icon(Icons.photo_camera),
                      onPressed: () async {
                        String content = await downloadData();
                        objects = dataFromJson(json_content);
                        _classify(content);
                        clicked_classify = true;
                        clicked_mood = false;
                      }
                    ),
                    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                  );
                }
            }
          },
        ),
      );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("SecuRecognize app was developed by Ofir Sagi, Karen Nativ and Romi Levy for TFLite Micro project as part of the IOT project 236333"),
              Text(""),
              Text("version: 1.0"),
            ],
          ),
      ),
    );
  }

}


class MyDrawer extends StatefulWidget {

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  Widget mainWidget = const HomePage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('SecuRecognize'), //App bar text
        actions: <Widget>[
          Image.asset('assets/app_logo.png',fit: BoxFit.contain,height: 32,),
            ],
      ),
      drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    // What happens after you tap the navigation item
                    setState(() {
                      mainWidget = const HomePage();
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.insert_chart_outlined),
                  title: const Text('Statistics'),
                  onTap: () {
                    // What happens after you tap the navigation item
                    setState(() {
                      mainWidget = StatisticsPage();
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.book),
                  title: const Text('About'),
                  onTap: () {
                    // What happens after you tap the navigation item
                    setState(() {
                      mainWidget = AboutPage();
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        body: mainWidget,
    );
  }
}