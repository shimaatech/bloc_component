import 'dart:async';

import 'package:bloc_component/bloc_component.dart';

import '../../../models/models.dart';
import '../../../services/services.dart';

class MovieItemState extends BlocState {}

class StateFavoriteUpdated extends MovieItemState {
  final bool isFavorite;

  StateFavoriteUpdated(this.isFavorite);

  @override
  List<Object> get props => [isFavorite];
}

class MovieItemEvent extends BlocEvent {}

class EventRefreshFavorite extends MovieItemEvent {}

class EventToggleFavorite extends MovieItemEvent {}

class MovieItemBloc extends BaseBloc {
  final MoviesServices _moviesServices;
  final Movie movie;

  StreamSubscription<List<Movie>> _favoriteItemsUpdatedSubscription;

  MovieItemBloc(this._moviesServices, this.movie)
      : assert(_moviesServices.isInitialized) {

    _favoriteItemsUpdatedSubscription = _moviesServices
        .favoriteMoviesUpdateStream
        .listen((_) => add(EventRefreshFavorite()));

    add(EventRefreshFavorite());
  }

  @override
  BlocState get initialState =>
      StateFavoriteUpdated(_moviesServices.isFavorite(movie));

  @override
  Stream<BlocState> eventToState(BlocEvent event) async* {
    if (event is EventToggleFavorite) {
      yield* _toggleFavorite();
    } else if (event is EventRefreshFavorite) {
      yield* _notifyFavoriteUpdated();
    }
  }

  Stream<BlocState> _toggleFavorite() async* {
    yield StateLoading();
    if (_moviesServices.isFavorite(movie)) {
      await _moviesServices.removeFavoriteMovie(movie);
    } else {
      await _moviesServices.addFavoriteMovie(movie);
    }
    yield* _notifyFavoriteUpdated();
  }

  Stream<BlocState> _notifyFavoriteUpdated() async* {
    yield StateFavoriteUpdated(_moviesServices.isFavorite(movie));
  }

  @override
  Future<void> close() async {
    super.close();
    _favoriteItemsUpdatedSubscription.cancel();
  }
}
