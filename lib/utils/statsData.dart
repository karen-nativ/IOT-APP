import 'dart:convert';
import 'dart:io';

import 'package:face_recognition/api/firebase_api.dart';
import 'package:face_recognition/api/firebase_file.dart';
import 'package:path_provider/path_provider.dart';

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    required this.bottle,
    required this.bag,
    required this.phone,
    required this.watch,
    required this.face,
  });

  ObjectResults bottle;
  ObjectResults bag;
  ObjectResults phone;
  ObjectResults watch;
  ObjectResults face;

  late Future<List<FirebaseFile>> futureFiles;

  late FirebaseFile statisticsFile;

  String json_content = "!";

  Data createInstance() {
    statisticsFile = downloadData()
  }

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    bottle: ObjectResults.fromJson(json["bottle"]),
    bag: ObjectResults.fromJson(json["bag"]),
    phone: ObjectResults.fromJson(json["phone"]),
    watch: ObjectResults.fromJson(json["watch"]),
    face: ObjectResults.fromJson(json["face"]),
  );

  Map<String, dynamic> toJson() => {
    "bottle": bottle.toJson(),
    "bag": bag.toJson(),
    "phone": phone.toJson(),
    "watch": watch.toJson(),
    "face": face.toJson(),
  };

  Future<void> downloadData() async {
    await FirebaseApi.downloadFile(statisticsFile.ref);
    final directory = await getExternalStorageDirectory();
    String? path = directory?.path;
    final file = File('$path/stats.json');
    final contents = await file.readAsString();
    json_content = contents;
  }

  num getTotal()
  {
    return (watch.totalTimes + face.totalTimes + bag.totalTimes + phone.totalTimes + bottle.totalTimes);
  }

  num getTotalAccu()
  {
    num total = getTotal();
    if(total == 0)
      {
        return 0;
      }
    int totalWrong = (watch.wrong + face.wrong + bag.wrong + phone.wrong + bottle.wrong);
    return (1-totalWrong/total)*100;
  }

  void updateStatistics(String result)
  {
    switch(result) {
      case 'phone': {
        phone.totalTimes++;
      } break;
      case 'bag': {
        bag.totalTimes++;
      } break;
      case 'watch': {
        watch.totalTimes++;
      } break;
      case 'face': {
        face.totalTimes++;
      } break;
      case 'bottle': {
        bottle.totalTimes++;
      } break;
    }
  }
}


class ObjectResults {
  ObjectResults({
    required this.totalTimes,
    required this.correct,
    required this.wrong,
  });

  int totalTimes;
  int correct;
  int wrong;

  factory ObjectResults.fromJson(Map<String, dynamic> data)
  {
    final totals = data['total'] as int;
    final corrects = data['right'] as int;
    final wrongs = data['wrong'] as int;

    return ObjectResults(
      totalTimes : totals,
      correct : corrects,
      wrong : wrongs,
    );

  }

  Map<String, dynamic> toJson() => {
    "total": totalTimes,
    "right": correct,
    "wrong": wrong,
  };

  num getAcc()
  {
    if(totalTimes == 0)
    {
      return 0;
    }

    return (1-wrong/totalTimes)*100;
  }
}