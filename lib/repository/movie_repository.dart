import 'dart:convert';

import 'package:http/http.dart';
import 'package:movielib/model/movie_actor.dart';
import 'package:movielib/model/movie_genre.dart';
import 'package:movielib/model/movie_model.dart';
import 'package:movielib/model/movie_response.dart';
import 'package:movielib/model/movie_trailer_model.dart';
import 'package:movielib/services/movie_auth_service.dart';

class MovieRepository implements MovieService {
  Client client = Client();
  final baseUrl = 'https://api.themoviedb.org/3/';
  final apiKey = '7fa1acc57078f55722ada3185ba7c265';
  final language = '&language=tr-TR';

  @override
  Future<MovieResponse> fetchMovieList(bool isPopular, {int page = 1}) async {
    final type = isPopular ? 'movie/popular' : 'movie/now_playing';
    final response = await client.get(
      Uri.parse(
        baseUrl + type + '?api_key=' + apiKey + language + '&page=$page',
      ),
    );
    if (response.statusCode == 200) {
      return MovieResponse.fromMap(jsonDecode(response.body), !isPopular);
    } else {
      throw Exception('Filed to load posts');
    }
  }

  @override
  Future<GenresModel> fetchGenreList() async {
    final response =
        await client.get(Uri.parse('${baseUrl}genre/movie/list$apiKey'));
    if (response.statusCode == 200) {
      return GenresModel.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Filed to load genres');
    }
  }

  @override
  Future<Movie> fetchMovie(int id) async {
    final response = await client
        .get(Uri.parse('${baseUrl}movie/$id?api_key=$apiKey$language'));
    if (response.statusCode == 200) {
      return movieFromMap(response.body);
    } else {
      throw Exception('Filed to load post');
    }
  }

  @override
  Future<MovieResponse> searchMovie(String query) async {
    final path =
        '${baseUrl}search/multi?api_key=$apiKey&query=$query&include_adult=true$language';
    final res = await client.get(Uri.parse(path));
    if (res.statusCode == 200) {
      return MovieResponse.fromMap(jsonDecode(res.body), false);
    } else {
      throw Exception('Filed to load search');
    }
  }

  @override
  Future<TrailersModel> fetchMovieTrailers(int id) async {
    final response = await client.get(
      Uri.parse(
        ('${baseUrl}movie/$id/videos?api_key=$apiKey&language=en-EN'),
      ),
    );
    if (response.statusCode == 200) {
      return trailersModelFromMap(response.body);
    } else {
      throw Exception('Filed to load trailers');
    }
  }

  @override
  Future<ActorsModel> fetchActors(int id) async {
    final response = await client.get(
      Uri.parse('${baseUrl}movie/$id/credits?api_key=$apiKey$language'),
    );
    if (response.statusCode == 200) {
      return actorFromJson(response.body);
    } else {
      throw Exception('Filed to load Actors');
    }
  }
}
