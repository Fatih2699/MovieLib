import 'dart:convert';

import 'package:movielib/model/movie_genre.dart';

Movie movieFromMap(String str) => Movie.fromMap(json.decode(str));

Map<String, dynamic> movieToMapSqf(Movie data) => {
      'id': data.id,
      'movie': json.encode(data.toMap()),
    };

class Movie {
  Movie({
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.imdbId,
    required this.title,
    required this.overView,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.video,
    required this.voteCount,
    required this.genreId,
    required this.voteAverage,
  });
  String? backdropPath;
  List<Genre>? genres;
  int? id;
  String? imdbId;
  String? title;
  String? overView;
  num? popularity;
  String? posterPath;
  DateTime? releaseDate;
  bool? video;
  int? voteCount;
  num? voteAverage;
  List<int>? genreId;

  String get poster => posterPath != null
      ? 'https://image.tmdb.org/t/p/w185' + posterPath!
      : 'https://upload.wikimedia.org/wikipedia/commons/f/fc/No_picture_available.png';
  String get backdrop => 'https://image.tmdb.org/t/p/w185' + backdropPath!;

  String get date =>
      '${releaseDate!.month}-${releaseDate!.day}-${releaseDate!.year}';

  static DateTime _getReleaseTime(String? date) {
    try {
      return DateTime.parse(date!);
    } catch (_) {
      return DateTime.now();
    }
  }

  static List<int> _getGenres(dynamic intList) {
    try {
      return List<int>.from(intList.map((x) => x));
    } catch (_) {
      return [];
    }
  }

  // static String _getGenreTitles(List<int> ids) {
  //   String titles = "";
  //
  //   var _genres = [
  //     {
  //       "id": 28,
  //       "name": "Aksiyon"
  //     },
  //     {
  //       "id": 12,
  //       "name": "Macera"
  //     },
  //     {
  //       "id": 16,
  //       "name": "Animasyon"
  //     },
  //     {
  //       "id": 35,
  //       "name": "Komedi"
  //     },
  //     {
  //       "id": 80,
  //       "name": "Suç"
  //     },
  //     {
  //       "id": 99,
  //       "name": "Belgesel"
  //     },
  //     {
  //       "id": 18,
  //       "name": "Dram"
  //     },
  //     {
  //       "id": 10751,
  //       "name": "Aile"
  //     },
  //     {
  //       "id": 14,
  //       "name": "Fantastik"
  //     },
  //     {
  //       "id": 36,
  //       "name": "Tarih"
  //     },
  //     {
  //       "id": 27,
  //       "name": "Korku"
  //     },
  //     {
  //       "id": 10402,
  //       "name": "Müzik"
  //     },
  //     {
  //       "id": 9648,
  //       "name": "Gizem"
  //     },
  //     {
  //       "id": 10749,
  //       "name": "Romantik"
  //     },
  //     {
  //       "id": 878,
  //       "name": "Bilim-Kurgu"
  //     },
  //     {
  //       "id": 10770,
  //       "name": "TV film"
  //     },
  //     {
  //       "id": 53,
  //       "name": "Gerilim"
  //     },
  //     {
  //       "id": 10752,
  //       "name": "Savaş"
  //     },
  //     {
  //       "id": 37,
  //       "name": "Vahşi Batı"
  //     }
  //   ];
  //   ids.map((id) =>
  //     _genres.
  //   );
  // }

  static String _getBackdrop(String? path) {
    if (path == null) {
      return 'https://upload.wikimedia.org/wikipedia/commons/f/fc/No_picture_available.png';
    } else {
      return path;
    }
  }

  Movie.fromMapForList(Map<String, dynamic> json) {
    backdropPath = _getBackdrop(json['backdrop_path']);
    genreId = _getGenres(json["genre_ids"]);
    id = json["id"];
    overView = json["overview"] ?? '';
    popularity = json["popularity"] != null ? json["popularity"].toInt() : 0;
    posterPath = json["poster_path"];
    releaseDate = _getReleaseTime(json["release_date"]);
    title = json["title"] ?? 'Başlık Yok';
    video = json["video"];
    voteCount = json["vote_count"] ?? 0;
    voteAverage = json["vote_average"] ?? 0;
  }

  factory Movie.fromMap(Map<String, dynamic> json) => Movie(
        backdropPath: _getBackdrop(json['backdrop_path']) ?? '',
        genres: List<Genre>.from(json["genres"].map((x) => Genre.fromMap(x))),
        id: json["id"] ?? '',
        imdbId: json["imdb_id"] ?? '',
        overView: json["overview"] ?? '',
        popularity: json["popularity"].toDouble() ?? 0,
        posterPath: json["poster_path"],
        releaseDate: _getReleaseTime(json['release_date']),
        title: json["title"] ?? 'Başlık Yok',
        video: json["video"] ?? false,
        voteCount: json["vote_count"] ?? 0,
        genreId: [],
        voteAverage: json["vote_average"] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        "backdrop_path": backdropPath,
        "genres": List<dynamic>.from(genres!.map((x) => x.toMap())),
        "id": id,
        "imdb_id": imdbId,
        "overview": overView,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date":
            "${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate!.day.toString().padLeft(2, '0')}",
        "title": title,
        "video": video,
        "vote_count": voteCount,
        "vote_average": voteAverage,
      };

  factory Movie.fromSqfMap(Map<String, dynamic> json) => Movie(
      genres: List<Genre>.from(json["genres"].map((x) => Genre.fromMap(x))),
      backdropPath: _getBackdrop(json['backdrop_path']),
      id: json["id"],
      overView: json["overview"],
      popularity: json["popularity"],
      posterPath: json["poster_path"],
      releaseDate: DateTime.parse(json["release_date"]),
      title: json["title"] ?? 'Başlık Yok',
      video: json["video"],
      voteCount: json["vote_count"],
      imdbId: '',
      genreId: [],
      voteAverage: json["vote_average"]);
  Map<String, dynamic> toMapSqf() => {
        "backdrop_path": backdropPath,
        "genres": genres != null
            ? List<dynamic>.from(genres!.map((x) => x.toMap()))
            : [],
        "genre_ids": List<dynamic>.from(genreId!.map((x) => x)),
        "id": id,
        "overview": overView,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date":
            "${releaseDate!.year.toString().padLeft(4, '0')}-${releaseDate!.month.toString().padLeft(2, '0')}-${releaseDate!.day.toString().padLeft(2, '0')}",
        "title": title,
        "video": video,
        "vote_count": voteCount,
        "vote_average": voteAverage,
      };
}
