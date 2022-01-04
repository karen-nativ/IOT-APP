import 'dart:io';

import 'package:face_recognition/screens/sign_in_screen.dart';
import 'package:face_recognition/screens/statistics_screen.dart';
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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _result = '';

  bool clicked = false;

  late Future<List<FirebaseFile>> futureFiles;

  late FirebaseFile futureFile;

  @override
  void initState() {
    super.initState();

    futureFiles = FirebaseApi.listAll('logs/');
  }

  void _classify(String contents) {
    setState(() {
      _result = contents;
    });
  }

  Future<String> downloadData() async {
    await FirebaseApi.downloadFile(futureFile.ref);
    final directory = await getExternalStorageDirectory();
    String? path = directory?.path;
    final file = File('$path/myFile.txt');
    final contents = await file.readAsString();
    return contents;
  }

  @override
  Widget build(BuildContext context){
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
                  futureFile = files[0];
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
                          clicked ? Text('Click here to classify again:') : Text('Click here to classify:'),
                        ],
                      ),
                    ),
                    floatingActionButton: FloatingActionButton(
                      tooltip: 'Classify picture',
                      child: const Icon(Icons.photo_camera),
                      onPressed: () async {
                        String content = await downloadData();
                        _classify(content);
                        //updateStatistics(contents);
                        clicked = true;
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