import 'package:movielib/model/movie_actor.dart';
import 'package:movielib/model/movie_genre.dart';
import 'package:movielib/model/movie_model.dart';
import 'package:movielib/model/movie_response.dart';
import 'package:movielib/model/movie_trailer_model.dart';

abstract class MovieService {
  Future<MovieResponse> fetchMovieList(bool isPopular);
  Future<Movie> fetchMovie(int id);
  Future<GenresModel> fetchGenreList();
  Future<MovieResponse> searchMovie(String query);
  Future<TrailersModel> fetchMovieTrailers(int id);
  Future<ActorsModel> fetchActors(int id);
}
