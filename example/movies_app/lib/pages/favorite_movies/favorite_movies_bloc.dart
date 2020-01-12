import 'dart:async';

import 'package:bloc_component/bloc_component.dart';

import '../../models/models.dart';
import '../../services/services.dart';

class FavoriteMoviesState extends BlocState {}

class FavoriteMoviesStateUpdated extends FavoriteMoviesState {
  final List<Movie> movies;

  FavoriteMoviesStateUpdated(this.movies);

  @override
  List<Object> get props => [movies];
}

class FavoriteMoviesEvent extends BlocEvent {}

class FavoriteMoviesEventRefresh extends FavoriteMoviesEvent {}

class FavoriteMoviesBloc
    extends BaseBloc<FavoriteMoviesEvent, FavoriteMoviesState> {
  final MoviesServices _moviesServices;
  StreamSubscription _favoriteMoviesUpdatedSubscription;

  FavoriteMoviesBloc(this._moviesServices);

  @override
  Stream<FavoriteMoviesState> eventToState(FavoriteMoviesEvent event) async* {
    if (event is FavoriteMoviesEventRefresh) {
      yield* _notifyFavoriteMoviesUpdated();
    }
  }

  @override
  Stream<StateInitializing> initialize() async* {
    await _moviesServices.initialized;
    _favoriteMoviesUpdatedSubscription = _moviesServices
        .favoriteMoviesUpdateStream
        .listen((_) => event(FavoriteMoviesEventRefresh()));
  }

  Stream<FavoriteMoviesStateUpdated> _notifyFavoriteMoviesUpdated() async* {
    yield FavoriteMoviesStateUpdated(_moviesServices.getFavoriteMovies());
  }

  @override
  Stream<FavoriteMoviesState> onInitialized() async* {
    yield* _notifyFavoriteMoviesUpdated();
  }

  @override
  Future<void> close() async {
    super.close();
    _favoriteMoviesUpdatedSubscription.cancel();
  }
}
