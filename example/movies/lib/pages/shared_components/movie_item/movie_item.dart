import 'package:bloc_component/bloc_component.dart';
import 'package:flutter/material.dart';

import '../../../app_conetxt/app_context.dart';
import '../../../models/models.dart';
import '../../../services/services.dart';
import 'movie_item_bloc.dart';

class MovieItem extends Component<MovieItemBloc> {
  final Movie movie;

  // Use different key for each movie item so that a new component and bloc
  // will be created for each movie.
  MovieItem(this.movie) : super(key: ObjectKey(movie));

  @override
  MovieItemBloc createBloc(BuildContext context) {
    return MovieItemBloc(AppContext.locate<MoviesServices>(), movie);
  }

  @override
  ComponentView<MovieItemBloc> createView(MovieItemBloc bloc) {
    return MovieItemView(bloc);
  }
}

class MovieItemView extends ComponentView<MovieItemBloc> {
  MovieItemView(MovieItemBloc bloc) : super(bloc);

  @override
  Widget buildView(BuildContext context) {
    final Movie movie = bloc.movie;
    return ListTile(
      leading: Image.network(movie.imageUrl),
      title: Text(movie.title),
      subtitle: Text(movie.year.toString()),
      trailing: _buildFavoriteIcon(),
    );
  }

  Widget _buildFavoriteIcon() {
    return stateBuilder<StateFavoriteUpdated>(
        onLoading: (context, loadingState) => CircularProgressIndicator(),
        builder: (context, state) {
          return GestureDetector(
            child: Icon(state.isFavorite ? Icons.star : Icons.star_border),
            onTap: () => bloc.add(EventToggleFavorite()),
          );
        });
  }
}
