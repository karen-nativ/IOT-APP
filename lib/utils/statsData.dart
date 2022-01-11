import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:face_recognition/api/firebase_api.dart';
import 'package:flutter/cupertino.dart';
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
      case 'Phone': {
        phone.totalTimes++;
      } break;
      case 'Bag': {
        bag.totalTimes++;
      } break;
      case 'Watch': {
        watch.totalTimes++;
      } break;
      case 'Face': {
        face.totalTimes++;
      } break;
      case 'Bottle': {
        bottle.totalTimes++;
      } break;
    }
    uploadFile();
  }

  void updateCorrectStatistics(String result)
  {
    switch(result) {
      case 'Phone': {
        phone.correct++;
      } break;
      case 'Bag': {
        bag.correct++;
      } break;
      case 'Watch': {
        watch.correct++;
      } break;
      case 'Face': {
        face.correct++;
      } break;
      case 'Bottle': {
        bottle.correct++;
      } break;
    }
    uploadFile();
  }

  void updateWrongStatistics(String result)
  {
    switch(result) {
      case 'Phone': {
        phone.wrong++;
      } break;
      case 'Bag': {
        bag.wrong++;
      } break;
      case 'Watch': {
        watch.wrong++;
      } break;
      case 'Face': {
        face.wrong++;
      } break;
      case 'Bottle': {
        bottle.wrong++;
      } break;
    }
    uploadFile();
  }

  void uploadFile() async
  {
    final directory = await getExternalStorageDirectory();
    String? path = directory?.path;
    String json_contents = dataToJson(this);
    final file = File('$path/stats.json');
    file.writeAsString(json_contents);
    await firebase_storage.FirebaseStorage.instance
        .ref('logs/stats.json')
        .putFile(file);
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