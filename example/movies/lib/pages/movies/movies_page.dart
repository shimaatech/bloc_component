import 'package:bloc_component/bloc_component.dart';
import 'package:flutter/material.dart';

import '../../app_conetxt/app_context.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import '../base_page.dart';
import '../shared_components/shared_components.dart';
import 'movies_bloc.dart';


class MoviesPage extends Component<MoviesBloc> {
  @override
  ComponentView<MoviesBloc> createView(bloc) => MoviesView(bloc);

  @override
  MoviesBloc createBloc(BuildContext context) {
    return MoviesBloc(AppContext.locate<MoviesServices>())
      ..add(MoviesEventFilter(MovieGenre.thriller));
    }
}

class MoviesView extends BasePageView<MoviesBloc> {

  MoviesView(MoviesBloc bloc) : super(bloc);

  Widget _buildGenreSelector(BuildContext context, MovieGenre genre) {
    return DropdownButton<MovieGenre>(
      value: genre,
      onChanged: (genre) => bloc.add(MoviesEventFilter(genre)),
      items: MovieGenre.values
          .map(
            (genre) =>
            DropdownMenuItem<MovieGenre>(
              value: genre,
              child: Text(
                genreToString(genre),
              ),
            ),
      ).toList(),
    );
  }

  Widget _buildMoviesListView(BuildContext context, List<Movie> movies) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: movies.length,
      itemBuilder: (context, index) {
        return MovieItem(movies[index]);
      },
    );
  }


  Widget _moviesLoadingIndicator(BuildContext context, double progress) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Loading movies...'),
          LinearProgressIndicator(
            value: progress,
          )
        ],
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return stateBuilder<MoviesStateFiltered>(builder: (context, state) {
      return Column(
        children: <Widget>[
          _buildGenreSelector(context, state.genre),
          SizedBox(
            height: 10,
          ),
          _buildMoviesListView(context, state.movies),
        ],
      );
    });
  }

  @override
  Widget onPageInitializing(BuildContext context, StateLoading loadingData) {
    return _moviesLoadingIndicator(context, loadingData.progress);
  }
}
