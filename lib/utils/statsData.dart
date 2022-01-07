import 'dart:convert';

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
}


class ObjectResults {
  ObjectResults({
    required this.totalTimes,
    required this.correct,
    required this.wrong,
  });

  final int totalTimes;
  final int correct;
  final int wrong;

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
}