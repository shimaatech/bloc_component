import 'dart:async';

import 'package:bloc_component/bloc_component.dart';

import '../../../models/models.dart';
import '../../../services/services.dart';


class MovieItemState extends BlocState {}

class MovieItemStateUpdatingFavorite extends MovieItemState with StateLoading {}

class MovieItemStateFavoriteUpdated extends MovieItemState {
  final bool isFavorite;

  MovieItemStateFavoriteUpdated(this.isFavorite);

  @override
  List<Object> get props => [isFavorite];
}

class MovieItemEvent extends BlocEvent {}

class MovieItemEventRefreshFavorite extends MovieItemEvent {}

class MovieItemEventToggleFavorite extends MovieItemEvent {}

class MovieItemBloc extends BaseBloc<MovieItemEvent, MovieItemState> {
  final MoviesServices _moviesServices;
  final Movie movie;

  StreamSubscription<List<Movie>> _favoriteItemsUpdatedSubscription;

  MovieItemBloc(this._moviesServices, this.movie);

  @override
  Stream<MovieItemState> eventToState(MovieItemEvent event) async* {
    if (event is MovieItemEventToggleFavorite) {
      yield* _toggleFavorite();
    } else if (event is MovieItemEventRefreshFavorite) {
      yield* _notifyFavoriteUpdated();
    }
  }

  @override
  Stream<MovieItemState> onInitialized() async* {
    yield* _notifyFavoriteUpdated();
  }

  @override
  Stream<StateInitializing> initialize() async* {
    await _moviesServices.initialized;
    _favoriteItemsUpdatedSubscription = _moviesServices.favoriteMoviesUpdateStream
        .listen((_) => event(MovieItemEventRefreshFavorite()));
  }

  Stream<MovieItemState> _toggleFavorite() async* {
    yield MovieItemStateUpdatingFavorite();
    if (_moviesServices.isFavorite(movie)) {
      await _moviesServices.removeFavoriteMovie(movie);
    } else {
      await _moviesServices.addFavoriteMovie(movie);
    }
    yield* _notifyFavoriteUpdated();
  }

  Stream<MovieItemStateFavoriteUpdated> _notifyFavoriteUpdated() async* {
    yield MovieItemStateFavoriteUpdated(_moviesServices.isFavorite(movie));
  }


  @override
  Future<void> close() async {
    super.close();
    _favoriteItemsUpdatedSubscription.cancel();
  }

}
