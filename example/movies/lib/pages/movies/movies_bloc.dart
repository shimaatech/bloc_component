
import 'package:bloc_component/bloc_component.dart';

import '../../models/models.dart';
import '../../services/services.dart';

class MoviesState extends BlocState {}

class MoviesStateFiltered extends MoviesState {
  final MovieGenre genre;
  final List<Movie> movies;

  MoviesStateFiltered(this.genre, this.movies);

  @override
  List<Object> get props => [genre, movies];
}

class MoviesEvent extends BlocEvent {}

class MoviesEventFilter extends MoviesEvent {
  final MovieGenre genre;

  MoviesEventFilter(this.genre);

  @override
  List<Object> get props => [genre];
}

class MoviesBloc extends BaseBloc {

  final MoviesServices _moviesServices;
  MoviesBloc(this._moviesServices);

  @override
  Stream<StateInitializing> initialize() async* {
    await _moviesServices.initialized;

    // just mimic some long initialization...
    for (int i=1; i<10; i++) {
      yield StateInitializing(i*0.1);
      await Future.delayed(Duration(milliseconds: 200));
    }

    yield StateInitializing(1.0);
  }

  @override
  Stream<MoviesState> eventToState(BlocEvent event) async* {
    if (event is MoviesEventFilter) {
      yield* _filterMovies(event.genre);
    }
  }

  Stream<MoviesStateFiltered> _filterMovies(MovieGenre genre) async* {

    List<Movie> filteredMovies = _moviesServices.getAllMovies()
        .where((movie) => movie.genre == genre)
        .toList();

    yield MoviesStateFiltered(genre, filteredMovies);
  }

}
