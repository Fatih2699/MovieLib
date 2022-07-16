import 'dart:convert';

import 'package:movielib/constants/app_constants.dart';

ActorsModel actorFromJson(String str) => ActorsModel.fromJson(json.decode(str));

String actorToJson(ActorsModel data) => json.encode(data.toJson());

class ActorsModel {
  ActorsModel({
    required this.id,
    required this.cast,
    required this.crew,
  });

  int id;
  List<Cast> cast;
  List<Cast> crew;

  factory ActorsModel.fromJson(Map<String, dynamic> json) => ActorsModel(
        id: json["id"],
        cast: List<Cast>.from(json["cast"].map((x) => Cast.fromJson(x))),
        crew: List<Cast>.from(json["crew"].map((x) => Cast.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cast": List<dynamic>.from(cast.map((x) => x.toJson())),
        "crew": List<dynamic>.from(crew.map((x) => x.toJson())),
      };
}

class Cast {
  Cast({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    required this.originalName,
    required this.popularity,
    required this.profilePath,
    required this.castId,
    required this.character,
    required this.creditId,
    required this.order,
    required this.department,
    required this.job,
  });

  bool adult;
  int gender;
  int id;
  String knownForDepartment;
  String name;
  String originalName;
  double popularity;
  String profilePath;
  int castId;
  String character;
  String creditId;
  int order;
  String department;
  String job;

  String get getProfilePath {
    if (profilePath.startsWith('https')) {
      return profilePath;
    } else {
      return ApplicationConstants.poster + profilePath;
    }
  }

  factory Cast.fromJson(Map<String, dynamic> json) => Cast(
        adult: json["adult"] ?? false,
        gender: json["gender"] ?? 0,
        id: json["id"] ?? 0,
        knownForDepartment: json["known_for_department"] ?? '',
        name: json["name"] ?? '',
        originalName: json["original_name"] ?? '',
        popularity: json["popularity"].toDouble() ?? 0,
        profilePath: json["profile_path"] ??
            'https://cdn-icons-png.flaticon.com/512/2433/2433246.png',
        castId: json["cast_id"] ?? 0,
        character: json["character"] ?? '',
        creditId: json["credit_id"] ?? '',
        order: json["order"] ?? 0,
        department: json["department"] ?? '',
        job: json["job"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "gender": gender,
        "id": id,
        "known_for_department": knownForDepartment,
        "name": name,
        "original_name": originalName,
        "popularity": popularity,
        "profile_path": profilePath,
        "cast_id": castId,
        "character": character,
        "credit_id": creditId,
        "order": order,
        "department": department,
        "job": job,
      };
}
