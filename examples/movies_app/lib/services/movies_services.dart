import 'package:rxdart/rxdart.dart';

import '../models/models.dart';
import '../repositories/repositories.dart';
import 'base_service.dart';

class MoviesServices extends BaseService {
  final MoviesRepository _repository;
  final PublishSubject<List<Movie>> _favoriteMoviesUpdateSubject =
      PublishSubject();

  List<Movie> _movies;
  List<Movie> _favoriteMovies;

  MoviesServices(this._repository);

  Stream<List<Movie>> get favoriteMoviesUpdateStream =>
      _favoriteMoviesUpdateSubject.stream;

  @override
  Future<void> initialize() async {
    _movies = await _repository.fetchMovies();
    _favoriteMovies = [];
  }

  List<Movie> getAllMovies() {
    return List.unmodifiable(_movies);
  }

  List<Movie> getFavoriteMovies() {
    return List.unmodifiable(_favoriteMovies);
  }

  Future<void> addFavoriteMovie(Movie movie) async {
    await Future.delayed(Duration(milliseconds: 500));
    _favoriteMovies.add(movie);
    _favoriteMoviesUpdateSubject.sink.add(_favoriteMovies);
  }

  Future<void> removeFavoriteMovie(Movie movie) async {
    await Future.delayed(Duration(milliseconds: 500));
    _favoriteMovies.remove(movie);
    _favoriteMoviesUpdateSubject.sink.add(_favoriteMovies);
  }

  bool isFavorite(Movie movie) {
    return _favoriteMovies.contains(movie);
  }

  @override
  void dispose() {
    _favoriteMoviesUpdateSubject.close();
  }
}
