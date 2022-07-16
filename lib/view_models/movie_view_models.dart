import 'package:flutter/material.dart';
import 'package:movielib/locator.dart';
import 'package:movielib/model/movie_actor.dart';
import 'package:movielib/model/movie_genre.dart';
import 'package:movielib/model/movie_model.dart';
import 'package:movielib/model/movie_response.dart';
import 'package:movielib/model/movie_trailer_model.dart';
import 'package:movielib/repository/movie_repository.dart';
import 'package:movielib/services/movie_auth_service.dart';

class MovieViewModel with ChangeNotifier implements MovieService {
  final MovieRepository _movieRepository = locator<MovieRepository>();

  @override
  Future<GenresModel> fetchGenreList() async {
    try {
      var result = await _movieRepository.fetchGenreList();
      return result;
    } catch (e) {
      debugPrint('HATA VAR fetchGenreList: ' + e.toString());
      return GenresModel(genres: []);
    }
  }

  @override
  Future<Movie> fetchMovie(int id) async {
    try {
      var result = await _movieRepository.fetchMovie(id);
      return result;
    } catch (e) {
      debugPrint('HATA VAR fetchMovie: ' + e.toString());
      return Movie(
          backdropPath: null,
          genres: null,
          id: null,
          imdbId: null,
          title: null,
          overView: null,
          popularity: null,
          posterPath: null,
          releaseDate: null,
          video: null,
          voteCount: null,
          voteAverage: null,
          genreId: null);
    }
  }

  @override
  Future<MovieResponse> fetchMovieList(bool isPopular) async {
    try {
      var result = await _movieRepository.fetchMovieList(isPopular);
      return result;
    } catch (e) {
      debugPrint('HATA VAR fetchMovieList: ' + e.toString());
      return MovieResponse(
          page: null, results: null, totalPages: null, totalResults: null);
    }
  }

  @override
  Future<MovieResponse> searchMovie(String query) async {
    try {
      var result = await _movieRepository.searchMovie(query);
      return result;
    } catch (e) {
      debugPrint('HATA VAR searchMovies: ' + e.toString());
      return MovieResponse(
          page: null, results: null, totalPages: null, totalResults: null);
    }
  }

  @override
  Future<TrailersModel> fetchMovieTrailers(int id) async {
    try {
      var result = await _movieRepository.fetchMovieTrailers(id);
      return result;
    } catch (e) {
      debugPrint('HATA VAR searchTrailer: ' + e.toString());
      return TrailersModel(id: 0, results: []);
    }
  }

  @override
  Future<ActorsModel> fetchActors(int id) async {
    try {
      var result = await _movieRepository.fetchActors(id);
      return result;
    } catch (e) {
      debugPrint('HATA VAR actors: ${e.toString()}');
    }
    return ActorsModel(
      id: 0,
      cast: [],
      crew: [],
    );
  }
}
