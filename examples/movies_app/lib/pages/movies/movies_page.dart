import 'package:bloc_component/bloc_component.dart';
import 'package:flutter/material.dart';

import '../../app_conetxt/app_context.dart';
import '../../models/models.dart';
import '../../services/services.dart';
import '../base_page.dart';
import '../shared_components/shared_components.dart';
import 'movies_bloc.dart';


class MoviesPage extends BasePage {

  @override
  String get title => 'Movies';

  @override
  Widget buildContent(BuildContext context) {
    return MoviesComponent();
  }

}


class MoviesComponent extends Component<MoviesBloc> {
  @override
  ComponentView<MoviesBloc> createView(bloc) => MoviesView(bloc);

  @override
  MoviesBloc createBloc(BuildContext context) {
    return MoviesBloc(AppContext.locate<MoviesServices>())
      ..event(MoviesEventFilter(MovieGenre.thriller));
    }
}

class MoviesView extends ComponentView<MoviesBloc> {

  MoviesView(MoviesBloc bloc) : super(bloc);

  @override
  Widget onInitializing(BuildContext context, StateInitializing loadingData) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Loading movies...'),
            LinearProgressIndicator(
              value: loadingData.progress,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGenreSelector(BuildContext context, MovieGenre genre) {
    return DropdownButton<MovieGenre>(
      value: genre,
      onChanged: (genre) => bloc.event(MoviesEventFilter(genre)),
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

  @override
  Widget buildView(BuildContext context) {
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
}
