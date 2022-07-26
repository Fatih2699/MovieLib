import 'dart:convert';

import 'movie_genre.dart';

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
    this.detailGenre,
  });
  String? backdropPath;
  List<String>? genres;
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
  List<Genre>? detailGenre;
  List<String> get genreTitles {
    return getGenreTitles(genreId);
  }

  List<String> get genreDetailTitles {
    List<String> g = [];
    if (detailGenre != null) {
      for (var i = 0; i < detailGenre!.length; i++) {
        Genre genre = detailGenre![i];
        g.add(genre.name);
        if (i == 2) {
          break;
        }
      }
    }
    return g;
  }

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

  static List<String> getGenreTitles(List<int>? ids) {
    List<String> movieGenre = [];
    Map<int, String> _genres = {
      28: "Aksiyon",
      12: "Macera",
      16: "Animasyon",
      35: "Komedi",
      80: "Suç",
      99: "Belgesel",
      18: "Dram",
      10751: "Aile",
      14: "Fantastik",
      36: "Tarih",
      27: "Korku",
      10402: "Müzik",
      9648: "Gizem",
      10749: "Romantik",
      878: "Bilim-Kurgu",
      10770: "TV film",
      53: "Gerilim",
      10752: "Savaş",
      37: "Vahşi Batı"
    };
    if (ids != null) {
      for (var id in ids) {
        if (_genres[id] != null) {
          movieGenre.add(_genres[id]!);
        }
      }
    }
    return movieGenre;
  }

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
    detailGenre = json["genres"] != null
        ? List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x)))
        : null;
  }

  factory Movie.fromMap(Map<String, dynamic> json) => Movie(
      backdropPath: _getBackdrop(json['backdrop_path']),
      genres: getGenreTitles(json["genre_ids"] ?? []),
      id: json["id"] ?? '',
      imdbId: json["imdb_id"] ?? '',
      overView: json["overview"] ?? '',
      popularity: json["popularity"].toDouble() ?? 0,
      posterPath: json["poster_path"],
      releaseDate: _getReleaseTime(json['release_date']),
      title: json["title"] ?? 'Başlık Yok',
      video: json["video"] ?? false,
      voteCount: json["vote_count"] ?? 0,
      genreId: json["genre_ids"] ?? [],
      voteAverage: json["vote_average"] ?? 0,
      detailGenre: json["genres"] != null
          ? List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x)))
          : null);

  Map<String, dynamic> toMap() => {
        "backdrop_path": backdropPath,
        "genres": genres,
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
      genres: getGenreTitles(json["genre_ids"] ?? []),
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
      genreId: json["genre_ids"] ?? [],
      voteAverage: json["vote_average"]);
  Map<String, dynamic> toMapSqf() => {
        "backdrop_path": backdropPath,
        "genres": genres ?? [],
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
